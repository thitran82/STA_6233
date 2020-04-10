t<-read.csv("./Data/nic-cage.csv", stringsAsFactors = F)
str(t)
t$RottenTomatoes<-as.numeric(t$RottenTomatoes)

save(t, file="./Data/nic-cage.RData")
load("./Data/nic-cage.RData")
