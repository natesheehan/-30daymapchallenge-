library(raster)
library(tidyverse)
library(sf)
library(rpart)
library(rpart.plot)
library(rasterVis)
library(mapedit)
library(mapview)
library(caret)
library(forcats)
#Load each band of LANDSAT-8 Data
band1 <- raster("~/Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B1.TIF")
band2 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B2.TIF")
band3 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B3.TIF")
band4 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B4.TIF")
band5 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B5.TIF")
band6 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B6.TIF")
band7 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B7.TIF")
band8 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B8.TIF")
band9 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B9.TIF")
band10 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B10.TIF")
band11 <- raster("./Data/LC08_L1TP_203024_20190513_20190521_01_T1/LC08_L1TP_203024_20190513_20190521_01_T1_B11.TIF")

#Stack bands into image
image <- stack(band1, band2, band3, band4, band5, band6, band7, 
               band8, band9, band10, band11)

#plot true colour compisite
par(col.axis="white",col.lab="white",tck=0)
plotRGB(image, r = 4, g = 3, b = 2, axes = TRUE, 
        stretch = "lin", main = "True Color Composite")
box(col="white")
#plot false colour compisite
par(col.axis="white",col.lab="white",tck=0)
plotRGB(image, r = 5, g = 4, b = 3, axes = TRUE, stretch = "lin", main = "False Color Composite")
box(col="white")
#Calculating Normalized Difference Vegetation Index
ndvi <- (image[[5]] - image[[4]])/(image[[5]] + image[[4]])
#Plot NDVI
as(ndvi, "SpatialPixelsDataFrame") %>% 
  as.data.frame() %>%
  ggplot(data = .) +
  geom_tile(aes(x = x, y = y, fill = layer)) +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor = element_blank()) +
  labs(title = "NDVI for Bristol", 
       x = " ", 
       y = " ") +
  scale_fill_gradient(high = "#CEE50E", 
                      low = "#087F28",
                      name = "NDVI")

#Supervised Classification

# create training points in mapview
points <- viewRGB(image, r = 4, g = 3, b = 2) %>% editMap()

# save as clouds after first iteration
clouds <- points$finished$geometry %>% st_sf() %>% mutate(class = "clouds", id = 1)
# save as developed land second time
developed <- points$finished$geometry %>% st_sf() %>% mutate(class = "developed", id = 2)
# then save as undeveloped land after third iteration
undeveloped <- points$finished$geometry %>% st_sf() %>% mutate(class = "undeveloped", id = 3)
# finally save as water
water <- points$finished$geometry %>% st_sf() %>% mutate(class = "water", id = 4)

training_points <- rbind(clouds, developed, undeveloped, water)

#Extracting spectral values from the raster
training_points <- as(training_points, 'Spatial')

df <- raster::extract(image, training_points) %>%
  round()

profiles <- df %>% 
  as.data.frame() %>% 
  cbind(., training_points$id) %>% 
  rename(id = "training_points$id") %>% 
  na.omit() %>% 
  group_by(id) %>% 
  summarise(band1 = mean(band1),
            band2 = mean(band2),
            band3 = mean(band3),
            band4 = mean(band4),
            band5 = mean(band5),
            band6 = mean(band6),
            band7 = mean(band7),
            band8 = mean(band8),
            band9 = mean(band9),
            band10 = mean(band10),
            band11 = mean(band11)) %>% 
  mutate(id = case_when(id == 1 ~ "clouds",
                        id == 2 ~ "developed",
                        id == 3 ~ "undeveloped",
                        id == 4 ~ "water")) %>% 
  as.data.frame()

