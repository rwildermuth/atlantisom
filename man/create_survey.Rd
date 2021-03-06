% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_survey.R
\name{create_survey}
\alias{create_survey}
\title{Create survey observations from Atlantis output}
\usage{
create_survey(dat, time, species, boxes, effic, selex)
}
\arguments{
\item{dat}{A \code{data.frame} of numbers at age containing the following columns:
\itemize{
  \item{species}
  \item{agecl}
  \item{polygon}
  \item{layer}
  \item{time}
  \item{atoutput}
}
The \code{data.frame} is generated from either \code{\link{create_survey}}
or \code{\link{create_fishery_subset}}.}

\item{time}{The timing of the survey (a vector indicating specific time steps, which are typically associated with years)
i.e., seq(365,10*3650,365) would be an annual survey for 10 years}

\item{species}{The species to sample in the survey (a vector)}

\item{boxes}{A matrix with two columns:
1) polygon:  box ID's that are sampled
2) survArea: area sampled in that box}

\item{effic}{Efficiency for each species: a matrix with nrow=length(species). Columns:
 species:    the species name. Matches names in species
efficiency:}

\item{selex}{Selectivity at age. A dataframe defining selectivity at age for each species. Columns are:
species: the species name. Matches names in species
agecl:   the age class that selectivity represents
selex:   the proportion selected relative to fully selected age classes (between 0 and 1)}

\item{spex}{The specifications of Atlantis model (box-specific area, habitat, etc.)
for now, from load_boxarea a dataframe with polygon and area column names}
}
\value{
Returns a matrix similar to the input matrix
columns: species, agecl, polygon, layer, time, atoutput
--will sum over layers, but enter NA as layer to indicate all layers
}
\description{
Create survey observations from Atlantis output
}
\details{
The function takes numbers-at-age data from an Atlantis scenario
  where the data was read in from Atlantis output using \code{\link{load_nc}}
  within \code{\link{run_truth}}. One does not need to use these functions
  to create \code{dat}, rather you must only ensure that the structure of
  \code{dat} is the same.
  Currently, the function subsets the data by polygon and time,
  and sums over layers.  An efficiency (\code{effic}) parameter is applied
  that determines that proportion of fully selected fish that are captured
  by the survey, then selectivity-at-age is applied.
  This function works for specific defined species, specific defined polygons,
  and specific defined time.
}
\author{
Poseidon
}
