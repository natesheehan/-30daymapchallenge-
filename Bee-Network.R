beeNetwork <- st_read("~/Data/BeeNetwork/SHP/Beeways_line.shp")
manchester <- st_read("~/Data/manchester-regions.geojson")

beeNetworkInterceptSF <- st_intersection(ukBoundries,beeNetwork)

plot(beeNetworkIntercept$Length_km)

pal <- c('#fffad7','#fef5ae', '#feef7c', '#fde849', '#fddf08')

tm_shape(manchester) +
  tm_polygons("AREA", palette="Greens",
              title="Manchester Region", id="AREA",legend.show = FALSE, alpha = 0.3) +
  tm_text("NAME", shadow=TRUE, scale = 0.75) +
tm_shape(beeNetworkIntercept) +
  tm_lines("Length_km", style = "quantile", palette = pal) +
  tm_borders(alpha = 0.1) +
  tm_style("cobalt") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scale_bar(
    width = 0.3,
    lwd = 0.65,
    text.size = 0.65,
    position = c("left", "bottom")
  ) +
  tm_layout(
    main.title = "Manchester Bee Network",
    main.title.size = 1.25 ,
    legend.position = c("right", "top"),
    legend.title.size = 1,
    main.title.color = "Yellow",
    bg.color = "grey85"
  ) 

