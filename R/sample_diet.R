#' @title Sample total consumption to create diet composition data
#'
#' @description Create sampled diet composition data from the total consumption
#'    in an Atlantis scenario. Observation error and bias are added.
#'
#' @details The function takes total consumption data from an Atlantis scenario
#'   where the data was read in from Atlantis output using \code{???}. One does
#'   not need to use these functions to create \code{dat}, rather you must only
#'   ensure that the structure of \code{dat} is the same.
#'   Currently, the function creates sampled diet composition by removing
#'   non-sampled and non-enumerated species groups from the total
#'   consumption table from Atlantis.
#'   Bias is added by setting infrequently consumed (<0.25) prey groups to
#'   zero at random.
#'   Error is incorporated into proportional composition entries by
#'   adding uniform error to true values to half of the observations.
#'   The function adjusts the remaining table so each row sums to one
#'   before returning the "observed" mean diet composition summary table.
#'   The function needs to be generalized to any Atlantis system by
#'   selecting common species group identifiers to remove from the table.
#'   Also, more realistic observation error and bias distributions
#'   could be applied to obtain realistic diet composition data.

#' @author Robert Wildermuth
#' @export
#' @param dat A \code{data.frame} containing sampled predator species
#'   identifiers  in the first
#'   column and prey species consumption proportions in the remaining columns.
#' @template fgs
#'
#' @examples
#' \dontrun{
#'		d <- system.file("extdata", "SETAS_Example", package = "atlantisom")
#'		groups <- load_fgs(dir = directory, "Functional_groups.csv")
#'		groups <- groups[groups$IsTurnedOn > 0, "Name"]
#'		results <- run_truth(scenario = "outputs",
#'		dir = d,
#'		file_fgs = "Functional_groups.csv",
#'		file_bgm = "Geography.bgm",
#'		select_groups = groups,
#'		file_init = "Initial_condition.nc",
#'		file_biolprm = "Biology.prm",
#'		file_runprm = "Run_settings.xml",
#'    file_fish = "Fisheries.csv")
#'
#'		# rows should each sum to one:
#'		rowSums(dat[,2:NCOL(dat)])
#'		dim(dat)
#'
#'		obsDietComp <- sample_diet(dat)
#'		dim(obsDietComp)
#'}

sample_diet <- function(dat, fgs) {

  # first remove species not sampled and not quantified in gut analyses
  colnames(fgs) <- tolower(colnames(fgs))
  # check for GroupType
  if (!"grouptype" %in% colnames(fgs)) {
    stop(paste("The column GroupType is not in your functional groups\n",
      "file and thus sample_diet does not know which groups to sample.\n",
      "The column InvertType might work but needs to be renamed GroupType."))
  }
  fgs$grouptype <- tolower(fgs$grouptype)
  nonsampledtypes <- c("bird", "mammal", "cep", "sed_ep_ff", "sed_ep_other",
    "mob_ep_other", "pwn", "lg_zoo", "lg_inf", "phytoben")
  nonSampled <- subset(fgs, isfished == 0 | grouptype %in% nonsampledtypes |
    code == "REP")
  notenumeratedtypes <- c("bird", "mammal", "cep", "sed_ep_other", "lg_zoo",
    "lg_inf", "phytoben")
  notEnum <- subset(fgs, grouptype %in% notenumeratedtypes | code == "BFF")

  dat <- dat[!(dat$Predator %in% nonSampled), !(colnames(dat) %in% notEnum)]

  # add uniform error to half of the "observations"
  nPreyObs <- NROW(dat) * (NCOL(dat)-1)
  for(obs in 1:(nPreyObs/2)){
    # determine row and column indices
    rowR <- sample(1:NROW(dat), 1)
    colC <- sample(2:NCOL(dat), 1)

    dat[rowR, colC] <- dat[rowR, colC] + runif(1, -0.1, 0.1)
  }

  # add bias by removing little-observed prey at random
  for(i in 1:NROW(dat)){
    for(j in 2:NCOL(dat)){
      if(dat[i,j] < 0.25 & runif(1) < 0.15){
        dat[i,j] <- 0
      }
    }
  }

  # recalibrate so that rows add to 1
  # first need to adjust/account for negative values
  baseAdd <- min(dat[,2:NCOL(dat)])
  if(baseAdd < 0){

    for(i in 1:NROW(dat)){
      for(j in 2:NCOL(dat)){
        if(dat[i,j] != 0){
          dat[i,j] <- dat[i,j]-baseAdd
        }
      }
    }

  }


  for(r in 1:NROW(dat)){

    denom <- rowSums(dat[r,2:NCOL(dat)])
    dat[r,2:NCOL(dat)] <- (dat[r,2:NCOL(dat)])/denom
  }

  return(dat)
}


