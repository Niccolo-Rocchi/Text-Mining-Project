# Import libraries
library(ggplot2)
library(scatterpie)

# Read data and clean it
data_tsne <- read.csv('data_tsne.csv')
data_tsne <- data_tsne[data_tsne$x_1_topic_probability>0.5,]
data_tsne$x_1_topic_probability <- data_tsne$x_1_topic_probability*2
topic_names <- c('1 topic', '2 topic','3 topic','4 topic','5 topic','6 topic','7 topic')
colnames(data_tsne) <- c(colnames(data_tsne)[c(1:5)],topic_names)

# High resolution tiff image
tiff("scatterpie.png", units="cm", width=12, height=9, res=500)

# Scatterpie chart
ggplot() + 
 geom_scatterpie(aes(x=x_tsne, y=y_tsne, group=row_id, r=x_1_topic_probability), data=data_tsne,
  cols=topic_names, color=NA, alpha=0.5) + 
 coord_equal() +
 geom_label() + 
 ggtitle("LDA t-SNE") + 
 xlab("") + ylab("") + labs(subtitle="t-SNE of LDA model, colored and sized by topic probability") +
 scale_fill_manual(values=rainbow(7)) + 
 theme_minimal() + 
 theme(text = element_text(color="gray25", size=7),
 legend.position = ,
 panel.background = element_rect(fill = "#ebebeb", colour = "#ebebeb"), 
 plot.background = element_rect(fill = "#ebebeb"),
 panel.grid.major = element_line(colour = "#bdbdbd"),
 panel.grid.minor = element_line(colour = "#bdbdbd"),
 axis.text = element_text(color="gray25"))

# Shut down graphics device
dev.off()


d <- data.frame(x=rnorm(5), y=rnorm(5))
d$A <- abs(rnorm(5, sd=1))
d$B <- abs(rnorm(5, sd=2))
d$C <- abs(rnorm(5, sd=3))
ggplot() + geom_scatterpie(aes(x=x, y=y), data=d, cols=c("A", "B", "C")) + coord_fixed()
