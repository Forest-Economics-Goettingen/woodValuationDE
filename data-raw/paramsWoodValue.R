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
                            "ips",
                            "ips.timely",
                            "stand.damage.fuchs",
                            "regional.calamity.fuchs",
                            "national.calamity.fuchs"),
                          each = 2),
      species.group = rep(c("softwood",
                            "deciduous"),
                          times = 7),
      revenues.factor = c(1.00, 1.00,
                          0.50, 0.50,
                          0.67,   NA,
                          0.88,   NA,
                          0.96, 0.81,
                          0.68, 0.76,
                          0.43, 0.61),
      cost.factor = c(1.00, 1.00,
                      0.50, 0.50,
                      1.00,   NA,
                      1.00,   NA,
                      1.00, 1.00,
                      1.00, 1.00,
                      1.00, 1.00),
      cost.additional = c(0.0, 0.0,
                          0.0, 0.0,
                          2.5,  NA,
                          2.5,  NA,
                          2.0, 2.0,
                          2.5, 2.5,
                          5.0, 5.0)
    )
  )

  return(dat)

}

params.wood.value <- PrepareTimberContrMarginParameters()

usethis::use_data(params.wood.value,
                  internal = TRUE,
                  overwrite = TRUE)
