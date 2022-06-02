# Morocco
# Merge

IN_PATH <- file.path(
  project_file_path, "Data", "VIIRS", "FinalData",
  GRID_SAMPLE
)

# Load Data --------------------------------------------------------------------
panel_viirs <- readRDS(file.path(IN_PATH, "morocco_grid_panel_viirs.Rds")) %>% as.data.table()

# Merge Cross Section Data -----------------------------------------------------
cross_section_data_names <- c(
  "morocco_grid_dist_projectroads.Rds",
  "morocco_grid_gadm.Rds",
  "morocco_grid_dist_cities.Rds"
)



for (data_name_i in cross_section_data_names) {
  print(data_name_i)

  data_i <- readRDS(file.path(IN_PATH, data_name_i)) %>% as.data.table()
  panel_viirs <- merge(panel_viirs, data_i, by = "id")

  # Cleanup as memory intensive
  rm(data_i)
  gc()
} # function to merge all the time-invariant data with the VIIRS data


# Merge Panel Data (NDVI) -------------------------------------------------------------
panel_data_names <- c("morocco_grid_ndvi.Rds")

for (data_name_i in panel_data_names) {
  print(data_name_i)

  data_i <- readRDS(file.path(IN_PATH, data_name_i)) %>% as.data.table()
  panel_viirs <- merge(panel_viirs, data_i, by = c("id", "month", "year"))

  # Cleanup as memory intensive
  rm(data_i)
  gc()
}

# Export -----------------------------------------------------------------------
saveRDS(panel_viirs, file.path(
  project_file_path, "Data", "VIIRS", "FinalData", GRID_SAMPLE,
  "viirs_grid.Rds"
))
