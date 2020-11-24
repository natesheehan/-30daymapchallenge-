library(rayshader)
library(elevatr)
library(magrittr)

#from the .tif file
eltif = raster_to_matrix("~/Data/farmLansat 2/LM05_L1GS_204025_20121108_20180522_01_T2_B1.TIF")

#or from the elevatr package
elevation <- get_elev_raster(lake, z = 11, src = "aws")

elmat2 = matrix(raster::extract(elevation,raster::extent(elevation)),
                nrow=ncol(elevation),ncol=nrow(elevation))

elmat2 %>%
  sphere_shade() %>% 
  add_water(detect_water(elmat2, zscale = 20), color = "lightblue") %>%
  add_shadow(ray_shade(elmat2, zscale = 3), 0.5) %>%
  plot_3d(
    elmat2,
    zscale =20,
    fov = 0,
    theta = 45,
    zoom = 0.68,
    phi = 45,
    baseshape = "rectangle",
    windowsize = c(800, 800),
    solidcolor = "lavenderblush1",
    watercolor = "lightblue",
    solidlinecolor = "gray19",
    background = "lavenderblush1",
    soliddepth = -30,
  )

text <- paste0("Trevengleath Farm Elevation",
               strrep("\n", 38),
               "Nathanael Sheehan // pkg - Rayshader")

render_snapshot(
  filename = "cornwall-farm.png",
  title_text = text,
  title_size = 16,
  title_color = "grey50",
  clear = T
)
