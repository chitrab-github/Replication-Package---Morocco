# Morocco

# Load Data --------------------------------------------------------------------
# Grid
grid <- readRDS(file.path(
  project_file_path, "Data", "VIIRS", "FinalData",
  GRID_SAMPLE, "morocco_grid_blank.Rds"
))
coordinates(grid) <- ~ lon + lat
crs(grid) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

# Morocco GADM
mor_adm2 <- readRDS(file.path(project_file_path, "Data", "GADM", "RawData", "gadm36_MAR_2_sp.rds"))

# Morocco Inland Water Bodies
mor_water <- readOGR(file.path(
  project_file_path, "Data", "Inland Water Bodies",
  "RawData", "MAR_water_areas_dcw.shp"
))


# Crop Water Bodies -------------------------------------------------------
mor_water <- spTransform(mor_water, crs(mor_adm2)) # change projection
mor_adm2 <- raster::erase(mor_adm2, mor_water, byid = T) # remove water bodies


# Prep GADM --------------------------------------------------------------------
# Make IDs numeric, as uses less memory
mor_adm2$GID_1 <- mor_adm2$GID_1 %>%
  as.factor() %>%
  as.numeric()
mor_adm2$GID_2 <- mor_adm2$GID_2 %>%
  as.factor() %>%
  as.numeric()

# Extract Data -----------------------------------------------------------------
grid_OVER_mor_adm2 <- over(grid, mor_adm2)
grid$GADM_ID_1 <- grid_OVER_mor_adm2$GID_1
grid$GADM_ID_2 <- grid_OVER_mor_adm2$GID_2



# Export -----------------------------------------------------------------------
saveRDS(grid@data, file = file.path(
  project_file_path, "Data", "VIIRS", "FinalData",
  GRID_SAMPLE, "morocco_grid_gadm.Rds"
))
