# Import libraries
library(stm)
library(stminsights)
library(quanteda)

# Read 'data' and 'stop_words' (used in LDA)
data0 <- read.csv("data_train_class_balanced_9-4.csv") # Output of 'Balance_data_class_9-4.ipynb'
# stop_words = read.csv('stop_words.csv')$X0

# Convert some 'data' types
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


############# STM #############

num_top <- 7 # it is optimal

# STM model 1 (try K = 0 for automatic selection of K)
model_stm1 <- stm(documents = out$documents, vocab = out$vocab,
                K = num_top, 
                prevalence = ~ positiveness + s(date),
                #content = ~ drugClass,
                data = out$meta,
                max.em.its = 100,
                init.type = "Spectral", 
                seed = 123,
                emtol = 1e-2) # put 1e-5 for the final run

# See topics
labelTopics(model_stm1, c(1:7), n = 15, frexweight = 0.6)

# Estimate effects
model_effects_1 <- estimateEffect(1:7 ~ positiveness + s(date), model_stm1,
                            meta = out$meta, prior = 1e-5)


# STM model 2 (try K = 0 for automatic selection of K)
model_stm2 <- stm(documents = out$documents, vocab = out$vocab,
                K = num_top, 
                prevalence = ~ positiveness + s(date),
                content = ~ drugClass,
                data = out$meta,
                max.em.its = 100,
                init.type = "Spectral", 
                seed = 123,
                emtol = 1e-2) # put 1e-5 for the final run

# See topics
labelTopics(model_stm2, c(1:7), n = 15, frexweight = 0.6)

# Estimate effects
model_effects_2 <- estimateEffect(1:7 ~ positiveness + s(date), model_stm2,
                            meta = out$meta, prior = 1e-5)

# Prepare the image for shiny app
save.image('stm.RData')

# Run shiny app
run_stminsights()
