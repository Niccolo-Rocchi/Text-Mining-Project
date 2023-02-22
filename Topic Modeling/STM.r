# Import libraries
library(stm)
library(tm)

# Read 'data' and 'stop_words' (used in LDA)
data <- read.csv("data_train_class_balanced_9-4.csv") # Output of 'Balance_data_class.ipynb'
stop_words = read.csv('stop_words.csv')$X0

# Convert some 'data' types
data$date <- stringr::str_extract(data$date, "[0-9]{4}$") |> as.integer()
data$date <- data$date - 2000
data$drugClass <- data$drugClass |> as.factor()

# Pre-process data table
processed <- textProcessor(documents = data$review, 
                            metadata = data,
                            ucp = TRUE,
                            customstopwords = stop_words)

# Prepare data for 'stm' algorithm
out <- prepDocuments(processed$documents, processed$vocab, processed$meta,
                        lower.thresh = ceiling(nrow(data)*0.05),
                        upper.thresh = ceiling(nrow(data)*0.55))

# Plot thresholds effects
# plotRemoved(processed$documents, lower.thresh = seq(1, 200, by = 100))


############# STM #############
num_tops <- c(3:8)
num_top <- 7

# STM model (try K = 0 for automatic selection of K)
model <- stm(documents = out$documents, vocab = out$vocab,
                K = num_top, 
                prevalence = ~ positiveness + s(date),
                content = ~ drugClass,
                data = out$meta,
                max.em.its = 200,
                init.type = "Spectral", 
                seed = 123)

# Search optimal K
model_searchK <- searchK(documents = out$documents, vocab = out$vocab,
                K = num_tops, 
                prevalence = ~ positiveness + s(date),
                content = ~ drugClass,
                data = out$meta,
                max.em.its = 200,
                init.type = "Spectral", 
                seed = 123)

# See found topics
labelTopics(model, c(1:num_top), n = 15)
