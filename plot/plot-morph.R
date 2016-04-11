library(ggplot2)

getwd()

da <- read.delim("../morph-a/summary/all.txt", col.names = c(
  "n", "p", "niter", "prob", "seed", "edges"
))
db <- read.delim("../morph-b/summary/all.txt", col.names = c(
  "n", "p", "niter", "prob", "seed", "edges"
))

da$model <- "a"

db$model <- "b"

d <- rbind(da, db)

d100 <- d[d$n==100,]
ggplot(d100, aes(x=p, y=prob, colour=model)) +
  geom_line() +
  theme_bw()
ggsave("morph100.pdf")

d_model_a <- d[d$model=="a",]
ggplot(d_model_a, aes(x=p, y=prob, colour=factor(n))) +
  geom_line() +
  theme_bw()
ggsave("morph-a-b.pdf")
