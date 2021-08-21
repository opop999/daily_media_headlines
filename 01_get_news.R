# Load required libraries -------------------------------------------------

# Package names
packages <- c("dplyr", "newsanchor", "stringr")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# Function 1: get headlines from yesterday --------------------------------

yesterday_headlines <- function(country, api_key, dir_name) {

  # We have to create a desired directory, if one does not yet exist
  if (!dir.exists(dir_name)) {
    dir.create(dir_name)
  } else {
    print("Output directory already exists")
  }

  results_list <- get_headlines(country = country, api_key = api_key)

  results_df <- results_list[[2]][, c("published_at", "title", "description")]

  results_clean_text <- results_df %>%
    mutate(published_at = as.Date(published_at)) %>%
    filter(published_at == Sys.Date() - 1) %>%
    mutate(
      title = str_remove(title, pattern = "-.*"),
      text = str_c(title, description)
    ) %>%
    select(text)

  saveRDS(object = results_clean_text, file = paste0(dir_name, "/yesterday_headlines.rds"), compress = FALSE)
}

# Function 2: get news on specific query ----------------------------------

yesterday_query <- function(query, date, dir_name, api_key) {

  # We have to create a desired directory, if one does not yet exist
  if (!dir.exists(dir_name)) {
    dir.create(dir_name)
  } else {
    print("Output directory already exists")
  }

  results_list <- get_everything(from = date, query = query, api_key = api_key)

  results_df <- results_list[[2]][, c("title", "description")]

  results_clean_text <- results_df %>%
    transmute(text = str_c(title, description, sep = " "))

  saveRDS(object = results_clean_text, file = paste0(dir_name, "/yesterday_query.rds"), compress = FALSE)
}

# Function Arguments ------------------------------------------------------

dir_name <- "data"

country <- "cz"

query <- "volby"

date <- Sys.Date() - 1

api_key <- Sys.getenv("NEWS_API_KEY")


# Run Functions -----------------------------------------------------------

yesterday_headlines(
  country = country,
  api_key = api_key,
  dir_name = dir_name
)

yesterday_query(
  query = query,
  api_key = api_key,
  dir_name = dir_name,
  date = date
)
