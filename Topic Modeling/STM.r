# Import libraries
library(stm)
library(stminsights)
library(quanteda)
library(wordcloud)

# Read 'data0' (output of 'Balance_data_class_9-4.ipynb')
data0 <- read.csv("data_train_class_balanced_9-4.csv") 

# Convert types
data0$date <- stringr::str_extract(data0$date, "[0-9]{4}$") |> as.numeric()
data0$date <- data0$date - 2000 
data0$drugClass <- data0$drugClass |> as.factor()
data0$positiveness <- data0$positiveness |> as.numeric()

# Prepare data for 'stm' algorithm
data <- corpus(data0, text_field = 'review')
docvars(data)$text <- as.character(data)
data <- dfm(data, stem = TRUE, remove = stopwords('english'),
           remove_punct = TRUE) %>% dfm_trim(min_count = 2)
out <- convert(data, to = 'stm')


# STM model training (try K = 0 for automatic selection of K)
model_stm <- stm(documents = out$documents, vocab = out$vocab,
                K = 7, 
                prevalence = ~ positiveness + s(date),
                content = ~ drugClass,
                data = out$meta,
                max.em.its = 100,
                init.type = "Spectral", 
                seed = 123,
                emtol = 5e-5)

# See topics
labelTopics(model_stm, c(1:7), n = 15, frexweight = 0.6)

# Compute metrics
exclusivity(model_stm, M = 20, frexw = 0.6) # it doeasn't work with 'context' variables
mean(semanticCoherence(model_stm2, out$documents, M = 20))


# Estimate effects of model
model_effects <- estimateEffect(1:7 ~ positiveness + s(date), model_stm,
                            meta = out$meta, prior = 1e-5)


# Prepare the image for shiny app
save.image('stm.RData')
load("/home/niccolo/Documenti/Università_magistrale/Text Mining/Project/Topic-Modeling/STM-R/stm.RData")


# Run shiny app
run_stminsights()



