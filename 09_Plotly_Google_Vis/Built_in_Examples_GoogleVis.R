data(Fruits)
M <- gvisMotionChart(Fruits, idvar="Fruit", timevar="Date")
plot(M)

df=data.frame(country=c("US", "GB", "BR"), 
              val1=c(10,13,14), 
              val2=c(23,12,32))
Line <- gvisLineChart(df)
plot(Line)

Bar <- gvisBarChart(df)
plot(Bar)
