t<-read.csv("./Data/nic-cage.csv", stringsAsFactors = F)
str(t)
t$RottenTomatoes<-as.numeric(t$RottenTomatoes)

saveRDS(t, "./data/nic-cage.RDS")
