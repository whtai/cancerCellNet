% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grn_construction.R
\name{ccn_findSpecGenes}
\alias{ccn_findSpecGenes}
\title{find genes that are preferentially expressed in specified samples}
\usage{
ccn_findSpecGenes(expDat, sampTab, holm = 1e-04, cval = 0.4,
  dLevel = "description1", prune = FALSE)
}
\arguments{
\item{expDat}{expression matrix}

\item{sampTab}{sample table}

\item{holm}{sig threshold}

\item{cval}{R thresh}

\item{dLevel}{annotation level to group on}

\item{prune}{boolean limit to genes exclusively detected as CT in one CT}
}
\value{
a list of something
}
\description{
find genes that are preferentially expressed in specified samples
}
