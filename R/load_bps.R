#' Extracts the names of the epibenthic biomasspools
#' from the initial conditions file.
#'
#' Use \code{file_fgs} \code{data.frame} (this function will call \code{load_fgs})
#' to get the biomass pool information.
#'
#' @template dir
#' @template file_fgs
#' @template file_init
#'
#' @author Alexander Keth
#' @export
#' @family load functions
#' @seealso \code{\link{load_fgs}}
#'
#' @return A \code{vector} of biomass pools.
#'
#' @examples
#' d <- system.file("extdata", "SETAS_Example", package = "atlantisom")
#' bps <- load_bps(dir = d, fgs = "Functional_groups.csv", file_init = "Initial_condition.nc")
#'
load_bps <- function(dir = getwd(), fgs, file_init){
  if (strsplit(file_init, "\\.")[[1]][2] != "nc") {
    stop(paste("The file_init argument", file_init, "does not end in .nc"))
  }
  if (is.null(dir)) {
    file.init <- file_init
  } else {
    file.init <- file.path(dir, file_init)
  }
  init <- RNetCDF::open.nc(con = file.init)
  on.exit(RNetCDF::close.nc(init))

  fgs <- load_fgs(dir, fgs)
  all_groups <- fgs$Name
  init_vars <- sapply(seq_len(RNetCDF::file.inq.nc(init)$nvars - 1),
                      function(x) RNetCDF::var.inq.nc(init, x)$name)

  search_string <- paste(all_groups, "N", sep = "_")
  search_string <- search_string[is.element(search_string, init_vars)]

  groups <- substr(x = search_string, start = 1, stop = nchar(search_string) - 2)

  bps_id <- vector()
  for (i in seq_along(search_string)){
    bps_id[i] <- RNetCDF::var.inq.nc(ncfile = init, variable = search_string[i])$ndims
  }
  bps_id <- which(bps_id == 2)

  bps <- groups[bps_id]
  return(bps)
}
