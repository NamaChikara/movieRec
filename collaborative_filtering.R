library(readr)
library(caret)

# links: map movie ids to imbd pages
# movies: movieId | title | genres
#   movieId [Int], title "Name (YYYY)", "Genre1|Genre2|...|GenreN"
# ratings: userId | movieId | rating | timestamp (epoch seconds)
# gas: userId | movieId | tag | timestamp (epoch seconds)
#   tag is a string with a short comment about the movie

movies <- read_csv("Data/ml-latest-small/movies.csv")

ratings <- read_csv("Data/ml-latest-small/ratings.csv") %>%
  select(userId, movieId, rating) %>%
  spread(movieId, rating) 

ratings_m <- ratings %>%
  select(-userId) %>%
  as.matrix()

rownames(ratings_m) <- ratings$userId
colnames(ratings_m) <- names(ratings)[-1]

# column 1 contains the userIds
users <- unique(rownames(ratings_m))

train_users <- sample(users, size = floor(0.8 * length(users)))

train_ratings <- ratings_m[rownames(ratings_m) %in% train_users, ]
test_ratings <- ratings_m[!(rownames(ratings_m) %in% train_users), ]

item_sim_m <- cor(train_ratings, method = "pearson", use = "pairwise.complete.obs")
user_sim_m <- cor(t(train_ratings), method = "pearson", use = "pairwise.complete.obs")






