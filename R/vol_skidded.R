##--##############################--##
#### Share of skidded wood volume ####
##--##############################--##

#' Share of standing tree volume which is skidded
#'
#' The function estimates the share of standing wood volume which is skidded.
#' This is the share of salable volume, but excluding private fuel wood since
#' this is not commercially skidded. The share of skidded wood is required to
#' derive the harvest costs per unit standing volume. The function is based on
#' the assortment tables of Offer and Staupendahl (2018) and its derivation is
#' described in Fuchs et al. (in preparation). The underlying assortment tables
#' are based on data of HessenForst, the forest administration of the Federal
#' State of Hesse in Germany. For further details see the \pkg{woodValuationDE}
#' readme.
#'
#' @param diameter.q Quadratic mean of the diameter at breast height (dbh) of
#'                   the harvested trees \eqn{[cm]}{[cm]}.
#' @param species Tree species, using an available \code{species.code.type}. For
#'                a list with the available species and codes call
#'                \code{\link{get_species_codes}}.
#' @param value.level Stand quality expressed as integer of \code{1:3}, with
#'                    \code{1} for an extraordinary high stand quality with high
#'                    shares of wood suitable for furniture, \code{2} for an
#'                    average quality, and \code{3} for an extraordinary low
#'                    quality (e.g. trees with many thick branches or stands
#'                    with massive ungulate damages). The value.levels refer to
#'                    the applied assortment tables (Offer and Staupendahl,
#'                    2018).
#' @param process.type Type of harvest process, with \code{"manually"} for
#'                     motor-manual harvest using a chain saw,
#'                     \code{"harvester"} for highly mechanized harvest
#'                     machines, or \code{"combined"} for a combination of the
#'                     previous types dependent on the mean diameter.
#' @param species.code.type Type of code in which \code{species} is given.
#'                          \code{"en"} for English species names or
#'                          \code{"nds"} for numeric species codes used in Lower
#'                          Saxony, Germany. For a list with the available
#'                          species and codes call
#'                          \code{\link{get_species_codes}}.
#' @return A vector with relative shares of skidded wood volume.
#' @references Fuchs, Jasper M., von Bodelschwingh, Hilmar, Paul, Carola,
#'             Husmann, Kai (in preparation): Applying Time Series Analysis to
#'             Quantify the Impact of Quality and Supply Changes After
#'             Disturbances on Wood Revenues.
#' @references Offer, Armin and Staupendahl, Kai (2018): Holzwerbungskosten- und
#'             Bestandessortentafeln (Wood Harvest Cost and Assortment
#'             Tables). Kassel: HessenForst (publisher).
#' @examples
#' vol_skidded(40,
#'             "beech")
#'
#' # species codes Lower Saxony (Germany)
#' vol_skidded(40,
#'             211,
#'             species.code.type = "nds")
#'
#' # vector input
#' vol_skidded(seq(20, 50, 5),
#'             "spruce")
#'
#' vol_skidded(rep(seq(20, 50, 10),
#'                 2),
#'             rep(c("beech", "spruce"),
#'                 each = 4))
#'
#' vol_skidded(rep(seq(20, 50, 10),
#'                 2),
#'             rep(c("beech", "spruce"),
#'                 each = 4),
#'             process.type = rep(c("manually", "harvester"),
#'                                each = 4))

#' @import dplyr
#'
#' @export
vol_skidded <- function(
  diameter.q,
  species,
  value.level = 2,
  process.type = "combined",
  species.code.type = "en"
) {

  vol.skidded <-
    tibble(diameter.q = diameter.q,
           species = species,
           value.level = value.level,
           process.type = process.type) %>%

    # assign the appropriate parameterized species (group)
    mutate(species = recode_species(species,
                                    species.code.type,
                                    "bodelschwingh.revenues")) %>%

    # add the specific parameters
    left_join(params.wood.value$vol.skidded,
              by = c("species" = "species.code",
                     "process.type" = "process.type",
                     "value.level" = "value.level")) %>%
    mutate(vol.skidded =
             .data$A *
             exp(-exp(.data$zm / .data$A *
                        exp(1) * (.data$tw - diameter.q))))

  # test whether the diameters are in the range of the original data sets
  if (any(vol.skidded$diameter.q < vol.skidded$min.dq) |
      any(vol.skidded$diameter.q > vol.skidded$max.dq)) {

    warning("Relative skidded volume: At least one diameter leads to extrapolation!")

  }

  vol.skidded %>%
    pull(vol.skidded) %>%
    return()

}
