[![News API extraction](https://github.com/opop999/daily_media_headlines/actions/workflows/docker.yml/badge.svg)](https://github.com/opop999/daily_media_headlines/actions/workflows/docker.yml)

# Daily media headlines

## GOAL: One can spend the entire morning going through the news coverage and headlines from different media outlets. What if we could automatize this process and get key insights from the daily headlines in the form of a visualization?

This project extracts Czech news headlines from yesterday (all headlines and headlines related to the "election" key word). 

The extracted text is processed, tokenized and stop words are removed. Furthermore, the tokens are lemmatized and these lemma are then used for lexical sentiment analysis.

The end-results is a series of WordCloud visualizations available within a dashboard embedded in the GitHub site. 

As a bonus, we also get a graph with temperature/humidity forecast for Prague to compare whether there is a link between weather and media discourse. :smirk:
