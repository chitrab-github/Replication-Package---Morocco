#Morocco
#El-Jadida Analysis

# Load Data ---------------------------------------------------------------
grid_e <- readRDS(file.path(project_file_path, "Data", "VIIRS", "FinalData","near_eljadida_safi",
                          "viirs_grid_clean.Rds"))
grid_k <- readRDS(file.path(project_file_path, "Data", "VIIRS", "FinalData",
                          "near_khouribga_benimellal",
                          "viirs_grid_clean.Rds"))

#*******************************************************************************************
#                                  PIXEL - LEVEL 
#*******************************************************************************************
# Prep for Regression (Eljadida - Safi) =====================================================
#Create grid with 20km buffer
grid_monthly_subdist <- grid_e %>%
  filter(dist_eljadidah_safi > 1 & dist_eljadidah_safi <= 20) %>%
  group_by(id, year,month, GADM_ID_2,year_month,dist_eljadidah_safi,
           ndvi,transformed_avg_rad_df) %>%
  filter(!is.na(GADM_ID_2)) %>%
  ungroup()



#road_improvement: This variable indicates the year the road opened to the public post road upgrades
grid_monthly_subdist$road_improvement <- ifelse(grid_monthly_subdist$year_month > "2016-07-01",1,0)


#1. Regression(5km) ---------------------------------------------------------
#Within the 5km buffer
grid_5km_eljadida <- grid_monthly_subdist %>%
  filter(dist_eljadidah_safi > 1 & dist_eljadidah_safi <= 5)


reg1_5km_eljadida <- lm.cluster(transformed_avg_rad_df ~ road_improvement + ndvi,
           data = grid_5km_eljadida, cluster = "id" )

reg2_5km_eljadida <- lm.cluster(transformed_avg_rad_df ~ road_improvement + factor(year_month) + ndvi,
           data = grid_5km_eljadida, cluster = "id") #trying different specifications

reg3_5km_eljadida <- plm(transformed_avg_rad_df ~ road_improvement + ndvi, 
            data = grid_5km_eljadida, 
            index = c("id", "year_month"), 
            model = "within")

cov1 <- vcovHC(reg3_5km_eljadida, type = "HC1") #clustering standard errors
robust_se1 <- sqrt(diag(cov1))

#2. Regression(10km) ---------------------------------------------------------
#Within the 10km buffer
grid_10km_eljadida <- grid_monthly_subdist %>%
  filter(dist_eljadidah_safi > 1 & dist_eljadidah_safi <= 10)


reg1_10km_eljadida <- lm.cluster(transformed_avg_rad_df ~ road_improvement + ndvi,
           data = grid_10km_eljadida, cluster = "id")

reg2_10km_eljadida <- lm.cluster(transformed_avg_rad_df ~ road_improvement + factor(year_month) + ndvi,
           data = grid_10km_eljadida, cluster = "id") 

reg3_10km_eljadida <- plm(transformed_avg_rad_df ~ road_improvement + ndvi, 
            data = grid_10km_eljadida, 
            index = c("id", "year_month"), 
            model = "within")
cov2 <- vcovHC(reg3_10km_eljadida, type = "HC1")
robust_se2 <- sqrt(diag(cov2))

#3. Regression(20km) ---------------------------------------------------------
#Within the 20km buffer
grid_20km_eljadida <- grid_monthly_subdist %>%
  filter(dist_eljadidah_safi > 1 & dist_eljadidah_safi <= 20)


reg1_20km_eljadida <- lm.cluster(transformed_avg_rad_df ~ road_improvement + ndvi,
           data = grid_20km_eljadida, cluster = "id")

reg2_20km_eljadida <- lm.cluster(transformed_avg_rad_df ~ road_improvement + factor(year_month) + ndvi,
           data = grid_20km_eljadida, cluster = "id")

reg3_20km_eljadida <- plm(transformed_avg_rad_df ~ road_improvement + ndvi, 
            data = grid_20km_eljadida, 
            index = c("id", "year_month"), 
            model = "within")

cov3 <- vcovHC(reg3_20km_eljadida, type = "HC1")
robust_se3 <- sqrt(diag(cov3))


# Prep for Regression (Khouribga - Benimellal) ======================================================
# Create dataset for 20km buffer
grid_monthly_subdist <- grid_k %>%
  filter(dist_khouribga_benimellal > 1 & dist_khouribga_benimellal <= 20) %>%
  group_by(id, year,month, GADM_ID_2,year_month,dist_khouribga_benimellal,
           ndvi,transformed_avg_rad_df) %>%
  filter(!is.na(GADM_ID_2)) %>%
  ungroup()

#road_improvement
grid_monthly_subdist$road_improvement <- ifelse(grid_monthly_subdist$year_month > "2014-04-01",1,0)

#1. Regression(5km) ---------------------------------------------------------
grid_5km_khouribga <- grid_monthly_subdist %>%
  filter(dist_khouribga_benimellal > 1 & dist_khouribga_benimellal <= 5)


reg1_5km_khouribga <- lm.cluster(transformed_avg_rad_df ~ road_improvement + ndvi,
           data = grid_5km_khouribga, cluster = "id")

reg2_5km_khouribga <- lm.cluster(transformed_avg_rad_df ~ road_improvement + factor(year_month) + ndvi,
           data = grid_5km_khouribga, cluster = "id")

reg3_5km_khouribga <- plm(transformed_avg_rad_df ~ road_improvement + ndvi, 
            data = grid_5km_khouribga, 
            index = c("id", "year_month"), 
            model = "within")

cov4 <- vcovHC(reg3_5km_khouribga, type = "HC1")
robust_se4 <- sqrt(diag(cov4))

#2. Regression(10km) ---------------------------------------------------------
grid_10km_khouribga <- grid_monthly_subdist %>%
  filter(dist_khouribga_benimellal > 1 & dist_khouribga_benimellal <= 10)


reg1_10km_khouribga <- lm.cluster(transformed_avg_rad_df ~ road_improvement + ndvi,
           data = grid_10km_khouribga, cluster = "id")

reg2_10km_khouribga <- lm.cluster(transformed_avg_rad_df ~ road_improvement + factor(year_month) + ndvi,
           data = grid_10km_khouribga, cluster = "id")

reg3_10km_khouribga <- plm(transformed_avg_rad_df ~ road_improvement + ndvi, 
            data = grid_10km_khouribga, 
            index = c("id", "year_month"), 
            model = "within")

cov5 <- vcovHC(reg3_10km_khouribga, type = "HC1")
robust_se5 <- sqrt(diag(cov5))

#3. Regression(20km) ---------------------------------------------------------
grid_20km_khouribga <- grid_monthly_subdist %>%
  filter(dist_khouribga_benimellal > 1 & dist_khouribga_benimellal <= 20)


reg1_20km_khouribga <- lm(transformed_avg_rad_df ~ road_improvement + ndvi,
           data = grid_20km_khouribga)

reg2_20km_khouribga <- lm(transformed_avg_rad_df ~ road_improvement + factor(year_month) + ndvi,
           data = grid_20km_khouribga)

reg3_20km_khouribga <- plm(transformed_avg_rad_df ~ road_improvement + ndvi, 
            data = grid_20km_khouribga, 
            index = c("id", "year_month"), 
            model = "within")

cov6 <- vcovHC(reg3_20km_khouribga, type = "HC1")
robust_se6 <- sqrt(diag(cov6))

#*******************************************************************************************
#                                   OUTPUT TABLES (REPORT)
#*******************************************************************************************

#Table 1 - Spatial Heterogeneity of the Econometric Results for Khouribga-Beni Mellal

stargazer(reg3_5km_khouribga,
          reg3_10km_khouribga,
          reg3_20km_khouribga,
          se = list(robust_se4,robust_se5,robust_se6),
          keep = c("road_improvement", "ndvi"),
          column.labels = c("5km","10km","20km"),
          dep.var.labels = c("Average Radiance (Log)"),
          font.size = "small",
          digits = 3,
          omit.stat = c("ser"),
          add.lines = list(c("Month and Sub-District FE","Yes", "Yes", "Yes")),
          out = file.path(project_file_path,"Data","VIIRS","Output",
                          "Tables","Reg_5_10_20km_pixel_khouribga.tex"),
          float = F,
          header = F)

#Table 2 - Spatial Heterogeneity of the Econometric Results for El - Jadida Safi
stargazer(reg3_5km_eljadida,
          reg3_10km_eljadida,
          reg3_20km_eljadida,
          se = list(robust_se1,robust_se2,robust_se3),
          keep = c("road_improvement", "ndvi"),
          column.labels = c("5km","10km","20km","5km","10km","20km"),
          dep.var.labels = c("Average Radiance (Log)"),
          font.size = "small",
          digits = 3,
          omit.stat = c("ser"),
          add.lines = list(c("Month and Sub-District FE","Yes", "Yes", "Yes")),
          out = file.path(project_file_path, "Data","VIIRS","Output","Tables",
                          "Reg_5_10_20km_pixel_eljadida.tex"),
          float = F,
          header = F)



