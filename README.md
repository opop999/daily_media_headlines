[![News API extraction](https://github.com/opop999/daily_media_headlines/actions/workflows/docker.yml/badge.svg)](https://github.com/opop999/daily_media_headlines/actions/workflows/docker.yml)

# Daily media headlines

This project extracts Czech news headlines from yesterday (all headlines and headlines related to the "election" key word). 

The extracted text is processed, tokenized and stop words are removed. Furthermore, the tokens are lemmatized and these lemma are then used for lexical sentiment analysis.

The end-results is a series of WordCloud visualizations available within a dashboard embedded in the GitHub site. 
