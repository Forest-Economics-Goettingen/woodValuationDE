##--######################################--##
#### Shares of Different Wood Assortments ####
##--######################################--##

#' Relative volume share of different assortments
#'
#' The function estimates the share of different assortments. It is expressed
#' in relation to the salable volume, i.e., the sum of pulp wood, saw log, and 
#' fuel wood assortments. The function is based on the assortment tables from 
#' Offer and Staupendahl (2018) and its derivation is similar to the approach
#' described in Fuchs et al. (2023) for the salable and skidded volume. The
#' underlying assortment tables are based on data from HessenForst, the public
#' forest service of the Federal State of Hesse in Germany. For further details
#' see the \pkg{woodValuationDE}
#' \href{https://github.com/Forest-Economics-Goettingen/woodValuationDE}{README}.
#'
#' @param diameter.q Quadratic mean of the diameter at breast height (dbh) of
#'                   the harvested trees \eqn{[cm]}{[cm]}.
#' @param species Tree species, using an available \code{species.code.type}. For
#'                a list with the available species and codes call
#'                \code{\link{get_species_codes}}.
#' @param assortment wood assortment whose share is sought, currently
#'                   implemented: \code{"saw.logs"}
#' @param value.level Stand quality expressed as an integer of \code{1:3}, with
#'                    \code{1} for an extraordinarily high stand quality with 
#'                    high shares of wood suitable for high-valued usages such
#'                    as furniture, \code{2} for a moderate quality, and
#'                    \code{3} for a low quality (e.g., trees with thick
#'                    branches). The \code{value.level}s refer to the applied
#'                    assortment tables of Offer and Staupendahl (2018).
#' @param logging.method Logging method, with \code{"manually"} for
#'                       motor-manual logging using a chain saw,
#'                       \code{"harvester"} for logging with highly mechanized
#'                       forest harvesters, or \code{"combined"} for a
#'                       combination of the previous methods dependent on the
#'                       mean diameter.
#' @param species.code.type Type of code in which \code{species} is given.
#'                          \code{"en"} for English species names or
#'                          \code{"nds"} for numeric species codes used in Lower
#'                          Saxony, Germany. For a list with the available
#'                          species and codes call
#'                          \code{\link{get_species_codes}}.
#' @param method argument that is currently not used, but offers the possibility
#'               to implement alternative parameters and functions in the
#'               future.
#' @return A vector with relative shares of the respective assortment's wood
#'         volume.
#' @references Fuchs, Jasper M.; Husmann, Kai; v. Bodelschwingh, Hilmar; Koster,
#'             Roman; Staupendahl, Kai; Offer, Armin; Moehring, Bernhard, Paul,
#'             Carola (2023): woodValuationDE: A consistent framework
#'             for calculating stumpage values in Germany (technical note).
#'             Allgemeine Forst- und Jagdzeitung 193 (1/2), p. 16-29.
#'             \doi{10.23765/afjz0002090}
#' @references Offer, Armin; Staupendahl, Kai (2018): Holzwerbungskosten- und
#'             Bestandessortentafeln (Wood Harvest Cost and Assortment
#'             Tables). Kassel: HessenForst (publisher).
#' @examples
#' # saw log volume per cubic meter salable volume
#' share.saw.logs <- vol_assortment(40,
#'                                  "beech",
#'                                  "saw.logs")
#' share.saw.logs
#' 
#' # fuel wood per cubic meter salable volume
#' share.fuel.wood <- (vol_salable(40,
#'                                 "beech") -
#'                       vol_skidded(40,
#'                                   "beech")) /
#'   vol_salable(40,
#'               "beech")
#' share.fuel.wood
#' 
#' # pulp wood per cubic meter salable volume
#' share.pulp.wood <- 1 - share.saw.logs - share.fuel.wood
#' 
#' # saw log volume per cubic meter volume over bark
#' vol_assortment(40,
#'                "beech",
#'                "saw.logs") *
#'   vol_salable(40,
#'               "beech")

#' @import dplyr
#'
#' @export
vol_assortment <- function(
    diameter.q,
    species,
    assortment,
    value.level = 2,
    logging.method = "combined",
    species.code.type = "en",
    method = "fuchs.orig"
) {
  
  vol.assortment <-
    tibble(diameter.q = diameter.q,
           species = species,
           value.level = value.level,
           logging.method = logging.method) %>%
    
    # assign the appropriate parameterized species (group)
    mutate(species = recode_species(species,
                                    species.code.type,
                                    "bodelschwingh.revenues")) %>%
    
    # add the specific parameters
    left_join(
      filter(
        params.wood.value$vol.assortment,
        assortment == assortment
      ),
      by = c("species" = "species.code",
             "logging.method" = "logging.method",
             "value.level" = "value.level")) %>%
    mutate(vol.assortment =
             .data$A *
             exp(-exp(.data$zm / .data$A *
                        exp(1) * (.data$tw - diameter.q))))
  
  # test whether the diameters are in the range of the original data sets
  if (any(vol.assortment$diameter.q < vol.assortment$min.dq) |
      any(vol.assortment$diameter.q > vol.assortment$max.dq)) {
    
    warning("Relative salable volume: At least one diameter leads to extrapolation!")
    
  }
  
  vol.assortment %>%
    pull(vol.assortment) %>%
    return()
  
}
