
#gets run parameter list object for neus v1 run based on historical period
load_neus_v1_runprm <- function() {
  run <- list(
    toutstart = 1,
    toutinc = 90,
    toutfinc = 90,
    tstop = 18260,
    nyears = 50,
    timestep = 12,
    timestepunit = "Hours",
    outputstep = 90,
    outputstepunit = "days",
    hemisphere = "northern",
    nspp = 67,
    nfleet = 33
  )
  return(run)
}

#run_prm <- load_neus_v1_runprm()
