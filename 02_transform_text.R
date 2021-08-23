transform_news_text <- function(dir_name, dir_name_out) {

# Import summary datasets
yesterday_headlines <- readRDS(file = paste0(dir_name, "/yesterday_headlines.rds"))
yesterday_query <- readRDS(file = paste0(dir_name, "/yesterday_query.rds"))

# Create list to append results
word_cloud_list <- list()

# Check whether output directory exists to save individual plots
if (!dir.exists(dir_name_out)) {
  dir.create(dir_name_out)
} else {
  print("Output directory already exists")
}

# Tokenize text ------------------------------------------------------

tokenized_headlines <- yesterday_headlines %>% 
  unnest_tokens(input = text, output = tokens, token = "words", to_lower = TRUE)

tokenized_query <- yesterday_query %>% 
  unnest_tokens(input = text, output = tokens, token = "words", to_lower = TRUE)

# Clean tokens ------------------------------------------------------

if (!file.exists(paste0(dir_name, "/czech_stopwords.txt"))) {
  download.file(url = "https://raw.githubusercontent.com/stopwords-iso/stopwords-cs/master/stopwords-cs.txt", destfile = paste0(dir_name, "/czech_stopwords.txt"))
} else {
  print("Stopword list already exists")
}

stop_words_cz <- read_csv(file = paste0(dir_name, "/czech_stopwords.txt"), 
                          col_names = "tokens", col_types = "c")

tokenized_headlines_clean <- tokenized_headlines %>%
  anti_join(stop_words_cz) %>% 
  filter(!str_detect(tokens, "^[0-9]"))

tokenized_query_clean <- tokenized_query %>%
  anti_join(stop_words_cz) %>% 
  filter(!str_detect(tokens, "^[0-9]"))


# Lemmatize tokens ------------------------------------------------------

# Fitting the udpipe model with downloaded Czech model

if (!file.exists(paste0(dir_name, "/czech-pdt-ud-2.5-191206.udpipe"))) {
  udpipe_download_model(language = "czech-pdt", model_dir = dir_name)
} else {
  print("Udpipe model already exists")
}

lemma_headlines_clean <- udpipe(x = tokenized_headlines_clean$tokens, object = paste0(dir_name, "/czech-pdt-ud-2.5-191206.udpipe")) %>% 
  select(lemma)

lemma_query_clean <- udpipe(x = tokenized_query_clean$tokens, object = paste0(dir_name, "/czech-pdt-ud-2.5-191206.udpipe")) %>% 
  select(lemma)


# Separate by sentiment ------------------------------------------------------

if (!file.exists(paste0(dir_name, "/czech_sentiment_lexicon.csv"))) {
  download.file(url = "https://lindat.mff.cuni.cz/repository/xmlui/bitstream/handle/11858/00-097C-0000-0022-FF60-B/sublex_1_0.csv?sequence=1&isAllowed=y", destfile = paste0(dir_name, "/czech_sentiment_lexicon.csv"))
} else {
  print("Sentiment lexicon already exists")
}

sentiment_lexicon_cz <- read_delim(paste0(dir_name, "/czech_sentiment_lexicon.csv"),
                                   "\t", 
                                   escape_double = FALSE, 
                                   col_names = FALSE,
                                   col_types = "ccccc",
                                   trim_ws = TRUE) %>% 
  transmute(lemma = str_remove(X3, pattern = "_.*"),
            sentiment = X4)

word_cloud_list[["lemma_headlines_clean_pos"]] <- sentiment_lexicon_cz %>% 
  filter(sentiment == "POS") %>% 
  inner_join(lemma_headlines_clean) %>% 
  select(-sentiment) %>% 
  count(lemma, sort = TRUE) %>% 
  ungroup()

word_cloud_list[["lemma_headlines_clean_neg"]] <- sentiment_lexicon_cz %>% 
  filter(sentiment == "NEG") %>% 
  inner_join(lemma_headlines_clean) %>% 
  select(-sentiment) %>% 
  count(lemma, sort = TRUE) %>% 
  ungroup()

word_cloud_list[["lemma_query_clean_pos"]] <- sentiment_lexicon_cz %>% 
  filter(sentiment == "POS") %>% 
  inner_join(lemma_query_clean) %>% 
  select(-sentiment) %>% 
  count(lemma, sort = TRUE) %>% 
  ungroup()

word_cloud_list[["lemma_query_clean_neg"]]  <- sentiment_lexicon_cz %>% 
  filter(sentiment == "NEG") %>% 
  inner_join(lemma_query_clean) %>% 
  select(-sentiment) %>% 
  count(lemma, sort = TRUE) %>% 
  ungroup()

# Count tokens ------------------------------------------------------

word_cloud_list[["tokenized_headlines_clean_counted"]] <- tokenized_headlines_clean %>% 
  count(tokens) %>% 
  arrange(desc(n)) %>% 
  ungroup()

word_cloud_list[["tokenized_query_clean_counted"]] <- tokenized_query_clean %>% 
  count(tokens) %>% 
  arrange(desc(n)) %>% 
  ungroup()

return(word_cloud_list)

    }