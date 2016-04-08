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

ggplot(d, aes(x=p, y=prob, colour=model)) +
  geom_line()
