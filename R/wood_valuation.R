##--################--##
#### Wood Valuation ####
##--################--##

#' All steps of the monetary valuation of standing wood
#'
#' The function is a wrapper for the entire procedure of wood valuation provided
#' by \pkg{woodValuationDE}. It estimates the share of salable (for revenues) and
#' skidded (for harvest costs) volume as well as the wood revenues and harvest
#' costs. Finally, it derives the net revenues for the user-provided standing
#' wood volume. The underlying functions were derived based on data of
#' HessenForst, the forest administration of the Federal State of Hesse in
#' Germany. For further details see the \pkg{woodValuationDE} readme.
#'
#' @param volume Wood volume \eqn{[m^{3}]}{[m^3]}, referring to standing tree
#'               volume before the harvest.
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
#' @param cost.level  Accessibility of the stand for harvest operations
#'                    expressed as integer of \code{1:3}, with \code{1} for
#'                    standard conditions without limitations, \code{2} for
#'                    moist sites or sites with a slope between 36 \% and 58 \%,
#'                    and \code{3} for slopes > 58 \%. The cost.levels refer to
#'                    the harvest cost model by von Bodelschwingh (2018).
#' @param process.type Type of harvest process, with \code{"manually"} for
#'                     motor-manual harvest using a chain saw,
#'                     \code{"harvester"} for highly mechanized harvest
#'                     machines, or \code{"combined"} for a combination of the
#'                     previous types dependent on the mean diameter.
#' @param price.ref.assortment Wood price of the reference assortments allowing
#'                     to consider market fluctuations. Default is
#'                     \code{"baseline"} referring to the prices from 2010 to
#'                     2015 in Hesse, Germany (for details see readme of
#'                     \pkg{woodValuationDE} or von Bodelschwingh (2018)).
#'                     Alternatively, it can be user-provided tibble with the
#'                     same structure. Column species uses the specified
#'                     \code{species.code.type}.
#' @param calamity.type Type of a potential calamity determining the applied
#'                      calamity corrections, which implement reduced returns
#'                      and higher harvest costs. By default no calamity is
#'                      assumed \code{"none"}; \code{"calamity.dieter.2001"}
#'                      refers to a general larger calamity applying the
#'                      corrections according to Dieter (2001); five parameter
#'                      sets were implemented according to Moellmann and
#'                      Moehring (2017): \code{fire.small.moellmann} refers to
#'                      damages of only some trees by fire (only conifers) while
#'                      \code{fire.large.moellmann} assumes that at least one
#'                      compartment was affected, the same applies for
#'                      \code{storm.small.moellmann} and
#'                      \code{storm.large.moellmann} referring to damages by
#'                      storm (available for coniferous and deciduous species),
#'                      \code{insects.moellmann} refers to damages by insects;                      
#'                      \code{"ips"} refers to quality losses due to
#'                      infestations by the European spruce bark beetle or
#'                      \code{"ips.timely"} for timely salvage fellings in less
#'                      advanced attack stages (both according to Fuchs et al.
#'                      under review); and \code{"stand.damage.fuchs"} to
#'                      disturbances affecting only one stand,
#'                      \code{"regional.calamity.fuchs"} to calamities with
#'                      regional market effects and
#'                      \code{"national.calamity.fuchs"} to calamities affecting
#'                      (inter)national wood markets (the last three referring
#'                      to Fuchs et al. in preparation). User-defined types can
#'                      be implemented via the \code{calamity.factors}
#'                      parameter.
#' @param calamity.factors Summands \eqn{[EUR m^{-3}]}{[EUR m^(-3)]}
#'                         and factors to consider the consequences of
#'                         calamities on wood revenues and harvest costs.
#'                         \code{"baseline"} provides a tibble based on the
#'                         references listed in \code{calamity.type} (for
#'                         details see readme of \pkg{woodValuationDE}).
#'                         Alternatively, it can be user-provided tibble with
#'                         the same structure.
#' @param species.code.type Type of code in which \code{species} is given.
#'                          \code{"en"} for English species names or
#'                          \code{"nds"} for numeric species codes used in Lower
#'                          Saxony, Germany. For a list with the available
#'                          species and codes call
#'                          \code{\link{get_species_codes}}.
#' @return A tibble with all steps of the wood valuation (volume reductions,
#'         harvest costs, wood revenues \eqn{[EUR m^{-3}]}{[EUR m^(-3)]} and
#'         total net revenues \eqn{[EUR]}{[EUR]}).
#' @references Dieter, Matthias (2001): Land expectation values for spruce and
#'             beech calculated with Monte Carlo modelling techniques. For.
#'             Policy Econ. 2 (2), S. 157-166.
#'             \doi{10.1016/S1389-9341(01)00045-4}.
#' @references Fuchs, Jasper M., Hittenbeck, Anika, Brandl, Susanne, Schmidt,
#'             Matthias, Paul, Carola (under review): Adaptation Strategies for
#'             Spruce Forests - Economic Potential of Bark Beetle Management and
#'             Douglas Fir Cultivation in Future Tree Species Portfolios.
#' @references Fuchs, Jasper M., von Bodelschwingh, Hilmar, Paul, Carola,
#'             Husmann, Kai (in preparation): Applying Time Series Analysis to
#'             Quantify the Impact of Quality and Supply Changes After
#'             Disturbances on Wood Revenues.
#' @references Moellmann, Torsten B., Moehring, Bernhard (2017): A practical way
#'             to integrate risk in forest management decisions. Ann. For. Sci.
#'             74 (4), S.75.
#' @references Offer, Armin and Staupendahl, Kai (2018): Holzwerbungskosten- und
#'             Bestandessortentafeln (Wood Harvest Cost and Assortment
#'             Tables). Kassel: HessenForst (publisher).
#' @references von Bodelschwingh, Hilmar (2018): Oekonomische Potentiale von
#'             Waldbestaenden. Konzeption und Abschaetzung im Rahmen einer
#'             Fallstudie in hessischen Staatswaldflaechen (Economic Potentials
#'             of Forest Stands and Their Consideration in Strategic Decisions).
#'             Bad Orb: J.D. Sauerlaender`s Verlag (Schriften zur Forst- und
#'             Umweltoekonomie, 47).
#' @examples
#' wood_valuation(1,
#'                40,
#'                "beech")
#'
#' # species codes Lower Saxony (Germany)
#' wood_valuation(seq(10, 70, 20),
#'                40,
#'                211,
#'                species.code.type = "nds")
#'
#' # vector input
#' wood_valuation(10,
#'                seq(20, 50, 5),
#'                "spruce")
#'
#' wood_valuation(10,
#'                40,
#'                rep(c("beech", "spruce"),
#'                    each = 9),
#'                value.level = rep(rep(1:3, 2),
#'                                  each = 3),
#'                cost.level = rep(1:3, 6))
#'
#' wood_valuation(10,
#'                40,
#'                rep("spruce", 6),
#'                calamity.type = c("none",
#'                                  "ips",
#'                                  "ips.timely",
#'                                  "stand.damage.fuchs",
#'                                  "regional.calamity.fuchs",
#'                                  "national.calamity.fuchs"))
#'
#' # user-defined calamities with respective changes in harvest costs and wood revenues
#' wood_valuation(10,
#'                40,
#'                rep("spruce", 3),
#'                calamity.type = c("none",
#'                                  "my.own.calamity.1",
#'                                  "my.own.calamity.2"),
#'                calamity.factors = dplyr::tibble(
#'                  calamity.type = rep(c("none",
#'                                        "my.own.calamity.1",
#'                                        "my.own.calamity.2"),
#'                                      each = 2),
#'                  species.group = rep(c("softwood",
#'                                        "deciduous"),
#'                                      times = 3),
#'                  revenues.factor = c(1.0, 1.0,
#'                                      0.8, 0.8,
#'                                      0.2, 0.2),
#'                  cost.factor = c(1.0, 1.0,
#'                                  1.5, 1.5,
#'                                  1.0, 1.0),
#'                  cost.additional = c(0, 0,
#'                                      0, 0,
#'                                      5, 5)))
#'
#' # adapted market situation by providing alternative prices for the reference assortments
#' wood_valuation(10,
#'                40,
#'                c("oak", "beech", "spruce"))
#' wood_valuation(10,
#'                40,
#'                c("oak", "beech", "spruce"),
#'                price.ref.assortment = dplyr::tibble(
#'                  species = c("oak", "beech", "spruce"),
#'                  price.ref.assortment = c(300, 80, 50)))
#'
#' @import dplyr
#'
#' @export
wood_valuation <- function(
  volume,
  diameter.q,
  species,
  value.level = 2,
  cost.level = 1,
  process.type = "combined",
  price.ref.assortment = "baseline",
  calamity.type = "none",
  calamity.factors = "baseline",
  species.code.type = "en"
) {

  tibble(
    volume = volume,
    diameter.q = diameter.q,
    species = species,
    cost.level = cost.level,
    value.level = value.level,
    process.type = process.type,
    calamity.type = calamity.type
  ) %>%

    mutate(
      vol.salable = vol_salable(diameter.q,
                                species,
                                value.level,
                                process.type,
                                species.code.type),
      vol.skidded = vol_skidded(diameter.q,
                                species,
                                value.level,
                                process.type,
                                species.code.type),
      wood.revenues = wood_revenues(diameter.q,
                                    species,
                                    value.level,
                                    process.type,
                                    price.ref.assortment,
                                    calamity.type,
                                    calamity.factors,
                                    species.code.type),
      harvest.costs = harvest_costs(diameter.q,
                                    species,
                                    cost.level,
                                    calamity.type,
                                    calamity.factors,
                                    species.code.type),
      wood.net.revenue.m3 = (.data$vol.salable * .data$wood.revenues) -
        (.data$vol.skidded * .data$harvest.costs),
      wood.net.revenue = .data$volume * .data$wood.net.revenue.m3
    ) %>%

    return()

}
