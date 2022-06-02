# Iraq IE
# Distance to Project Roads


# Load Data --------------------------------------------------------------------
# Grid
grid <- readRDS(file.path(
  project_file_path, "Data", "VIIRS", "FinalData",
  GRID_SAMPLE, "morocco_grid_blank.Rds"
))
coordinates(grid) <- ~ lon + lat # convert to spatial object
crs(grid) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") # assign projection


# Project Roads
eljadidah_safi <- readRDS(file.path(
  project_file_path, "Data", "Project_Roads",
  "FinalData", "eljadidah_safi.Rds"
))

khouribga_benimellal <- readRDS(file.path(
  project_file_path, "Data", "Project_Roads",
  "FinalData", "khouribga_benimellal.Rds"
))

# Prep Roads -------------------------------------------------------------------
## Buffer by small amount; needed for dissolving. Buffer by 1 meter
eljadidah_safi <- gBuffer(eljadidah_safi, width = .001 / 111.12, byid = T)
khouribga_benimellal <- gBuffer(khouribga_benimellal, width = .001 / 111.12, byid = T)


khouribga_benimellal$one <- 1
khouribga_benimellal <- raster::aggregate(khouribga_benimellal, by = "one") # aggregate road as one object

eljadidah_safi$one <- 1
eljadidah_safi <- raster::aggregate(eljadidah_safi, by = "one")


# Project ----------------------------------------------------------------------
grid <- spTransform(grid, CRS(UTM_MOR))
khouribga_benimellal <- spTransform(khouribga_benimellal, CRS(UTM_MOR))
eljadidah_safi <- spTransform(eljadidah_safi, CRS(UTM_MOR))


# Calculate Distance -----------------------------------------------------------
grid$dist_eljadidah_safi <- gDistance_chunks(grid, eljadidah_safi, 5000, 1) / 1000 # convert from meters to km
grid$dist_khouribga_benimellal <- gDistance_chunks(grid, khouribga_benimellal, 5000, 1) / 1000 # convert from meters to km

# Export -----------------------------------------------------------------------
saveRDS(grid@data, file = file.path(
  project_file_path, "Data", "VIIRS", "FinalData",
  GRID_SAMPLE, "morocco_grid_dist_projectroads.Rds"
))
