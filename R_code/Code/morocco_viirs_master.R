# Morocco IE
# VIIRS Analysis Master Script


#### Grid Sample
# Grid sample is the sample of viirs grids.
# OPTIONS
#   1. near_khouribga_benimellal: creates a grid that is 300km from a trunk road or
#      motorway (from OSM), the khouribga-benimellal highway
#   2. near_eljadida_safi: creates a grid with all cells with 30km
#      of the Eljadida - Safi highway, where cells are also
#      limited to those in Morocco
####

GRID_SAMPLE <- "near_khouribga_benimellal"

#### Scripts to Run
RUN_CODE_CLEAN_DATA <- F # for data construction
RUN_CODE_ANALYSIS <- T # for data analysis

#### Paths
datawork_viirs <- file.path(project_file_path, "Code")

# 1. Clean Data ----------------------------------------------------------------
if (RUN_CODE_CLEAN_DATA) {
  prep_data_path <- file.path(datawork_viirs, "01_prepare_gridded_set")

  #### Create grid
  ## Creates the following files:
  # morocco_grid_panel_viirs.Rds: Panel with VIIRS data
  # morocco_grid_panel_blank.Rds: Blank panel grid
  # morocco_grid_blank.Rds: Blank grid of one time period
  source(file.path(prep_data_path, "01_prep_grids", paste0("create_grid_", GRID_SAMPLE, ".R")))

  ### Extract datasets to grid

  #### Creates the shapefile at the lowest administrative level - Sub-District
  ## Creates the following file:
  # morocco_grid_gadm.Rds: Administrative units at the sub-district level
  source(file.path(prep_data_path, "02_extract_variables", "gadm.R"))


  #### Creates the variable that measures distance of the project roads from each pixel
  ## Creates the following file:
  # morocco_grid_dist_projectroads.Rds: Distance measured from project road to each pixel in the grid
  source(file.path(prep_data_path, "02_extract_variables", "distance_project_roads.R"))

  #### Creates the variable that extracts ndvi for each pixel in the grid between 2012 - 2020
  ## Creates the following file:
  # morocco_grid_ndvi.Rds: Creates a panel with ndvi for each pixel
  source(file.path(prep_data_path, "02_extract_variables", "ndvi.R"))

  #### Creates the variable that measures distance of the main cities in Morocco from each pixel
  ## Creates the following file:
  # morocco_grid_dist_cities.Rds: Measures distance between Rabat and Marakkesh and each pixel
  source(file.path(prep_data_path, "02_extract_variables", "distance_cities.R"))

  #### Merge and clean dataset

  #### The script that merges all the variables to create the final analysis dataset
  ## Creates the following file:
  # viirs_grid.Rds: The analysis dataset at the grid level
  source(file.path(prep_data_path, "03_merge", "01_merge_variables.R"))


  #### Creates additional variables for analysis and aggregates the treatment variable
  ## Creates the following file:
  # viirs_grid_clean.Rds: The final dataset for analysis at the grid level
  source(file.path(prep_data_path, "03_merge", "02_clean_variables.R"))
}

# 2. Analysis ------------------------------------------------------------------
if (RUN_CODE_ANALYSIS) {
  analysis_path <- file.path(datawork_viirs, "02_analysis")

  # figures

  #### Constructs a trend-line for the night-time lights around the project road (Eljadida - Safi)
  ## Creates the following graphs:
  # ntl_buffers_lessthan5.png : Trendline for the nighttime lights around a buffer of less than 5km
  # ntl_buffers_morethan5.png : Trendline for the nighttime lights around a buffer of more than 5km
  source(file.path(analysis_path, "02_viirs_figures_eljadida_safi.R"))


  #### Constructs a trend-line for the night-time lights around the project road (Khouribga - Benimellal)
  ## Creates the following graphs:
  # ntl_buffers_lessthan5.png : Trendline for the nighttime lights around a buffer of less than 5km
  # ntl_buffers_morethan5.png : Trendline for the nighttime lights around a buffer of more than 5km
  source(file.path(analysis_path, "02_viirs_figures_khouribga_benimellal.R"))


  # regressions

  #### Creates script to run regression analysis for both project roads
  ## Creates the following regression tables:
  # Reg_5_10_20km_pixel_khouribga.tex : Within the 5,10,20km buffer, regression between nighttime lights and road opening
  # Reg_5_10_20km_pixel_eljadida.tex  : Within the 5,10,20km buffer, regression between nighttime lights and road opening

  source(file.path(analysis_path, "03_final_analysis_khouribga_eljadida.R"))
}
