# Load required libraries -------------------------------------------------

# Package names
packages <- c("dplyr", "owmr")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# Function 1: get headlines from yesterday --------------------------------

weather_forecast <- function(units, city, dir_name) {
  
forecast_df <- get_forecast(city = city, units = units) %>%
  owmr_as_tibble()

# We have to create a desired directory, if one does not yet exist
if (!dir.exists(dir_name)) {
  dir.create(dir_name)
} else {
  print("Output directory already exists")
}

saveRDS(object = forecast_df, file = paste0(dir_name, "/weather_forecast.rds"), compress = FALSE)

}

# Function Arguments ------------------------------------------------------

dir_name <- "data"
city <- "Prague"
units <-  "metric"

# Run Functions -----------------------------------------------------------
weather_forecast(units = units,
                 city = city,
                 dir_name = dir_name)