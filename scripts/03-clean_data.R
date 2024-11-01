#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
library(lubridate)

#### Clean data ####
# read the dataset
raw_data <- read_csv("data/01-raw_data/president_polls.csv")

# set the election day
election_day <- as.Date("2024-11-05")

# create a new column showing the weight as time approach to election day
cleaned_data <- raw_data %>% distinct() %>%
  mutate(end_date = mdy(end_date), start_date = mdy(start_date)) %>%
  mutate(days_until_election_start = as.numeric(election_day - start_date),
         days_until_election_end = as.numeric(election_day - end_date),
         weight_start = 1 - (days_until_election_start / max(days_until_election_start)),
         weight_end = 1 - (days_until_election_end / max(days_until_election_end)),
         recency_weight = (weight_start + weight_end) / 2
  )

# clean the dataset with select the columns, choose over 2 numeric grade,
#set na state to national, set Biden to Harris and drop nas
cleaned_data <- cleaned_data %>% select(
  poll_id,
  pollster,
  numeric_grade,
  pollscore,
  state,
  start_date,
  end_date,
  sample_size,
  candidate_name,
  pct,
  recency_weight) %>% 
  filter(numeric_grade >= 2.0) %>% 
  mutate(state = ifelse(is.na(state),"National",state)) %>%
  mutate(candidate_name = ifelse(
    candidate_name == "Joe Biden", "Kamala Harris", candidate_name)) %>%
  drop_na()

# select only Trump and Harris and create new column showing the number of votes
cleaned_data <- cleaned_data %>% 
  filter(candidate_name %in% c("Donald Trump" ,"Kamala Harris")) %>%
  mutate(num_vote = round((pct / 100) * sample_size, 0))

# reorder data
cleaned_data_1 <- cleaned_data %>% 
  select(recency_weight,
         pct, pollster, state, start_date, end_date, pollscore,numeric_grade,sample_size)
  
#### Save data ####
write.csv(cleaned_data_1, "data/02-analysis_data/analysis_data_1.csv")
write_parquet(cleaned_data_1, "data/02-analysis_data/analysis_data_1.parquet")

