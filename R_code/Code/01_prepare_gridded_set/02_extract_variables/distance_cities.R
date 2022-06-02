# Morocco IE
# Distance to Cities : Creates variable that measures distance between two major cities in Morocco

# Load Data --------------------------------------------------------------------
# Grid
grid <- readRDS(file.path(
  project_file_path, "Data", "VIIRS", "FinalData",
  GRID_SAMPLE, "morocco_grid_blank.Rds"
))

coordinates(grid) <- ~ lon + lat # convert to a spatial object
crs(grid) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") # assign projection

# Cities
cities_df <- bind_rows(
  data.frame(lat = 31.63, lon = -8.008889, name = "Marakkesh"),
  data.frame(lat = 34.033333, lon = -6.833333, name = "Rabat")
)
coordinates(cities_df) <- ~ lon + lat
crs(cities_df) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

# Project ----------------------------------------------------------------------
grid <- spTransform(grid, CRS(UTM_MOR)) # make sure all the spatial objects have the same CRS
cities_df <- spTransform(cities_df, CRS(UTM_MOR))


# Distance ---------------------------------------------------------------------
for (i in 1:nrow(cities_df)) {
  cities_df_i <- cities_df[i, ]

  name_i <- cities_df_i$name %>% tolower()

  grid[[paste0("dist_", name_i, "_km")]] <- as.vector(gDistance_chunks(grid, cities_df_i, 5000)) / 1000 # to km
} # function that computes the distance for the entire grid

# Note: gDistance_chunks is a function created for this script. The source is in the main master script.

# Export -----------------------------------------------------------------------
saveRDS(grid@data, file = file.path(
  project_file_path, "Data", "VIIRS", "FinalData",
  GRID_SAMPLE,
  "morocco_grid_dist_cities.Rds"
))
