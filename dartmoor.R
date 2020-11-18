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

dartmoor <- st_read("./Data/dnpa_dartmoor_lct/dnpa_dartmoor_lctPolygon.shp")

colnames(dartmoor)[colnames(dartmoor) == "lct_name"] <- "Land Use"

tmap_mode("view")

tm_shape(dartmoor) +
  tm_fill(col = "Land Use",
          palette = "Dark2") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(breaks = c(0, 10), text.size = 0.7) +
  tm_layout(legend.outside = TRUE, legend.position = c("center","center"),title = "Dartmoor \nNational \nPark",  title.position = c("left","top") ,bg.color = "slategray3", legend.bg.color = "slategray3", outer.bg.color = "slategray3") +
  tm_credits("(c) Nathanael Sheehan (CBS) \nData: Dartmoor National Park Authority", position=c("left", "bottom"))
