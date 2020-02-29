library(ggplot2)
#Look at data
names(economics)
View(economics)
a <- ggplot(economics, aes(date, unemploy))
names(seals)
View(seals)
b <- ggplot(seals, aes(x = long, y = lat))

#Expanding Limits?
a + geom_blank()
b + geom_curve(aes(yend = lat + 1, xend=long+1),curvature=1)
a + geom_path(lineend="butt", linejoin="round", linemitre=10)
?geom_path

#Two Variables
names(mpg)
View(mpg)
e <- ggplot(mpg, aes(cty, hwy))
e + geom_point()
e <- ggplot(mpg, aes(displ, hwy))
e + geom_point()
e + geom_text(aes(label = cty)) + ggtitle("Hey")

ggplot(mpg, aes(displ, hwy)) + geom_point()

#Discrete and Continuous
f <- ggplot(mpg, aes(class, hwy))
f + geom_col(fill="red") #Can Use hex as well as names
f + geom_col(fill="#8dd3c7") #Can Use hex as well as names
f + geom_boxplot()

m<-mpg
hist(mpg$hwy)
#Create dummy for good hwy mpg
m$good_hwy<-ifelse(m$hwy>=30, 1, 0)
table(m$good_hwy)

ggplot(m, aes(good_hwy)) + geom_bar(fill="pink") + geom_point(y=m$good_hwy)

#Maps
library(maps)
data <- data.frame(murder = USArrests$Murder,
                   state = tolower(rownames(USArrests)))
map <- map_data("state")
k <- ggplot(data, aes(fill = murder))
k + geom_map(aes(map_id = state, color="red"), map = map) +
  expand_limits(x = map$long, y = map$lat)
