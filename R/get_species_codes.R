##--#########################################--##
#### Available Species Codes and Assignments ####
##--#########################################--##

#' Available species in \pkg{woodValuationDE}, their codes, and parameter assignments
#'
#' The function shows the available species, species codes, and species
#' assignments to groups for the economic valuation. This information is
#' provided to inform users for their own applications.
#'
#' @param method argument that is currently not used, but offers the possibility
#'               to implement alternative parameters and functions in the
#'               future.
#' @return A list with the species, species codes, and assignments to economic
#'         species groups available in \pkg{woodValuationDE}.
#' @examples
#' get_species_codes()

#' @import dplyr
#'
#' @export
get_species_codes <- function(method = "fuchs.orig") {

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

