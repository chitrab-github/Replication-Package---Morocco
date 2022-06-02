# Morocco IE
# Khouribga - Benimellal Trends

# Load Data ---------------------------------------------------------------
grid <- readRDS(file.path(
  project_file_path, "Data", "VIIRS", "FinalData", "near_khouribga_benimellal",
  "viirs_grid_clean.Rds"
)) %>%
  as.data.frame()

# Figure -----------------------------------------------------------------------
# Summarizing data within the 5km buffer of Khouribga-Benimellal
grid_sum_stack <- grid %>%
  group_by(year) %>%
  dplyr::summarise(
    "avg_rad_5" = mean(avg_rad_df[dist_khouribga_benimellal < 5]),
    "avg_rad_0-1" = mean(avg_rad_df[dist_khouribga_benimellal > 0 & dist_khouribga_benimellal < 1]),
    "avg_rad_1-2" = mean(avg_rad_df[dist_khouribga_benimellal > 1 & dist_khouribga_benimellal < 2]),
    "avg_rad_2-3" = mean(avg_rad_df[dist_khouribga_benimellal > 2 & dist_khouribga_benimellal < 3]),
    "avg_rad_3-4" = mean(avg_rad_df[dist_khouribga_benimellal > 3 & dist_khouribga_benimellal < 4]),
    "avg_rad_4-5" = mean(avg_rad_df[dist_khouribga_benimellal > 4 & dist_khouribga_benimellal < 5])
  ) %>%
  pivot_longer(cols = -year) %>%
  mutate(name = name %>%
    str_replace_all("avg_rad_", "")) %>%
  dplyr::rename(buffer = name)

# summarizing data within the 5,10,20km buffer of Khouribga Benimellal
grid_sum_stack_buffers <- grid %>%
  group_by(year) %>%
  dplyr::summarise(
    "avg_rad_5" = mean(avg_rad_df[dist_khouribga_benimellal <= 5]),
    "avg_rad_10" = mean(avg_rad_df[dist_khouribga_benimellal > 0 & dist_khouribga_benimellal <= 10]),
    "avg_rad_20" = mean(avg_rad_df[dist_khouribga_benimellal > 0 & dist_khouribga_benimellal <= 20])
  ) %>%
  pivot_longer(cols = -year) %>%
  mutate(name = name %>%
    str_replace_all("avg_rad_", "")) %>%
  dplyr::rename(buffer = name)

# creating the plot - Within 5km of Khouribga - Beniemllal
grid_sum_stack %>%
  ggplot(aes(
    x = year,
    y = value,
    group = buffer,
    color = buffer
  ),
  size = 1
  ) +
  geom_line(size = 1) +
  labs(
    color = "Buffer (km)",
    title = "Average NTL Radiance near\nKhouribga-Benimellal Road",
    x = "",
    y = "Average\nRadiance"
  ) +
  theme_minimal() +
  geom_vline(xintercept = 2014, linetype = "dotted") +
  scale_colour_brewer(palette = "Dark2") +
  theme(
    strip.text.x = element_text(
      size = 11,
      face = "bold"
    ),
    legend.text = element_text(size = 8),
    legend.position = "right"
  )
ggsave(filename = file.path(
  project_file_path, "Data", "VIIRS", "Output",
  "Figures",
  "ntl_buffers_lessthan5_khouribga.png"
), height = 4, width = 6, bg = "white")

# creating the plot - Within 5km,10,20km of Khouribga - Benimellal
grid_sum_stack_buffers %>%
  ggplot(aes(
    x = year,
    y = value,
    group = buffer,
    color = buffer
  ),
  size = 1
  ) +
  geom_line(size = 1) +
  labs(
    color = "Buffer (km)",
    title = "Average NTL Radiance near\nKhouribga-Benimellal Road",
    x = "",
    y = "Average\nRadiance"
  ) +
  theme_minimal() +
  geom_vline(xintercept = 2014, linetype = "dotted") +
  scale_colour_brewer(palette = "Dark2") +
  theme(
    strip.text.x = element_text(
      size = 11,
      face = "bold"
    ),
    legend.text = element_text(size = 8),
    legend.position = "right"
  )
ggsave(filename = file.path(
  project_file_path, "Data", "VIIRS", "Output",
  "Figures",
  "ntl_buffers_morethan5_khouribga.png"
), height = 4, width = 6, bg = "white")
