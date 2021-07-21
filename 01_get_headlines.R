# PART 1: LOAD THE REQUIRED R LIBRARIES

# Package names
packages <- c("dplyr", "newsanchor", "readr")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

results <- get_headlines(country = "cz", api_key = Sys.getenv("NEWS_API_KEY"))

results_df <- results[[2]]

results <- get_everything(from = "2021-07-01", query = "Volby")

results_df <- results[[2]]
