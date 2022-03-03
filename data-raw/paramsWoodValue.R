PrepareTimberContrMarginParameters <- function() {

  dat <- list(
    species.codes =
      readr::read_delim("./data-raw/treeSpeciesCodes.csv",
                        delim = ";",
                        locale = readr::locale(decimal_mark = ","),
                        col_types = readr::cols()),
    wood.revenues =
      readr::read_delim("./data-raw/woodRevenueParametersBodelschwingh.csv",
                        delim = ";",
                        locale = readr::locale(decimal_mark = ","),
                        col_types = readr::cols()),
    harvest.costs =
      readr::read_delim("./data-raw/harvestCostsParametersBodelschwingh.csv",
                        delim = ";",
                        locale = readr::locale(decimal_mark = ","),
                        col_types = readr::cols()),
    vol.salable =
      readr::read_delim("./data-raw/volSalableParametersOffer.csv",
                        delim = ";",
                        locale = readr::locale(decimal_mark = ","),
                        col_types = readr::cols()),
    vol.skidded =
      readr::read_delim("./data-raw/volSkiddedParametersOffer.csv",
                        delim = ";",
                        locale = readr::locale(decimal_mark = ","),
                        col_types = readr::cols()),
    prices.ref.assortments = dplyr::tibble(
      species = c(110, 211, 511, 711, 611,
                  811, 410, 421, 311, 430),
      price.ref.assortment = c(277.41, 75.75, 92.47, 71.48, 92.23,
                               83.29, 72.13, 98.90, 112.88, 45.43)),
    calamity.factors = dplyr::tibble(
      calamity.type = rep(c("none",
                            "calamity.dieter.2001",
                            "fire.small.moellmann.2017",
                            "fire.large.moellmann.2017",
                            "storm.small.moellmann.2017",
                            "storm.large.moellmann.2017",
                            "insects.moellmann.2017",
                            "ips.fuchs.2021",
                            "ips.timely.fuchs.2021",
                            "stand.damage.fuchs",
                            "regional.disturbance.fuchs",
                            "transregional.calamity.fuchs"),
                          each = 2),
      species.group = rep(c("softwood",
                            "deciduous"),
                          times = 12),
      revenues.factor = c(1.00, 1.00,
                          0.50, 0.50,
                          0.56,   NA,
                          0.56,   NA,
                          0.85, 0.79,
                          0.85, 0.79,
                          0.78,   NA,
                          0.67,   NA,
                          0.88,   NA,
                          0.90, 0.85,
                          0.74, 0.70,
                          0.54, 0.70),
      cost.factor = c(1.00, 1.00,
                      0.50, 0.50,
                      1.17,   NA,
                      1.09,   NA,
                      1.21, 1.24,
                      1.10, 1.12,
                        NA,   NA,
                      1.00,   NA,
                      1.00,   NA,
                      1.15, 1.15,
                      1.15, 1.15,
                      1.25, 1.25),
      cost.additional = c(0.0, 0.0,
                          0.0, 0.0,
                          0.0, 0.0,
                          0.0, 0.0,
                          0.0, 0.0,
                          0.0, 0.0,
                          0.0, 0.0,
                          2.5,  NA,
                          7.5,  NA,
                          0.0, 0.0,
                          0.0, 0.0,
                          0.0, 0.0)
    )
  )

  return(dat)

}

params.wood.value <- PrepareTimberContrMarginParameters()

usethis::use_data(params.wood.value,
                  internal = TRUE,
                  overwrite = TRUE)
