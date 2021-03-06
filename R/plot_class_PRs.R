#' @title
#' Plot precision recall curve per category
#' @description
#' Plotting the results of ccn_classAssess
#' @param assessed result of running \code{\link{ccn_classAssess}}
#' @return ggplot pbject
#'
#' @examples
#' testAssTues<-cn_splitMakeAssess(stTrain, expTrain, ctGRNs, prop=.5)
#' plot_class_PRs(testAssTues$ROCs)
#'
#' @import ggplot2
#' @export
plot_class_PRs<-function(assessed){
  ctts<-names(assessed)
  df<-data.frame()
  for(ctt in ctts){
    # to check if the category has a PR representation in validation
    if(max(assessed[[ctt]][,'TP']) == 0){
      next
    }

    tmp<-assessed[[ctt]]
    tmp<-cbind(tmp, ctype=ctt)
    df<-rbind(df, tmp)
  }

  #return
  ggplot2::ggplot(data=df, aes(x=Sens, y=Prec)) + geom_point(size = .5, alpha=.5) +  geom_path(size=.5, alpha=.75) +
    theme_bw() + xlab("Recall") + ylab("Precision") + facet_wrap( ~ ctype, ncol=4) +
    theme(axis.text = element_text(size=5)) + ggtitle("Classifier performance")
}
