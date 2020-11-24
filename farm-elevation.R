library(rayshader)
library(elevatr)
library(magrittr)
library(sf)
library(rayshader)
library(elevatr)
library(raster)

ben <- st_sfc(st_point(c(-5.0036,56.7969)), crs = 4326) %>% 
  st_transform(32719) %>% 
  st_buffer(dist = 50000)

a <- get_elev_raster(as_Spatial(ben), z = 9, clip = "locations")

elmat2 = matrix(raster::extract(a,raster::extent(a)),
                nrow=ncol(a),ncol=nrow(a))

elmat2 %>%
  sphere_shade(texture = "imhof2") %>% 
  add_water(detect_water(elmat2, zscale = 20), color = "lightblue") %>%
  add_shadow(ray_shade(elmat2, zscale = 3), 0.5) %>%
  plot_3d(
    elmat2,
    zscale =20,
    fov = 0,
    theta = 45,
    zoom = 0.48,
    phi = 45,
    baseshape = "rectangle",
    windowsize = c(800, 800),
    solidcolor = "gray30",
    watercolor = "lightblue",
    solidlinecolor = "gray30",
    background = "honeydew2",
    soliddepth = -30,
  )

filename_movie = ("~/Data/farmLansat 2/ben-nevis")

render_movie(filename = filename_movie, type = "orbit", 
             frames = 120,  phi = 30, zoom = 0.8, theta = -90,
             title_text = "Ben Nevis, Scotland \nNathanael Sheehan")
