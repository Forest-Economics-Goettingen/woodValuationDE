##--###############--##
#### Wood Revenues ####
##--###############--##

#' Wood revenues per cubic meter salable volume
#'
#' The function estimates wood revenues per cubic meter salable volume using the
#' wood revenue model of v. Bodelschwingh (2018), which is based on the
#' assortment tables from Offer and Staupendahl (2018). Consequences of
#' disturbances and calamities are implemented based on Dieter (2001), Moellmann
#' and Moehring (2017), and Fuchs et al. (2022a, 2022b). Apart from Dieter
#' (2001) and Moellmann and Moehring (2017), all functions and factors are based
#' on data from HessenForst, the public forest service of the Federal State of
#' Hesse in Germany. For further details see the \pkg{woodValuationDE}
#' \href{https://github.com/Forest-Economics-Goettingen/woodValuationDE}{README}.
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
#'                    assortment tables of Offer and Staupendahl (2018).
#' @param logging.method Logging method, with \code{"manually"} for
#'                       motor-manual logging using a chain saw,
#'                       \code{"harvester"} for logging with highly mechanized
#'                       forest harvesters, or \code{"combined"} for a
#'                       combination of the previous methods dependent on the
#'                       mean diameter.
#' @param price.ref.assortment Wood price of the reference assortments allowing
#'                     to consider market fluctuations. Default is
#'                     \code{"baseline"} referring to the prices from 2010 to
#'                     2015 in Hesse, Germany (for details see
#'                     \href{https://github.com/Forest-Economics-Goettingen/woodValuationDE}{README}
#'                     of \pkg{woodValuationDE} or v. Bodelschwingh (2018)).
#'                     Alternatively, users can provide a tibble with the
#'                     same structure. The column species uses the specified
#'                     \code{species.code.type}.
#' @param calamity.type Defines the disturbance or calamity situation to allow
#'                      for the consideration of lower net revenues in the case
#'                      of salvage harvests. The calamity type determines the
#'                      applied consequences of disturbances/calamities,
#'                      implemented as factors for reduced revenues and higher
#'                      harvest costs. By default no calamity is assumed
#'                      \code{"none"}; \code{"calamity.dieter.2001"}
#'                      refers to a general larger calamity applying the
#'                      corrections according to Dieter (2001); five parameter
#'                      sets were implemented according to Moellmann and
#'                      Moehring (2017): \code{fire.small.moellmann.2017} refers
#'                      to damages of only some trees by fire (only conifers)
#'                      while \code{fire.large.moellmann.2017} assumes that at
#'                      least one compartment was affected, the same applies for
#'                      \code{storm.small.moellmann.2017} and
#'                      \code{storm.large.moellmann.2017} referring to damages
#'                      by storm (available for coniferous and deciduous
#'                      species), \code{insects.moellmann.2017} refers to
#'                      damages by insects; \code{"ips.fuchs.2022a"} refers to
#'                      quality losses due to infestations by the European
#'                      spruce bark beetle or \code{"ips.timely.fuchs.2022a"}
#'                      for timely salvage fellings in less advanced attack 
#'                      stages (both according to Fuchs et al. 2022a); and
#'                      \code{"stand.damage.fuchs.2022b"} to disturbances
#'                      affecting only one stand, 
#'                      \code{"regional.disturbance.fuchs.2022b"} to 
#'                      disturbances with effects on the regional wood market
#'                      and \code{"transregional.calamity.fuchs.2022b"} to
#'                      calamities affecting transregional wood markets (the
#'                      last three referring to Fuchs et al. 2022b).
#'                      User-defined types can be implemented via the
#'                      \code{calamity.factors} argument.
#' @param calamity.factors Summands \eqn{[EUR m^{-3}]}{[EUR m^(-3)]}
#'                         and factors to consider the consequences of
#'                         disturbances and calamities on wood revenues and
#'                         harvest costs. \code{"baseline"} provides a tibble
#'                         based on the references listed in
#'                         \code{calamity.type} (for details see
#'                         \href{https://github.com/Forest-Economics-Goettingen/woodValuationDE}{README}
#'                         of \pkg{woodValuationDE}). Alternatively, users can
#'                         provide a tibble with the same structure.
#' @param species.code.type Type of code in which \code{species} is given.
#'                          \code{"en"} for English species names or
#'                          \code{"nds"} for numeric species codes used in Lower
#'                          Saxony, Germany. For a list with the available
#'                          species and codes call
#'                          \code{\link{get_species_codes}}.
#' @param method argument that is currently not used, but offers the possibility
#'               to implement alternative parameters and functions in the
#'               future.
#' @return A vector with wood revenues per cubic meter
#'         \eqn{[EUR m^{-3}]}{[EUR m^(-3)]}. The volume refers to the salable
#'         wood volume, provided by \code{\link{vol_salable}}.
#' @references Dieter, Matthias (2001): Land expectation values for spruce and
#'             beech calculated with Monte Carlo modelling techniques. For.
#'             Policy Econ. 2 (2), S. 157-166.
#'             \doi{10.1016/S1389-9341(01)00045-4}.
#' @references Fuchs, Jasper M.; Hittenbeck, Anika; Brandl, Susanne; Schmidt,
#'             Matthias; Paul, Carola (2022a): Adaptation Strategies for
#'             Spruce Forests - Economic Potential of Bark Beetle Management and
#'             Douglas Fir Cultivation in Future Tree Species Portfolios.
#'             Forestry 95 (2) 229-246. \doi{10.1093/forestry/cpab040}
#' @references Fuchs, Jasper M.; v. Bodelschwingh, Hilmar; Lange, Alexander;
#'             Paul, Carola; Husmann, Kai (2022b): Quantifying the
#'             consequences of disturbances on wood revenues with Impulse
#'             Response Functions. For. Policy Econ. 140, art. 102738.
#'             \doi{10.1016/j.forpol.2022.102738}.
#' @references Fuchs, Jasper M.; Husmann, Kai; v. Bodelschwingh, Hilmar; Koster,
#'             Roman; Staupendahl, Kai; Offer, Armin; Moehring, Bernhard, Paul,
#'             Carola (in preparation): woodValuationDE: A consistent framework
#'             for calculating stumpage values in Germany (technical note)
#' @references Moellmann, Torsten B.; Moehring, Bernhard (2017): A practical way
#'             to integrate risk in forest management decisions. Ann. For. Sci.
#'             74 (4), S.75. \doi{10.1007/s13595-017-0670-x}
#' @references Moellmann, Torsten B.; Moehring, Bernhard (2017): A practical way
#'             to integrate risk in forest management decisions. Ann. For. Sci.
#'             74 (4), S.75. \doi{10.1007/s13595-017-0670-x}
#' @references v. Bodelschwingh, Hilmar (2018): Oekonomische Potentiale von
#'             Waldbestaenden. Konzeption und Abschaetzung im Rahmen einer
#'             Fallstudie in hessischen Staatswaldflaechen (Economic Potentials
#'             of Forest Stands and Their Consideration in Strategic Decisions).
#'             Bad Orb: J.D. Sauerlaender`s Verlag (Schriften zur Forst- und
#'             Umweltoekonomie, 47).
#' @examples
#' wood_revenues(40,
#'               "beech")
#'
#' # species codes Lower Saxony (Germany)
#' wood_revenues(40,
#'               211,
#'               species.code.type = "nds")
#'
#' # vector input
#' wood_revenues(seq(20, 50, 5),
#'               "spruce")
#'
#' wood_revenues(40,
#'               rep(c("beech", "spruce"),
#'                   each = 3),
#'               value.level = rep(1:3, 2))
#'
#' wood_revenues(40,
#'               rep("spruce", 7),
#'               calamity.type = c("none",
#'                                 "calamity.dieter.2001",
#'                                 "ips.fuchs.2022a",
#'                                 "ips.timely.fuchs.2022a",
#'                                 "stand.damage.fuchs.2022b",
#'                                 "regional.disturbance.fuchs.2022b",
#'                                 "transregional.calamity.fuchs.2022b"))
#'
#' # user-defined calamities with respective changes in wood revenues
#' wood_revenues(40,
#'               rep("spruce", 3),
#'               calamity.type = c("none",
#'                                 "my.own.calamity.1",
#'                                 "my.own.calamity.2"),
#'               calamity.factors = dplyr::tibble(
#'                 calamity.type = rep(c("none",
#'                                       "my.own.calamity.1",
#'                                       "my.own.calamity.2"),
#'                                     each = 2),
#'                 species.group = rep(c("softwood",
#'                                       "deciduous"),
#'                                     times = 3),
#'                 revenues.factor = c(1.0, 1.0,
#'                                     0.8, 0.8,
#'                                     0.2, 0.2),
#'                 cost.factor = c(1.0, 1.0,
#'                                 1.5, 1.5,
#'                                 1.0, 1.0),
#'                 cost.additional = c(0, 0,
#'                                     0, 0,
#'                                     5, 5)))
#'
#' # adapted market situation by providing alternative prices for the reference assortments
#' wood_revenues(40,
#'               c("oak", "beech", "spruce"))
#' wood_revenues(40,
#'               c("oak", "beech", "spruce"),
#'               price.ref.assortment = dplyr::tibble(
#'                 species = c("oak", "beech", "spruce"),
#'                 price.ref.assortment = c(300, 80, 50)))
#'
#' @import dplyr
#'
#' @export
wood_revenues <- function(
  diameter.q,
  species,
  value.level = 2,
  logging.method = "combined",
  price.ref.assortment = "baseline",
  calamity.type = "none",
  calamity.factors = "baseline",
  species.code.type = "en",
  method = "fuchs.orig"
) {

  if (is.character(calamity.factors)) {

    if (calamity.factors != "baseline") {

      stop("Provided value for calamity.factors unknown. See package README for further details.")

    }

  } else {

    if (!(all(colnames(calamity.factors) ==
              colnames(params.wood.value$calamity.factors))) &
        !(all(is.character(calamity.factors$calamity.type))) &
        !(all(is.character(calamity.factors$species.group))) &
        !(all(is.numeric(calamity.factors$revenues.factor))) &
        !(all(is.numeric(calamity.factors$cost.factor))) &
        !(all(is.numeric(calamity.factors$cost.additional)))) {

      stop("Structure of calamity.factors does not match the required structure. See package README for further details.")

    }

    params.wood.value$calamity.factors <- calamity.factors

  }

  wood.revenues <-
    tibble(
      diameter.q = diameter.q,
      species = species,
      value.level = value.level,
      logging.method = logging.method,
      calamity.type = calamity.type
    ) %>%

    # assign the appropriate parameterized species (group)
    mutate(calamity.group = recode_species(species,
                                           species.code.type,
                                           "calamity.group"),
           species = recode_species(species,
                                    species.code.type,
                                    "bodelschwingh.revenues")) %>%

    # add specific parameters
    left_join(params.wood.value$wood.revenues,
              by = c("species" = "species.code.bodelschwingh",
                     "value.level" = "value.level",
                     "logging.method" = "logging.method")) %>%
    left_join(params.wood.value$calamity.factors,
              by = c("calamity.type" = "calamity.type",
                     "calamity.group" = "species.group")) %>%

    mutate(
      wood.revenues = (.data$a * diameter.q^4 +
                         .data$b * diameter.q^3 +
                         .data$c * diameter.q^2 +
                         .data$d * diameter.q +
                         .data$e) *
        # apply calamity factor
        .data$revenues.factor) %>%

    # add minimum and maximum diameter to check for extrapolation
    left_join(params.wood.value$vol.salable,
              by = c("species" = "species.code",
                     "value.level" = "value.level",
                     "logging.method" = "logging.method"))

  # test whether the diameters are in the range of the original data sets
  if (any(wood.revenues$diameter.q < wood.revenues$min.dq) |
      any(wood.revenues$diameter.q > wood.revenues$max.dq)) {

    warning("wood_revenues: At least one diameter leads to extrapolation!")

  }

  # apply price factor for market fluctuations if not "baseline"
  if (is.character(price.ref.assortment)) {

    if (price.ref.assortment != "baseline") {

      stop("Provided value for price.ref.assortment unknown. See package README for further details.")

    }

  } else {

    if (!(all(colnames(price.ref.assortment) ==
              colnames(params.wood.value$prices.ref.assortments))) &
        !(all(is.numeric(price.ref.assortment$species))) &
        !(all(is.numeric(price.ref.assortment$price.ref.assortment)))) {

      stop("Structure of price.ref.assortment does not match the required structure. See package README for further details.")

    }

    price.ref.assortment <- price.ref.assortment %>%
      mutate(
        species = recode_species(species,
                                 species.code.type,
                                 "bodelschwingh.revenues")
      )

    price.factors <-
      params.wood.value$prices.ref.assortments %>%
      rename(price.ref.assortment.bodel = price.ref.assortment) %>%
      left_join(price.ref.assortment, by = "species") %>%
      mutate(price.factor.market = .data$price.ref.assortment /
               .data$price.ref.assortment.bodel)

    wood.revenues <- wood.revenues %>%
      left_join(price.factors,
                by = "species") %>%
      mutate(wood.revenues = .data$wood.revenues * .data$price.factor.market)

  }

  if (any(is.na(wood.revenues$revenues.factor))) {

    warning("For at least one species the calamity value revenues.factor was NA.")

  }

  wood.revenues %>%
    pull(wood.revenues) %>%
    return()

}
