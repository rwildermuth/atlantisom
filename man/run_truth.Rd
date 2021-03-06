% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/run_truth.R
\name{run_truth}
\alias{run_truth}
\title{Load Atlantis scenario output}
\usage{
run_truth(
  scenario,
  dir = getwd(),
  file_fgs,
  file_bgm,
  select_groups,
  file_init,
  file_biolprm,
  file_runprm,
  file_fish,
  verbose = FALSE,
  save = TRUE,
  annage = FALSE
)
}
\arguments{
\item{scenario}{A character value, specifying the Atlantis scenario name.
More specifically the name which Atlantis uses to name all of the
output files. The value will be used to search for files specified in
\code{dir}, if \code{dir} is also a function argument.}

\item{dir}{The directory of the atlantis model output, where the
default is \code{getwd()}.}

\item{file_fgs}{A character value specifying the file name of the Atlantis
functional groups file. The file should be located in your current working
directory or the folder you specify in \code{dir}.
The argument can also be specified as the full path name, just as long as
argument \code{dir} is specified as \code{NULL}.
Usually, the filename is \code{"functionalGroups.csv"}.}

\item{file_bgm}{A character value specifying the file name of a \code{.bgm}
file, which contains information on box locations for an Atlantis scenario.
The file should be located in your current working directory or the
folder you specify in \code{dir}.
The argument can also be specified as the full path name, just as long as
argument \code{dir} is specified as \code{NULL}.}

\item{select_groups}{Character vector of funtional groups to select.
Names have to match the ones used in the ncdf file, and therefore must
be in the column \code{"Name"} in the \code{fgs}.}

\item{file_init}{A character value giving the file name of the intial conditions
file. The file should be located in your current working directory or the
folder you specify in \code{dir}.
The argument can also be specified as the full path name, just as long as
argument \code{dir} is specified as \code{NULL}.
Usually the file is named \code{"init[...].nc".}, but it must end in \code{.nc}.}

\item{file_biolprm}{A character value giving the file name of the biology
\code{.prm} file.
The file should be located in your current working directory or the
folder you specify in \code{dir}.
The argument can also be specified as the full path name, just as long as
argument \code{dir} is specified as \code{NULL}.
Usually the file is named \code{"[...]_Biol.prm".}.}

\item{file_runprm}{A character value giving the file name of the biology
\code{.xml} file.
The file should be located in your current working directory or the
folder you specify in \code{dir}.
The argument can also be specified as the full path name, just as long as
argument \code{dir} is specified as \code{NULL}.
Usually the file is named \code{"[...]_run.xml".}.
This file is output from an Atlantis run in a standard format and is based
on input from the \code{"[...]_run.prm"} file.}

\item{verbose}{A logical value specifying if output should be written
to the screen or not. The default value is \code{FALSE}.}

\item{A}{logical value specifying if the function should save the output
to the disk or not. The default is \code{TRUE}.}
}
\value{
Returns a list object.
}
\description{
Reads in data generated from an Atlantis scenario and returns a list
containing the desired information. The list contains the 'truth' as known
from the Atlantis scenario. The truth can later be sampled
from to create a data set with observation error.
Currently, the \code{run_truth} depends on the following files
being in your working directory (\code{dir}):
\itemize{
 \item{"functionalGroups.csv"}
 \item{"[...]TOTCATCH.nc"}
 \item{"[...]DietCheck.txt"}
},
where [...] specifies the entry used for the \code{scenario} argument.
}
\examples{
d <- system.file("extdata", "SETAS_Example", package = "atlantisom")
groups <- load_fgs(dir = d, "Functional_groups.csv")
truth <- run_truth(scenario = "outputs",
  dir = d,
  file_fgs = "Functional_groups.csv",
  file_bgm = "Geography.bgm",
  select_groups = groups[groups$IsTurnedOn > 0, "Name"],
  file_init = "Initial_condition.nc",
  file_biolprm = "Biology.prm",
  file_runprm = "Run_settings.xml",
  file_fish = "Fisheries.csv")
str(truth)
rm(truth)

}
\author{
Sean Lucey, Kelli Faye Johnson
}
\concept{run functions}
