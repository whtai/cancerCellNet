#' @title
#' Broad Class Training
#' @description
#' Tranining broad class classifier
#' @param stTrain a dataframe that matches the samples with category
#' @param expTrain the expression matrix
#' @param colName_cat the name of the column that contains categories
#' @param colName_samp the name of the column that contains sample names
#' @param nTopGenes the number of classification genes per category
#' @param nTopGenePairs the number of top gene pairs per category
#' @param nRand number of random profiles generate for training
#' @param nTrees number of trees for random forest classifier
#' @param stratify TRUE if stratified sampling
#' @param sampsize sample size for stratified sampling
#' @param weightDown_total numeric post transformation sum of read counts for weighted_down function
#' @param weightedDown_dThresh the threshold at which anything lower than that is 0 for weighted_down function
#' @param transprop_xFact scaling factor for transprop
#' @param quickPairs TRUE if using quick version of genepair transform
#'
#' @return a list containing normalized expression data, classification gene list, cnPRoc
#' @export
broadClass_train<-function(stTrain, expTrain, colName_cat, colName_samp="row.names", nTopGenes = 20, nTopGenePairs = 50, nRand = 40, nTrees = 1000, stratify=FALSE, sampsize=40, weightedDown_total = 5e5, weightedDown_dThresh = 0.25, transprop_xFact = 1e5, quickPairs = FALSE) {

   if (class(stTrain) != "data.frame") {
      stTrain = as.data.frame(stTrain)
   }

   if (colName_samp != "row.names") {
     rownames(stTrain) = stTrain[, colName_samp]
   }

   cat("Sample table has been prepared\n")

   expTnorm = trans_prop(weighted_down(expTrain, weightedDown_total, dThresh = weightedDown_dThresh), transprop_xFact)
   cat("Expression data has been normalized\n")

   system.time(cgenes<-findClassyGenes(expDat = expTnorm, sampTab = stTrain, dLevel = colName_cat, topX = nTopGenes))
   cat("Finished finding classification genes\n")

   cgenesA = cgenes[['cgenes']]
   grps = cgenes[['grps']]
   cgenes_list = cgenes[['labelled_cgenes']]

   cat("There are ", length(cgenesA), " classification genes\n")

   system.time(xpairs_list<-ptGetTop(expTrain[cgenesA,], grps, cgenes_list, topX=nTopGenePairs, sliceSize=2000, quickPairs=quickPairs))
   cat("Finished finding top gene pairs\n")

   # compile the genepair list
   xpairs = c()
   for(item in xpairs_list) {
      xpairs = c(xpairs, item)
   }

   xpairs = names(xpairs)
   xpairs = unique(xpairs)

   # some of these might include selection cassettes; remove them
   xi = setdiff(1:length(xpairs), grep("selection", xpairs))
   xpairs = xpairs[xi]

   system.time(pdTrain<-query_transform(expTrain[cgenesA, ], xpairs))
   cat("Finished pair transforming the data\n")

   tspRF = makeClassifier(pdTrain[xpairs,], genes=xpairs, groups=grps, nRand = nRand, ntrees = nTrees, stratify=stratify, sampsize=sampsize)
   cnProc = list("cgenes"= cgenesA, "xpairs"=xpairs, "grps"= grps, "classifier" = tspRF)

   returnList = list("sampTab" = stTrain, "cgenes_list" = cgenes_list, "cnProc" = cnProc, "xpairs_list" = xpairs_list)

   cat("All Done\n")
   #return
   returnList
}
