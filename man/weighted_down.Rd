% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/weighted_down.R
\name{weighted_down}
\alias{weighted_down}
\title{Down Sample Gene Expressions}
\usage{
weighted_down(expRaw, total = 1e+05, dThresh = 0)
}
\arguments{
\item{expRaw}{matrix of total mapped reads per gene/transcript}

\item{total}{numeric post transformation sum of read counts}

\item{dThresh}{the threshold at which anything lower than that is 0}
}
\value{
matrix of downsampled read mapped to genes/transcripts
}
\description{
Weighted subtraction from mapped reads and simulate expression profile of  _total_ mapped reads
for normalization.
}
