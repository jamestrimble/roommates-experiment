library(dplyr)
library(ggplot2)

complete_graphs <- read.table("../mertens/roommates.dat", col.names=c("n", "p_n", "sigma"))
complete_graphs <- complete_graphs[complete_graphs$n > 1000 & complete_graphs$n <= 49151, ]
complete_graphs$p <- 1.0
complete_graphs$seed <- -1
complete_graphs$iters <- -1
complete_graphs$n_edges <- -1
complete_graphs <- complete_graphs[, c("n", "p", "iters", "p_n", "seed", "n_edges")]
names(complete_graphs) <- c("n", "p", "iters", "prop_stable", "seed", "n_edges")

run_name <- "sri"

dirname <- paste0("../", run_name, "/summary/")
d <- read.delim(paste0(dirname, "all.txt"), header=FALSE, col.names=c(
  "n", "p", "iters", "prop_stable", "seed", "n_edges"))
d <- rbind(d, complete_graphs)
d$n_times_p <- (d$n - 1) * d$p # Expected length of preference lists

d <- d[d$n > 33 & d$n <= 49151, ]
d <- d[ifelse(d$n %% 2, (d$n-1)%%5  & (d$n-1)%%7 , d$n%%5  & d$n%%7 ), ]

d$n_group = paste0("n = ", as.integer(d$n/2) * 2, ", ", as.integer(d$n/2) * 2 + 1)
d$n_group = factor(d$n_group, levels=unique(d$n_group))
d$is_odd = d$n %% 2 == 1

label_positions = d %>%
  group_by(n) %>%
  filter(seed != -1) %>%
  arrange(n_times_p) %>%
  slice(n())

ggplot(d, aes(x=n_times_p, y=prop_stable, colour=is_odd, label=n)) +
  geom_point() +
  geom_line() +
  facet_wrap(~n_group, ncol=5) +
  theme_bw() +
  scale_x_log10(breaks=c(1, 10, 100, 1000, 10000), limits=c(1,40000)) +
  geom_text(data=label_positions, nudge_x=.1+nchar(as.character(label_positions$n))/12,
            nudge_y=.06, colour="black") +
  scale_colour_discrete(guide=FALSE) +
  ylab("Proportion of instances that admit a stable solution") +
  xlab(expression(paste("Average degree (", n * p, ")")))

fname <- paste0(run_name, "-1-proportion_of_instances_with_stable_solution.pdf")
ggsave(fname, width=13, height=8)


############### Check number of edges ################

# Remove Mertens' results
d <- d %>% filter(seed != -1)
d$expected_edges <- d$iters * d$n * (d$n-1) * d$p / 2.

# Actual number of edges divided by expected number
d$edge_ratio <- d$n_edges / d$expected_edges
ggplot(d, aes(x=n_times_p, y=edge_ratio, colour=is_odd, label=n)) +
  geom_point() +
  geom_line() +
  facet_wrap(~n_group, ncol=5) +
  theme_bw() +
  scale_x_log10(breaks=c(1, 10, 100, 1000), limits=c(1,40000)) +
  scale_colour_discrete(guide=FALSE) +
  xlab(expression(paste("Expected preference list length, ", (n-1) * p)))

############### Average number of stable matchings ################

d <- read.delim(paste0(dirname, "counts.txt"), header=FALSE, col.names=c("n", "n_times_p", "stable_count", "count"), sep=" ")

d <- d[d$n > 23, ]

d_summary <- d %>%
  group_by(n, n_times_p) %>%
  summarise(mean_stable_count=weighted.mean(stable_count, count))

d_summary$n_group = paste(as.integer(d_summary$n/2) * 2, as.integer(d_summary$n/2) * 2 + 1, sep="/")
d_summary$n_group = factor(d_summary$n_group, levels=unique(d_summary$n_group))
d_summary$is_odd = d_summary$n %% 2 == 1

ggplot(d_summary, aes(x=n_times_p, y=mean_stable_count, colour=is_odd)) +
  geom_point() +
  geom_line() +
  facet_wrap(~n_group) +
  theme_bw() +
  scale_x_log10(breaks=c(1, 10, 100, 1000), limits=c(1,1000)) +
  xlab("Expected preference list length, (n-1) * p")

fname <- paste0(run_name, "-2-mean_number_of_stable_matchings.pdf")
ggsave(fname, width=18, height=10)


############### Max number of stable matchings ################

d <- read.delim(paste0(dirname, "counts.txt"), header=FALSE, col.names=c("n", "n_times_p", "stable_count", "count"), sep=" ")

d <- d[d$n > 23, ]

d_summary <- d %>%
  group_by(n, n_times_p) %>%
  summarise(max_stable_count=max(stable_count))

d_summary$n_group = paste(as.integer(d_summary$n/2) * 2, as.integer(d_summary$n/2) * 2 + 1, sep="/")
d_summary$n_group = factor(d_summary$n_group, levels=unique(d_summary$n_group))
d_summary$is_odd = d_summary$n %% 2 == 1

ggplot(d_summary, aes(x=n_times_p, y=max_stable_count, colour=is_odd)) +
  geom_point() +
  geom_line() +
  facet_wrap(~n_group) +
  theme_bw() +
  scale_x_log10(breaks=c(1, 10, 100, 1000), limits=c(1,1000)) +
  scale_y_log10() +
  xlab("Expected preference list length, (n-1) * p")

fname <- paste0(run_name, "-3-max_number_of_stable_matchings.pdf")
ggsave(fname, width=18, height=10)


############### Average of (size of stable matching divided by n) ################

d <- read.delim(paste0(dirname, "sizes.txt"), header=FALSE, col.names=c("n", "n_times_p", "matching_size", "count"), sep=" ")

d <- d[d$n > 23, ]

d$matching_size_over_n <- d$matching_size / d$n

d_summary <- d %>%
  group_by(n, n_times_p) %>%
  summarise(mean_matching_size_over_n=weighted.mean(matching_size_over_n, count))

d_summary$n_group = paste(as.integer(d_summary$n/2) * 2, as.integer(d_summary$n/2) * 2 + 1, sep="/")
d_summary$n_group = factor(d_summary$n_group, levels=unique(d_summary$n_group))
d_summary$is_odd = d_summary$n %% 2 == 1

ggplot(d_summary, aes(x=n_times_p, y=mean_matching_size_over_n, colour=is_odd)) +
  geom_point() +
  geom_line() +
  facet_wrap(~n_group) +
  theme_bw() +
  scale_x_log10(breaks=c(1, 10, 100, 1000), limits=c(1,1000)) +
  xlab("Expected preference list length, (n-1) * p")

fname <- paste0(run_name, "-4-mean_of_size_of_stable_matching_over_n.pdf")
ggsave(fname, width=18, height=10)


