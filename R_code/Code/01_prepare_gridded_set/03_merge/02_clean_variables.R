# Morocco
# Clean Grid

# Load Data ---------------------------------------------------------------
grid <- readRDS(file.path(
  project_file_path, "Data", "VIIRS", "FinalData", GRID_SAMPLE,
  "viirs_grid.Rds"
))

# Create variables -------------------------------------------------------------
# year_month
grid$year_month <- paste0(grid$year, "-", grid$month, "-01") %>%
  ymd() # %>% substring(1,6) ## keep as date variable; less memory intensive than string/factor


# treatment variable - transformed mean. This transformation of log comes from the paper (Mitnik et al., 2018)
grid <- grid %>%
  group_by(id, year_month) %>%
  mutate(
    avg_rad_df = mean(avg_rad_df),
    transformed_avg_rad_df = log(avg_rad_df + sqrt((avg_rad_df)^2 + 1))
  ) %>%
  ungroup()


# Clean  ------------------------------------------------------------------
# remove summer solistice
grid <- grid %>%
  filter(!month == 6)

# Export -----------------------------------------------------------------------
saveRDS(grid, file.path(
  project_file_path, "Data", "VIIRS", "FinalData", GRID_SAMPLE,
  "viirs_grid_clean.Rds"
))
