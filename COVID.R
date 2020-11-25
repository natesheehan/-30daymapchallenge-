library(sf)
library(readr)
library(tmap)
LondonMSOA <- st_read("./Data/statistical-gis-boundaries-london/ESRI/MSOA_2011_London_gen_MHW.shp")
LondonLSOA <- st_read('./Data/statistical-gis-boundaries-london/ESRI/LSOA_2011_London_gen_MHW.shp')

covidDeaths <- read_csv("./Data/londonMSOACovidDeaths.csv")
deprivationScore <- read_csv("./Data/londonMSOADeprivation.csv")
londonOcupation <- read_csv("./Data/covidOcupation.csv")
londonChildPoverty <- read_csv("./Data/londonChildPoverty.csv")
londonEthnicity <- read_csv("./Data/LondonEthnicity.csv")
londonPopulation <- read_csv("./Data/londonPopulation.csv")
londonHealth <-read_csv("./Data/londonUnderlyingHealth.csv")


londonDeprivation <-
  merge(LondonLSOA,
        deprivationScore,
        by = c("LSOA11CD"))

londonCovidDeaths <-
  merge(LondonMSOA,
        covidDeaths,
        by = c("MSOA11CD"))

londonOcupation <-
  merge(LondonMSOA,
        londonOcupation,
        by = c("MSOA11CD"))

londonPopulation <-
  merge(LondonMSOA,
        londonPopulation,
        by = c("MSOA11CD"))

londonEth <-
  merge(LondonMSOA,
        londonEthnicity,
        by = c("MSOA11CD"))

londonChildPov <-
  merge(LondonMSOA,
        londonChildPoverty,
        by = c("MSOA11CD"))

londonHealthRisk <-
  merge(LondonMSOA,
        londonHealth,
        by = c("MSOA11CD"))

tmap_mode("view")

p1 <- tm_basemap(leaflet::providers$Stamen.TonerLite) + tm_shape(londonDeprivation) +
  tm_fill(col = "imd_score",
          palette = "plasma") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "Areas of Deprivation",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("Data from 01/06/2020 \nData: https://data.london.gov.uk/", position=c("left", "bottom"))

p2 <- tm_basemap(leaflet::providers$Stamen.TonerLite) + tm_shape(londonCovidDeaths) +
  tm_dots(col = "covid_19_deaths_per_thousand",
          palette = "Reds", style = "quantile") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "COVID-19 Deaths",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("Data from 01/06/2020 \nData: https://data.london.gov.uk/", position=c("left", "bottom"))

p3 <- tm_basemap(leaflet::providers$Stamen.TonerLite) + tm_shape(londonOcupation) +
  tm_fill(col = "proportion_at_risk_jobs",
          palette = "plasma") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "COVID-19 Deaths",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("Data from 01/06/2020 \nData: https://data.london.gov.uk/", position=c("left", "bottom"))

p4 <- tm_basemap(leaflet::providers$Stamen.TonerLite) + tm_shape(londonEth) +
  tm_fill(col = "all_bame_prop",
          palette = "plasma") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "COVID-19 Deaths",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("Data from 01/06/2020 \nData: https://data.london.gov.uk/", position=c("left", "bottom"))

p5 <- tm_basemap(leaflet::providers$Stamen.TonerLite) + tm_shape(londonChildPov) +
  tm_fill(col = "child_poverty_prop",
          palette = "plasma") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "COVID-19 Deaths",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("Data from 01/06/2020 \nData: https://data.london.gov.uk/", position=c("left", "bottom"))

p6 <- tm_basemap(leaflet::providers$Stamen.TonerLite) + tm_shape(londonPopulation) +
  tm_fill(col = "over_70_prop",
          palette = "plasma") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "COVID-19 Deaths",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("Data from 01/06/2020 \nData: https://data.london.gov.uk/", position=c("left", "bottom"))

p7 <- tm_basemap(leaflet::providers$Stamen.TonerLite) + tm_shape(londonHealthRisk) +
  tm_fill(col = "total_registered_patients",
          palette = "plasma") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "COVID-19 Deaths",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("Data from 01/06/2020 \nData: https://data.london.gov.uk/", position=c("left", "bottom"))


p1 + p2 + p3 + p4 + p5 + p6 + p7
