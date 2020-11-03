library(tidyverse)
library(sf)

# election results
ge_data <-
  read_csv(
    "http://researchbriefings.files.parliament.uk/documents/CBP-8749/HoC-GE2019-results-by-constituency-csv.csv"
  ) %>%
  filter(region_name == "London") %>%
  select(ons_id, constituency_name, con:green)

uk <-
  st_read(
    "~/Downloads/Westminster_Parliamentary_Constituencies__December_2017__Boundaries_UK-shp/Westminster_Parliamentary_Constituencies__December_2017__Boundaries_UK.shp",
    stringsAsFactors = FALSE
  ) %>%
  st_transform(4326) %>%
  select(ons_id = pcon17cd)

# merge the data
sf_data <- left_join(ge_data, uk) %>%
  st_as_sf()

# data frame of number of dots to plot for each party (1 for every 100 votes)
num_dots <-
  ceiling(select(as.data.frame(sf_data), con:green) / 100)

# generates data frame with coordinates for each point + what party it is assiciated with
sf_dots <- map_df(
  names(num_dots),
  ~ st_sample(sf_data, size = num_dots[, .x], type = "random") %>% # generate the points in each polygon
    st_cast("POINT") %>%                                          # cast the geom set as 'POINT' data
    st_coordinates() %>%                                          # pull out coordinates into a matrix
    as_tibble() %>%                                               # convert to tibble
    setNames(c("lon", "lat")) %>%                                  # set column names
    mutate(Party = factor(.x, levels = names((
      num_dots
    ))))        # add categorical party variable
) # map_df then binds each party's tibble into one

# colour palette for our party points
pal <-
  c(
    "con" = "#0087DC",
    "lab" = "#DC241F",
    "ld" = "#FCBB30",
    "brexit" = "#12B6CF",
    "green" = "#78B943"
  )

# plot it and save as png big enough to avoid over-plotting of the points
p <- ggplot() +
  geom_sf(data = sf_data,
          fill = "transparent",
          colour = "white") +
  geom_point(data = sf_dots, aes(lon, lat, colour = Party)) +
  scale_colour_manual(values = pal) +
  coord_sf(crs = 4326, datum = NA) +
  labs(
    x = NULL,
    y = NULL,
    title = "UK General Election 2019, London Focus",
    subtitle = "1 dot = 100 votes",
    caption = "Map by @MrNSheehan | Data Sources: House of Commons Library"
  ) +
  guides(colour = guide_legend(override.aes = list(size = 28))) +
  theme(
    legend.position = c(0.7, 1.01),
    legend.direction = "horizontal",
    plot.background = element_rect(fill = "#272b2e", color = NA),
    panel.background = element_rect(fill = "#272b2e", color = NA),
    legend.background = element_rect(fill = "#272b2e", color = NA),
    legend.key = element_rect(fill = "#272b2e", colour = NA),
    plot.margin = margin(1, 1, 1, 1, "cm"),
    text =  element_text(color = "#f9f9f9", size = 48),
    title =  element_text(color = "#f9f9f9", size = 48),
    plot.caption = element_text(size = 38)
  )

ggsave(
  "party_points.png",
  plot = p,
  dpi = 320,
  width = 120,
  height = 70,
  units = "cm"
)
