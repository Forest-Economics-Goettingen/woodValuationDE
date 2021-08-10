##--###############--##
#### Harvest Costs ####
##--###############--##

#' Harvest costs per unit volume
#'
#' The function estimates harvest costs per unit wood volume applying the
#' harvest costs function of von Bodelschwingh (2018). Consequences of
#' calamities are implemented based on Dieter (2001), Moellmann and Moehring
#' (2017), Fuchs et al. (under review) and Fuchs et al. (in preparation). Apart
#' from Dieter (2001) and Moellmann and Moehring (2017) all functions and
#' factors are based on data of HessenForst, the forest administration of the
#' Federal State of Hesse in Germany. For further details see the
#' \pkg{woodValuationDE} readme.
#'
#' @param diameter.q Quadratic mean of the diameter at breast height (dbh) of
#'                   the harvested trees \eqn{[cm]}{[cm]}.
#' @param species Tree species, using an available \code{species.code.type}. For
#'                a list with the available species and codes call
#'                \code{\link{get_species_codes}}.
#' @param cost.level  Accessibility of the stand for harvest operations
#'                    expressed as integer of \code{1:3}, with \code{1} for
#'                    standard conditions without limitations, \code{2} for
#'                    moist sites or sites with a slope between 36 \% and 58 \%,
#'                    and \code{3} for slopes > 58 \%. The cost.levels refer to
#'                    the harvest cost model by von Bodelschwingh (2018).
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
#' @return A vector with harvest costs per unit volume
#'         \eqn{[EUR m^{-3}]}{[EUR m^(-3)]}. The volume refers to the skidded
#'         wood volume, provided by \code{\link{vol_skidded}}.
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
#' @references von Bodelschwingh, Hilmar (2018): Oekonomische Potentiale von
#'             Waldbestaenden. Konzeption und Abschaetzung im Rahmen einer
#'             Fallstudie in hessischen Staatswaldflaechen (Economic Potentials
#'             of Forest Stands and Their Consideration in Strategic Decisions).
#'             Bad Orb: J.D. Sauerlaender`s Verlag (Schriften zur Forst- und
#'             Umweltoekonomie, 47).
#' @examples
#' harvest_costs(40,
#'               "beech")
#'
#' # species codes Lower Saxony (Germany)
#' harvest_costs(40,
#'               211,
#'               species.code.type = "nds")
#'
#' # vector input
#' harvest_costs(seq(20, 50, 5),
#'               "spruce")
#'
#' harvest_costs(40,
#'               rep(c("beech", "spruce"),
#'                   each = 3),
#'               cost.level = rep(1:3, 2))
#'
#' harvest_costs(40,
#'               rep("spruce", 6),
#'               calamity.type = c("none",
#'                                 "ips",
#'                                 "ips.timely",
#'                                 "stand.damage.fuchs",
#'                                 "regional.calamity.fuchs",
#'                                 "national.calamity.fuchs"))
#'
#' # user-defined calamities with respective changes in harvest costs
#' harvest_costs(40,
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

#' @import dplyr
#'
#' @export
harvest_costs <- function(
  diameter.q,
  species,
  cost.level = 1,
  calamity.type = "none",
  calamity.factors = "baseline",
  species.code.type = "en"
) {

  if (is.character(calamity.factors)) {

    if (calamity.factors != "baseline") {

      stop("Provided value for calamity.factors unknown. See package readme for further details.")

    }

    if (any(calamity.type == "calamity.dieter.2001")) {

      warning("You used 'calamity.dieter.2001': Since Dieter (2001) refers to net revenues when considering the consequences of calamities, we here also reduce the harvest costs. However, this is completely counterintuitive and only the derived net revenues are meaningful to interpret.")

    }

  } else {

    if (!(all(colnames(calamity.factors) ==
              colnames(params.wood.value$calamity.factors))) &
        !(all(is.character(calamity.factors$calamity.type))) &
        !(all(is.character(calamity.factors$species.group))) &
        !(all(is.numeric(calamity.factors$revenues.factor))) &
        !(all(is.numeric(calamity.factors$cost.factor))) &
        !(all(is.numeric(calamity.factors$cost.additional)))) {

      stop("Structure of calamity.factors does not match the required structure. See package readme for further details.")

    }

    params.wood.value$calamity.factors <- calamity.factors

  }

  harvest.costs <- tibble(
    diameter.q = diameter.q,
    species = species,
    cost.level = cost.level,
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
    left_join(params.wood.value$harvest.costs,
              by = c("species" = "species.code.bodelschwingh",
                     "cost.level" = "cost.level")) %>%
    left_join(params.wood.value$calamity.factors,
              by = c("calamity.type" = "calamity.type",
                     "calamity.group" = "species.group")) %>%

    mutate(
      # calculate harvest costs, considering a maximum cost level
      harvest.costs = .data$a * .data$diameter.q^.data$b + .data$c,
      harvest.costs = if_else(.data$harvest.costs < .data$max,
                              .data$harvest.costs,
                              .data$max),
      # consider consequences of calamities
      harvest.costs = .data$harvest.costs *
        .data$cost.factor +
        .data$cost.additional)

  if (any(is.na(c(harvest.costs$cost.factor,
                harvest.costs$cost.additional)))) {

    warning("For at least one species the calamity value cost.factor or cost.additional was NA.")

  }

  harvest.costs %>%
    pull(harvest.costs) %>%
    return()

}
