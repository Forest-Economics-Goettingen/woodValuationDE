##--#########################################--##
#### Available Species Codes and Assignments ####
##--#########################################--##

#' Available species, codes, and assignments in \pkg{woodValuationDE}
#'
#' The function shows the availabe species, species codes and species
#' assignments to groups for the economic valuation in order to inform the users
#' for their own applications.
#'
#' @return A list with the species, species codes, and assignments to economic
#'         species groups available in \pkg{woodValuationDE}.
#' @examples
#' get_species_codes()

#' @import dplyr
#'
#' @export
get_species_codes <- function() {

  list(
    species = dplyr::select(params.wood.value$species.codes,
                            "species.code.nds",
                            "species.code.en",
                            "name.scientific"),
    codes = c("english.species.names" = "en",
              "species.codes.used.in.lower.saxony" = "nds"),
    econ.assignments = dplyr::select(params.wood.value$species.codes,
                                     "species.code.nds",
                                     "species.code.bodelschwingh.revenues",
                                     "species.code.bodelschwingh.costs",
                                     "species.code.calamity.group")
  ) %>%
    return()

}

