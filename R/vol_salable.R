##--##############################--##
#### Share of Salable Wood Volume ####
##--##############################--##

#' Relative share of the volume over bark that is salable
#'
#' The function estimates the salable share of the wood volume. It is expressed
#' in relation to the volume over bark (German unit: Vfm) as usually provided by
#' yield tables and forest simulators. This includes all pulp wood, sawlog,
#' and fuel wood assortments. The share of salable wood is required to derive
#' the wood revenues per cubic meter volume over bark. The function is based on
#' the assortment tables from Offer and Staupendahl (2018) and its derivation is
#' described in Fuchs et al. (in preparation). The underlying assortment tables
#' are based on data from HessenForst, the public forest service of the Federal
#' State of Hesse in Germany. For further details see the \pkg{woodValuationDE}
#' \href{https://github.com/Forest-Economics-Goettingen/woodValuationDE}{readme}.
#'
#' @param diameter.q Quadratic mean of the diameter at breast height (dbh) of
#'                   the harvested trees \eqn{[cm]}{[cm]}.
#' @param species Tree species, using an available \code{species.code.type}. For
#'                a list with the available species and codes call
#'                \code{\link{get_species_codes}}.
#' @param value.level Stand quality expressed as an integer of \code{1:3}, with
#'                    \code{1} for an extraordinarily high stand quality with 
#'                    high shares of wood suitable for high-valued usages such
#'                    as furniture, \code{2} for a moderate quality, and
#'                    \code{3} for a low quality (e.g., trees with thick
#'                    branches). The \code{value.level}s refer to the applied
#'                    assortment tables of Offer and Staupendah (2018).
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
#' @return A vector with relative shares of salable wood volume.
#' @references Fuchs, Jasper M.; Husmann, Kai; v. Bodelschwingh, Hilmar; Koster,
#'             Roman; Staupendahl, Kai; Offer, Armin; Moehring, Bernhard, Paul,
#'             Carola (in preparation): woodValuationDE: A consistent framework
#'             for wood valuation in Germany (technical note)
#' @references Offer, Armin; Staupendahl, Kai (2018): Holzwerbungskosten- und
#'             Bestandessortentafeln (Wood Harvest Cost and Assortment
#'             Tables). Kassel: HessenForst (publisher).
#' @examples
#' vol_salable(40,
#'             "beech")
#'
#' # species codes Lower Saxony (Germany)
#' vol_salable(40,
#'             211,
#'             species.code.type = "nds")
#'
#' # vector input
#' vol_salable(seq(20, 50, 5),
#'             "spruce")
#'
#' vol_salable(rep(seq(20, 50, 10),
#'                 2),
#'             rep(c("beech", "spruce"),
#'                 each = 4))
#'
#' vol_salable(rep(seq(20, 50, 10),
#'                 2),
#'             rep(c("beech", "spruce"),
#'                 each = 4),
#'             logging.method = rep(c("manually", "harvester"),
#'                                  each = 4))

#' @import dplyr
#'
#' @export
vol_salable <- function(
  diameter.q,
  species,
  value.level = 2,
  logging.method = "combined",
  species.code.type = "en",
  method = "fuchs.orig"
) {

  vol.salable <-
    tibble(diameter.q = diameter.q,
           species = species,
           value.level = value.level,
           logging.method = logging.method) %>%

    # assign the appropriate parameterized species (group)
    mutate(species = recode_species(species,
                                    species.code.type,
                                    "bodelschwingh.revenues")) %>%

    # add the specific parameters
    left_join(params.wood.value$vol.salable,
              by = c("species" = "species.code",
                     "logging.method" = "logging.method",
                     "value.level" = "value.level")) %>%
    mutate(vol.salable =
             .data$A *
             exp(-exp(.data$zm / .data$A *
                        exp(1) * (.data$tw - diameter.q))))

  # test whether the diameters are in the range of the original data sets
  if (any(vol.salable$diameter.q < vol.salable$min.dq) |
      any(vol.salable$diameter.q > vol.salable$max.dq)) {

    warning("Relative salable volume: At least one diameter leads to extrapolation!")

  }

  vol.salable %>%
    pull(vol.salable) %>%
    return()

}
