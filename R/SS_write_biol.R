#'Writes life history parameters
#'
#'@description Function to pull relevant life history parameters from atlantis to write to a Stock Synthesis control and/or data file.
#'@param ctl_obj list that is returned from \code{r4ss::read_ctl()} that contains the control file
#'@param biolprm_object list with a number of atlantis biological parameters
#'@param species_code the three-letter species code of the fish you are creating a model for
#'@param M_est scalar value for M of the species
#'@param wtsage two dimensional vector with column names agecl and meanwt giving mean body weight at age in grams
#'@param lenage three dimensional vector with column names agecl, meanln, and cvln giving mean body length and cv of body length at age
#'@return an updated ctl_obj that has replaced parameters with the atlantis-created ones
SS_write_biol <- function(ctl_obj, biolprm_object, species_code, M_est=NULL, wtsage, lensage, lenwt_a = NULL, lenwt_b = NULL){

  #vector of parameters needed
  needed_pars <- c("BHalpha","BHbeta","kgw2d","redfieldcn","maturityogive","fsp","kswr","kwrr", "wl")
  ind <- rep(0,length(needed_pars))

  #Extract needed parameters from a list and assign them to unique vars
  for(i in 1:length(needed_pars)){

  if(is.null(biolprm_object[needed_pars[i]])){
    stop(paste("Warning: the biolprm object is missing parameter",needed_pars[i],"- cannot write biology."))
  }
    if(length(biolprm[[needed_pars[i]]])==1){
      assign(needed_pars[i], biolprm[[needed_pars[i]]])
    } else{
    #index of the parameter object matching the species
  ind[i]<- which(biolprm[[needed_pars[i]]][,1]==species_code)

  if(is.null(ind[i])){stop(paste("Missing value for",needed_pars[i],"for species",species_code))}

  #assign to the right variable name
  assign(needed_pars[i], biolprm[[needed_pars[i]]][ind[i],-1])
    }
  }

  #Translate weight at age from grams to nitrogen
  wtsage_N <- wtsage %>%
    mutate(weight=meanwt*20*5.7)

  #Calculate recruitment parameters from atlantis values
  bh_lnro <- log(BHalpha) - log(kwrr+kswr)
  sb0 <- exp(bh_lnro)*sum(exp(-M_est*wtsage_N[,"agecl"])*fsp*wtsage_N[,"weight"]*as.numeric(t(maturityogive[-1])))
  b0 <- sum(exp(-Z*wtsage_N[,"agecl"])*exp(bh_lnro)*wtsage_N[,"weight"])
    bh_steepness <- ((kwrr+kswr)*0.2*sb0)/(BHbeta+0.2*sb0)

  ##Function that assigns ctl values to the ones from atlantis and sets phase and upper and lower bounds
  set_par_values <- function(X, name, value, phase){
    val <- unlist(value[X])
    assign(x ="ctl_obj$SRparm[name[X],\"INIT\"]",
           val, pos = 1)
    assign("ctl_obj$SRparm[name[X],\"LO\"]",
           val * .5, pos = 1)
    assign("ctl_obj$SRparm[name[X],\"HI\"]", val * 2,
           pos = 1)
    assign("ctl_obj$SRparm[name[X],\"PHASE\"]",
           phase[X])
    return(ctl_obj)
  }

  #Translate weight to length
  a1 <- round(ctl_obj$Growth_Age_for_L1,0)
  a2 <- round(ctl_obj$Growth_Age_for_L2,0)

  #Guess L1 and L2 values from the mean length at different age classes
  l1_guess <- lensage[which.min(abs(lensage$agecl-a1)),"meanln"]

  #Guess CV_young values from cv len at a1
  cvy_guess <-lensage[which.min(abs(lensage$agecl-a1)),"cvln"]/l1_guess

  #If Linf is used instead of L2, just pick max age
  if(a2==999){
    l2_guess <- last(lensage$meanln)
    } else{
    l2_guess <- lensage[which.min(abs(lensage$agecl-a2)),"meanln"]
    cvo_guess <- lensage[which.min(abs(lensage$agecl-a2)),"cvln"]
    }

  #Fill in optional values
  if(is.null(lenwt_a)){
    lenwt_a <- wl[1]
  }

  if(is.null(lenwt_b)){
    lenwt_b <- wl[2]
  }

  if(is.null(M_est)){
    M_est <- 0.2
  }

  ctl_names <- c("SR_LN(R0)", "SR_BH_steep",
                 "Wtlen_1_Fem", "Wtlen_2_Fem",
                 "NatM_p_1_Fem_GP_1",
                 "L_at_Amin__Fem_GP_1",
                 "L_at_Amin__Fem_GP_1",
                 "VonBert_K__Fem_GP_1",
                 "CV_young__Fem_GP_1",
                 "CV_old__Fem_GP_1")

  ctl_values <- c(bh_lnro, bh_steepness,
                  lenwt_a,
                  lenwt_b, M_est,
                  l1_guess, l2_guess,
                  0.4, cvy_guess, cvo_guess)

  #Should the phases be automated?
  ctl_phases <- c(rep(-1,5), rep(3,3), -1,-1)

  #Assign control file values
  lapply(X= 1:length(ctl_names), set_par_values,
         name = ctl_names, value = ctl_values,
         phase = ctl_phases)

  # Write maturity ogive to the control file


 return(ctl_obj)

}
