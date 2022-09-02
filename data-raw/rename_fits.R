library(tidyverse)

dat <- read.csv2("./data-raw/volStemWoodParametersOffer.csv")
dat.andere <- read.csv2("./data-raw/volSalableParametersOffer.csv") %>% 
  dplyr::select(tree.species,
                species.code,
                value.level,
                logging.method,
                min.dq,
                max.dq)

dat1 <- dat %>% 
  mutate(baumart = replace(baumart,
                           baumart == "Birke",
                           "birch"),
         baumart = replace(baumart,
                           baumart == "Buche",
                           "beech"),
         baumart = replace(baumart,
                           baumart == "Douglasie",
                           "Douglas fir"),
         baumart = replace(baumart,
                           baumart == "Eiche",
                           "oak"),
         baumart = replace(baumart,
                           baumart == "Erle",
                           "alder"),
         baumart = replace(baumart,
                           baumart == "Esche",
                           "ash"),
         baumart = replace(baumart,
                           baumart == "Fichte",
                           "spruce"),
         baumart = replace(baumart,
                           baumart == "Kiefer",
                           "pine"),
         baumart = replace(baumart,
                           baumart == "Laerche",
                           "larch"),
         baumart = replace(baumart,
                           baumart == "Pappel",
                           "poplar"),
         tarif = replace(tarif,
                         tarif == "hochmechanisiert",
                         "harvester"),
         tarif = replace(tarif,
                         tarif == "kombiniert",
                         "combined"),
         tarif = replace(tarif,
                         tarif == "motormanuell",
                         "manually")) %>% 
  rename("tree.species" = "baumart") %>%
  rename("value.level" = "wertklasse") %>% 
  rename("logging.method" = "tarif") %>% 
  left_join(dat.andere,
            by = c("tree.species",
                   "value.level",
                   "logging.method")) %>% 
  add_column(assortment = "sawn.wood")


write.csv2(dat1,
           "./data-raw/volAssortmentParametersOffer.csv")
