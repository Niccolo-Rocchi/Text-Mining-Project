# Drug reviews: NLP approaches to investigate patients belief
### Rocchi Niccolò, Gravina Greta.
###### *Università degli Studi di Milano-Bicocca, M.Sc. Data Science. Text Mining & Search course final project*

*... This repo is a work in progress...*


## How to use:

Data is available at [this link] (https://archive.ics.uci.edu/ml/datasets/Drug+Review+Dataset+%28Drugs.com%29). You will find a training set named *drugsComTrain_raw.tsv* and a test set named *drugsComTest_raw.tsv*.

Please notice you have to modify any row in the code below containing *our* data path with *your* data path, either in Drive or locally. If you missed some Python or R libraries, please install them through **pip** (Python) or **install.packages** (R).

### Topic Modelling

We trained two models: LDA and STM. For topic modelling we only use training data.
1. **Data Preparation** 

The reference notebook is ***./Topic Modeling/Balance_data_class.ipynb***. Data (*drugsComTrain_raw.tsv*) is balanced and cleansed before applying models. Notebook output will be the input of ALL further models, and it's named *data_train_class_balanced_9-4.csv*.

2. **LDA**

The reference notebook is ***./Topic Modeling/LDA.ipynb***. Here we apply an LDA model from gensim library. After having loaded data, it is then pre-processed, the model is trained and results are visualized. 

Please notice that:

- pyLDAvis intertopic distance map doesn't appear on GitHub notebook rendering

- "t-SNE(2)" subsection, among visualizations section, is only used to prepare the two t-SNE components and to save them locally, but not to visualize them. Their visualization is made afterwards in ***./Topic Modeling/etc/LDA_t-SNE.r*** file, using R software and ggplot2 library. Indeed, in the same folder we already provide *data_tsne.csv*, the right input for that R file, so you're not asked to run "t-SNE(2)" subsection at all.

3. **STM** 

The reference file is ***./Topic Modeling/STM.r***. This R file provides pre-processing of data, training of a STM model and the instructions to run a shiny app. This app provides STM model visualizations. After estimating your model and the effects, just save an R image of your workspace with:

```
save.image('stm.RData')
```

Then you can run the shiny app by running:

```
library(stminsights)
run_stminsights()
```
The app will listen locally on some port. Please follow the output of previous commands to know the right URL the app is listened on.

Finally, you have just to load your recently saved R workspace (*stm.rData*) in the app, choose the model and effects you want to analize (one in our case) and that's it: you can explore plots and information about your STM model.


### Sentiment analysis

*...work in progress, stay tuned!*

