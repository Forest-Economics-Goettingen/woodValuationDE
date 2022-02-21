##--################--##
#### Recode Species ####
####################--##

#' Convert species names to codes
#'
#' The function converts species names in codes and assigns species groups for
#' the wood valuation procedure.
#'
#' @param species.code.orig Species code to be converted. For a list with the
#'                          available species and codes call
#'                          \code{\link{get_species_codes}}.
#' @param source.format Code format of the original code. For a list with the
#'                          available species and codes call
#'                          \code{\link{get_species_codes}}.
#' @param target.format Code format to be returned or an assignment to a species
#'                      group for economic valuation. For a list with the
#'                      available species and codes call
#'                      \code{\link{get_species_codes}}.

#' @import dplyr
#'
#' @noRd
recode_species <- function(species.code.orig,
                          source.format,
                          target.format) {

  # test: existing source formats
  if (!(paste0("species.code.", source.format) %in%
        colnames(params.wood.value$species.codes))) {

    stop("recode_species: Unknown source format!")

  }

  # test: existing target formats
  if (!(paste0("species.code.", target.format) %in%
        colnames(params.wood.value$species.codes))) {

    stop("recode_species: Unknown target format!")

  }

  # test: existing species
  if (!all(species.code.orig %in%
           pull(params.wood.value$species.codes, !!paste0("species.code.", source.format)))) {

    # missing species codes
    species.codes.missing <- species.code.orig[
      !(species.code.orig %in%
        pull(params.wood.value$species.codes, !!paste0("species.code.", source.format)))
    ]

    stop(paste0("recode_species: Unknown species codes (",
                species.codes.missing,
                ")")
         )
  }

  # add new codes
  species.codes.translated <- species.code.orig %>%
      as_tibble %>%
      left_join(params.wood.value$species.codes,
                by = c("value" = paste0("species.code.", source.format))) %>%
      pull(!!paste0("species.code.", target.format))

  if (length(species.codes.translated) != length(species.code.orig)) {

    stop("At least one species code isn't unique. No species could be assigned!")
  }

  return(species.codes.translated)

}
