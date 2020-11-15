library(stplanr)
library(dplyr)

# get nationwide OD data
od_all <- pct::get_od()

# > 2402201
od_all$Active <- (od_all$bicycle + od_all$foot) /
  od_all$all * 100
centroids_all <- pct::get_centroids_ew() %>% sf::st_transform(4326)
nrow(centroids_all)
# > 7201
manchester <-
  pct::pct_regions %>% filter(region_name == "greater-manchester")

centroids_manchester <- centroids_all[manchester,]
od_manchester <- od_all %>%
  filter(geo_code1 %in% centroids_manchester$msoa11cd) %>%
  filter(geo_code2 %in% centroids_manchester$msoa11cd)
od_manchester <- od_all[od_all$geo_code1 %in% centroids_manchester$msoa11cd &
                          od_all$geo_code2 %in% centroids_manchester$msoa11cd,]
desire_lines_manchester <-
  od2line(od_manchester, centroids_manchester)

min_trips_threshold <- 20
desire_lines_inter <-
  desire_lines_manchester %>% filter(geo_code1 != geo_code2)
desire_lines_intra <-
  desire_lines_manchester %>% filter(geo_code1 == geo_code2)
desire_lines_top <-
  desire_lines_inter %>% filter(all >= min_trips_threshold)

library(tmap)
tmap_mode("view")
desire_lines_top <- desire_lines_top %>%
  arrange(Active)
tm_basemap(leaflet::providers$Stamen.TonerLite) +
  tm_shape(manchester) + tm_borders() +
  tm_shape(desire_lines_top) +
  tm_lines(
    palette = "plasma",
    breaks = c(0, 5, 10, 20, 40, 100),
    lwd = "all",
    scale = 9,
    title.lwd = "Number of trips",
    alpha = 0.5,
    col = "Active",
    title = "Active travel (%)",
    legend.lwd.show = FALSE
  ) +
  tm_scale_bar() +
  tm_layout(legend.bg.alpha = 0.5,
            legend.bg.color = "white")
