% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_Z.R
\name{calc_Z}
\alias{calc_Z}
\title{Calculate total mortality for age structured groups}
\usage{
calc_Z(YOY, Nums, species.code)
}
\arguments{
\item{YOY}{File name of the YOY.txt file}

\item{Nums}{Object containing the number at stage.}

\item{species.code}{Species specific code to extract the data from YOY.}
}
\value{
A data table with the time varying Z.
}
\description{
This function uses the YOY.txt and Nums to calculate Z.
}
\author{
Sean Lucey
}
\seealso{
Other calc functions: \code{\link{calc_biomass_age}},
  \code{\link{calc_stage2age}}, \code{\link{convert_time}}
}
