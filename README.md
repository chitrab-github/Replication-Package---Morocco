# Morocco Replication Package
## Overview 

The code in this replication package constructs the analysis file from 5 external publicly available data sources (GADM, VIIRS, OSM, Inland Water Bodies, and NDVI) using R. Two master files run all of the code to generate the data for the 4 figures and 2 tables in the paper. 

## Project Description 
The project uses nighttime lights imagery in conjunction with a combination of externally available datasets mentioned above to evaluate the impact of road upgrades of two major highways in Morocco. The two project roads are : 
1. El-Jadida – Safi Highway 
2. Khouribga – Benimellal Highway The sample consists of all the area within 20kms of each of the project highways. 

The final analysis is conducted on two datasets : 
1. El-Jadida-Safi Grid: Pixel-level (resolution 750m) data around the El-Jadida-Safi highway within a 20km buffer of the road 
2. Khouribga – Benimellal Grid : Pixel-level (resolution 750m) data around the Khouribga – Benimellal highway within a 20km buffer of the road 

Each of these roads underwent road upgrades. El-Jadida Safi opened to the public as of August 1, 2016 . Khouribga – Benimellal opened on May 17, 2014. Using these two road openings, we create a variable “road_improvement”, and determine the correlation between road openings and nighttime lights within the 20km buffer, using simple panel regression models. The econometric model used for the regression is as follows: 
 𝑁𝑇𝐿<sub>𝑖𝑡</sub> = 𝛼 + 𝛽𝐻𝑖𝑔ℎ𝑤𝑎𝑦𝑂𝑝𝑒𝑛𝑖𝑛𝑔<sub>𝑖𝑡</sub> + 𝐷<sub>𝑖</sub> + 𝐷<sub>𝑡</sub> + 𝜖
1. 𝑁𝑇𝐿<sub>𝑖𝑡</sub> is the light intensity of the pixel i in the course of month t. 
2. 𝐻𝑖𝑔ℎ𝑤𝑎𝑦𝑂𝑝𝑒𝑛𝑖𝑛𝑔<sub>𝑖𝑡</sub> indicator that takes value 1 for all nearby pixels as of month t when the highway first opens to traffic and zero otherwise. 
3. 𝐷<sub>𝑖</sub> + 𝐷<sub>𝑡</sub> represent the fixed effects of each pixel and the monthly trends relating to light intensity, respectively. 
The panel nature of the data allows to mitigate the omitted variable bias problem, control for country−wide shocks, and possible time−invariant unobservable characteristics at the pixel level.
## Replication Package Dataset List 
All the data is external and publicly available. Within the “Data” in this [OneDrive folder](https://worldbankgroup-my.sharepoint.com.mcas.ms/personal/cbalasubramania2_worldbank_org/_layouts/15/onedrive.aspx?login_hint=cbalasubramania2%40worldbank%2Eorg&id=%2Fpersonal%2Fcbalasubramania2%5Fworldbank%5Forg%2FDocuments%2FReplication%20Package%20%2D%20Morocco%2Fsample%5Fcode%2FR%5Fcode), each sub-folder is a different source of data used to create the final analysis dataset.  
| Data File                               | Source        | Notes                                                              | Provided|
| --------------------------------------- | ------------- |------------------------------------------------------------------- |---------|
|Data/GADM/RawData/ gadm36_MAR_4_sp.Rds | [GADM](https://gadm.org/)          |Creates shapefiles at the lowest administrative unit (sub-district) | Yes     |
Data/Inland Water Bodies/RawData/MAR_water_areas_dcw.shp|[Inland Water Bodies](https://africaopendata.org/dataset/morocco-maps/resource/30e9259b-02c9-4f8e-a337-44738de874cf) |Uses the water bodies to remove any large water bodies from the GADM shapefile.|Yes|
Data/NDVI/MODIS-monthly/RawData/ndvi_modis_morocco_monthly_1km_2012.png, Note: These raster are available from 2012-2020|[NDVI](https://modis.gsfc.nasa.gov/data/dataprod/mod13.php)| Creates the ndvi variable that provides the vegetation index in the project area| Yes|
Data/Project_Roads/FinalData/ eljadidah_safi.Rds Data/Project_Roads/FinalData/ Khouribga_benimellal.Rds|OSM| The shapefiles of the project roads are used to create the final grid within a 20km radius of the road| Yes|
Data/VIIRS/FinalData/near_eljadida_safi/ Data/VIIRS/FinalData/near_khouribga_benimellal/ Note : The raster that creates these final grids is also provided in VIIRS folder under “RawData”|[VIIRS](https://developers.google.com/earth-engine/datasets/catalog/NOAA_VIIRS_DNB_MONTHLY_V1_VCMCFG)| Grid-level panel from 2012- 2020 (resolution of 750m) of VIIRS data within 20km of the project roads| Yes|

-------------------------------------------------
      
## Master Script Instructions 
There are two master scripts. 
1. ```morocco_ie_master``` loads all packages and functions required to run the code. In line 5, the reviewer should change the directory paths. 
2. ```morocco_viirs_master``` Within the sub-folder “Code”, the master script runs both the data processing and analysis scripts. The script allows you to first run the data processing and data analysis files separately. For example, in line 18 and 19, if you keep RUN_CODE_CLEAN_DATA <- T RUN_CODE_ANALYSIS <- F, it would run only the data cleaning scripts within the master script. Similarly, to run the analysis, switch the TRUE and FALSE options. Scripts to be review are broken down as follows: <br>
  
Code/01_prepare_gridded_set
1. 01_prepare_gridded_set/01_prep_grids 
   * 01_prep_grids /create_grid_near_eljadida_safi.R
   * 01_prep_grids /create_grid_near_khouribga_benimellal.R
2. 01_prepare_gridded_set/02_extract_variables 
   * 02_extract_variables/distance_cities.R
   * 02_extract_variables/distance_project_roads.R
   * 02_extract_variables/distance_project_roads.R
   * 02_extract_variables/gadm.R
   * 02_extract_variables/ndvi.R 
5. 01_prepare_gridded_set/03_merge
   * 03_merge/01_merge_variables.R
   * 03_merge/02_clean_variables.R 

Code/ 02_analysis <br>
1. 02_analysis/ 02_viirs_figures_eljadida_safi.R 
2. 02_analysis /02_viirs_figures_khouribga_benimellal.R 
3. 02_analysis/03_final_analysis_khouribga_eljadida.R 

**The master script ```morocco_viirs_master``` runs all the scripts**. Since there are two project roads, the master script needs to be run twice. GRID_SAMPLE within the master script allows you to choose which project you want to run. Thus, in this code review, *you would be reviewing 12 scripts, 9 in preparing the gridded dataset, and 3 in analysis.* <br>

## Outputs
The code generates four figures <br>
1. El-Jadida-Safi : 
   * Data/VIIRS/Output/Figures/ ntl_buffers_lessthan5.png 
   * Data/VIIRS/Output/Figures/ ntl_buffers_morethan5.png 
2. Khouribga-Benimellal:
   * Data/VIIRS/Output/Figures/ ntl_buffers_lessthan5.png 
   * Data/VIIRS/Output/Figures/ ntl_buffers_morethan5.png 

The code also generates two regression tables: 
1. Reg_5_10_20km_pixel_khouribga.tex
2. Reg_5_10_20km_pixel_eljadida.tex 

If you’d like to run them in Latex, run the following preamble: <br>
\documentclass{article} <br>
\usepackage[utf8]{inputenc} <br>
\usepackage{graphicx}<br>
\usepackage{longtable} <br>
\usepackage{amsmath} <br>
\usepackage{amssymb} <br>
\usepackage{amsthm} <br>
\usepackage{float} <br>

## Runtime 
The script which creates the pixel grid around each road takes about 30 mins. The remaining scripts take about 15 mins. **The replicator should expect the code to run for about 2 hours.**

### System Requirements
The code was last run on a Windows 11 Laptop with 8GB RAM

### .gitignore
In addition to this template README, this repo is also created with a DIME Analytic's template `.gitignore` file. Read more about this template and why ignore files are needed [here](https://github.com/worldbank/dime-github-trainings/tree/master/GitHub-resources/DIME-GitHub-Templates).
