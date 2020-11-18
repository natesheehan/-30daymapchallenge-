if (!require(tidyverse)) {
  install.packages("tidyverse", repos = "http://cran.us.r-project.org")
  require(tidyverse)
}
if (!require(sf)) {
  install.packages("sf", repos = "http://cran.us.r-project.org")
  require(sf)
}
if (!require(tmap)) {
  install.packages("tmap", repos = "http://cran.us.r-project.org")
  require(tmap)
}

LA <- st_read(
  "./Data/Local_Authority_Districts_December_2017_Full_Clipped_Boundaries_in_Great_Britain/Local_Authority_Districts_December_2017_Full_Clipped_Boundaries_in_Great_Britain.shp"
)
LALondon <- st_read(
  "./Data/statistical-gis-boundaries-london/ESRI/London_Borough_Excluding_MHW.shp"
)

landUse <- read_csv("./Data/landuse.csv")

colnames(landUse)[colnames(landUse) == "ONS Code"] <- "lad17cd"
colnames(landUse)[colnames(landUse) == "Total_1"] <- "Total Green and Blue (%)"

colnames(LALondon)[colnames(LALondon) == "GSS_CODE"] <- "lad17cd"

LaLandUse <-
  merge(LA,
        landUse,
        by = c("lad17cd"))

LaLandUseLondon <-
  merge(LALondon,
        landUse,
        by = c("lad17cd"))


uk <-
  tm_basemap(leaflet::providers$Stamen.TonerLite) +
  tm_shape(LaLandUse) +
  tm_fill("Total Green and Blue (%)", style = "quantile", palette = "Greens") +
  tm_borders(alpha = 0.7) +
  tm_layout(
    main.title.size = 0.7 ,
    legend.position = c("right", "bottom"),
    legend.title.size = 0.8
  )

london <-
  tm_basemap(leaflet::providers$Stamen.TonerLite) +
  tm_shape(LaLandUseLondon) +
  tm_fill("Total Green and Blue (%)", style = "quantile", palette = "Greens") +
  tm_borders(alpha = 0.7) +
  tm_layout(
    main.title.size = 0.7 ,
    legend.position = c("right", "bottom"),
    legend.title.size = 0.8
  )

tmap_mode("view")

tmap_arrange(uk, london)
