#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/cleaned_data.parquet")

### Model data ####
model1 <- lm(pct ~ sample_size + pollscore + numeric_grade + state, 
                   data = analysis_data)

model2 <- lm(pct ~ sample_size + pollscore + numeric_grade + recency_weight + 
                   state, data = analysis_data)

model3 <- lm(pct ~ candidate_name + sample_size + pollscore + numeric_grade + 
                   recency_weight + state,
                   data = analysis_data)

model4 <- lm(pct ~ candidate_name * state + recency_weight + sample_size + 
                   pollscore + numeric_grade,
                   data = analysis_data)

model5 <- lm(pct ~ candidate_name * recency_weight * state + sample_size + 
                   pollscore + numeric_grade,
                   data = analysis_data)

model6 <- lm(pct ~ candidate_name * recency_weight * state + sample_size + 
               pollster,
             data = analysis_data)

#### Save model ####
saveRDS(model1, file = "models/model1.rds")
saveRDS(model2, file = "models/model2.rds")
saveRDS(model3, file = "models/model3.rds")
saveRDS(model4, file = "models/model4.rds")
saveRDS(model5, file = "models/model5.rds")
saveRDS(model6, file = "models/model6.rds")


