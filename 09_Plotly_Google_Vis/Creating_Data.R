library(googleVis)
library(tidyr)
library(gridExtra)
library(dplyr)
library(scales)

#Bring in Data
all_cohorts<-read.csv("https://raw.githubusercontent.com/mattdemography/STA_6233/master/Data/all_cohorts.csv")
count<-read.csv("https://raw.githubusercontent.com/mattdemography/STA_6233/master/Data/cohort_counts.csv")

#Find All Possible Transitions

caps<-names(all_cohorts[1:13])
caps_l<-names(all_cohorts[2:14]) #Lag Previous Variable
j<-as.data.frame(table(all_cohorts$trans))

#Label these transitions
  #Create list to change to
  cap_num<-c("13", "15", "19", "21", "25", "31", "33", "37", "39", "42", "46", "47", "48", "49", "51", "73", "3", "4", "5", "6", "7")
  cap_name<-c("Non-Exempt ->", "Part-Time ->",  "Ex-Employee ->", "Unknown ->",  "Temp-Employee ->", "Temp-Employee ->", "Intern ->", "Intern ->", "Unknown ->", 
              "Deceased-Employee ->", "Ex-Employee ->", "Outsourced ->", "Temp ->", "Ex-Temp ->", "Business-Partner ->", "Deceased-Temp ->", 
              "Full-Time ->", "Unknown ->", "Ex-Intern ->", "Family ->", "Ex-Employee ->")
#Create Loop
  j$name<-j$Var1 #Create Copy
  for(s in 1:length(cap_num)){
    j$name<-gsub(cap_num[s], cap_name[s], j$name) #Use Regular Expression to take what is in cap_num and put cap_name instead
  }
  #Eliminate all same-state non-transition months
  j$unique_name<-vapply(strsplit(j$name, " "), function(x) paste(unique(x), collapse = " "), character(1L)) 
  
#Get All Unique Transitions overall and how often it occurs
  t<-aggregate(j$Freq, by=list(j$unique_name), FUN=sum)
  t<-plyr::rename(t, c("Group.1"="Transition Type", "x"="Frequency"))
  t<-t[order(-t$Frequency),]

#Add a total Column to cnts_trans
for(i in 1:12){
  eval(parse(text=paste0('count$Month_', i,'<-as.numeric(count$Month_', i,')')))
}
count$Total<-rowSums(count[2:13])

#Create a Survival Format
c<-cnts_trans$Total
for(i in 1:1){
  eval(parse(text=paste0('cnts_trans$ms_', i-1, '<-c')))
  for(k in 1:12){
    eval(parse(text=paste0('cnts_trans$ms_', k, '<-(cnts_trans$ms_', k-1, ' - cnts_trans$Month_', k, ')')))
  }
}
for(k in 1:12){
  eval(parse(text=paste0('cnts_trans$Percent_Left_in_Month_', k,'<-round(as.numeric(cnts_trans$Month_', k,'/cnts_trans$Total)*100,2)')))
}
for(k in 1:12){
  eval(parse(text=paste0('cnts_trans$Percent_Remain_in_Month_', k,'<-round(as.numeric(cnts_trans$ms_', k-1,'/cnts_trans$Total)*100,2)')))
}

#Now Make this data long
tout<- cnts_trans[1:14] %>% gather(Month_Code, No_Longer_Fiance, Month_1:Month_12)
tout_p<- cnts_trans[28:39] %>% gather(Month_Code, Percent_No_Longer_Fiance, Percent_Left_in_Month_1:Percent_Left_in_Month_12)
survive<-cnts_trans[13:26] %>% gather(time_survive, Still_Fiance, ms_0:ms_11)
survive_p<-cnts_trans[40:51] %>% gather(time_survive, Percent_Still_Fiance, Percent_Remain_in_Month_1:Percent_Remain_in_Month_12)
cnts_trans_l<-cbind(tout[c(1:2,4)], tout_p[2], survive[4], survive_p[2])
cnts_trans_l$Month<-with(cnts_trans_l, ave(cnts_trans_l$cohort, cnts_trans_l$cohort, FUN=seq_along)) %>% as.numeric()
cnts_trans_l$Month<-cnts_trans_l$Month + 100

#Create Visualizations  
myStateSettings_time<-'
  {"yZoomedIn":false,"time":"101","sizeOption":"_UNISIZE","orderedByY":false,"yZoomedDataMax":4000,"nonSelectedAlpha":0.4,"orderedByX":true,"iconKeySettings":[],
  "uniColorForNonSelected":false,"yLambda":1,"yAxisOption":"3","xLambda":1,"showTrails":false,"xZoomedDataMax":12,"dimensions":{"iconDimensions":["dim0"]},
  "yZoomedDataMin":0,"iconType":"VBAR","colorOption":"_UNIQUE_COLOR", "duration":{"multiplier":1,"timeUnit":"Y"},"playDuration":15088.88888888889,
  "xAxisOption":"_ALPHABETICAL","xZoomedIn":false,"xZoomedDataMin":0}
  '
m_reg<-gvisMotionChart(cnts_trans_l[1:132,c(1:4,7)], idvar="cohort", timevar = "Month")
m_time<-gvisMotionChart(cnts_trans_l[,c(1:2, 5:7)], idvar="cohort", timevar = "Month", options=list(state=myStateSettings_time))
plot(m_reg)  
plot(m_time)

#Reorder Factor Levels
cnts_trans$fl<-ifelse(cnts_trans$cohort=="Jan17", 1, ifelse(cnts_trans$cohort=="Feb17", 2, ifelse(cnts_trans$cohort=="March17", 3,
                                                                                                  ifelse(cnts_trans$cohort=="Apr17", 4, ifelse(cnts_trans$cohort=="May17", 5, ifelse(cnts_trans$cohort=="June17", 6, ifelse(cnts_trans$cohort=="July17", 7,
                                                                                                                                                                                                                            ifelse(cnts_trans$cohort=="Aug17", 8, ifelse(cnts_trans$cohort=="Sep17", 9, ifelse(cnts_trans$cohort=="Oct17", 10, ifelse(cnts_trans$cohort=="Nov17", 11,
                                                                                                                                                                                                                                                                                                                                                      ifelse(cnts_trans$cohort=="Dec17", 12, NA))))))))))))
cnts_trans$cohort<-factor(cnts_trans$cohort, levels=cnts_trans$cohort[order(cnts_trans$fl)])

cnts_trans_l$fl<-ifelse(cnts_trans_l$cohort=="Jan17", 1, ifelse(cnts_trans_l$cohort=="Feb17", 2, ifelse(cnts_trans_l$cohort=="March17", 3,
                                                                                                        ifelse(cnts_trans_l$cohort=="Apr17", 4, ifelse(cnts_trans_l$cohort=="May17", 5, ifelse(cnts_trans_l$cohort=="June17", 6, ifelse(cnts_trans_l$cohort=="July17", 7,
                                                                                                                                                                                                                                        ifelse(cnts_trans_l$cohort=="Aug17", 8, ifelse(cnts_trans_l$cohort=="Sep17", 9, ifelse(cnts_trans_l$cohort=="Oct17", 10, ifelse(cnts_trans_l$cohort=="Nov17", 11,
                                                                                                                                                                                                                                                                                                                                                                        ifelse(cnts_trans_l$cohort=="Dec17", 12, NA))))))))))))
cnts_trans_l$cohort<-factor(cnts_trans_l$cohort, levels=cnts_trans_l$cohort[order(cnts_trans_l$fl)])

#Grab Only the 6th month
six<-cnts_trans_l[61:72,c(1,6)]
max<-subset(six, six$Percent_Still_Fiance==max(six$Percent_Still_Fiance))
min<-subset(six, six$Percent_Still_Fiance==min(six$Percent_Still_Fiance))

line_t<-ggplot(data=cnts_trans_l, aes(x=cnts_trans_l$Month, y=cnts_trans_l$Percent_Still_Fiance, group=cnts_trans_l$cohort)) + xlab("Month Number") +
  ylab("Percent Still Fiance") +  geom_line(aes(color=cnts_trans_l$cohort)) + geom_vline(xintercept = 106, linetype="dashed") + theme_light() + 
  scale_color_discrete(name="Legend") + scale_x_continuous(breaks=seq(101, 112,1)) + ggtitle("Percent Fiancés Remaining After Each Period by Cohort")
plot(line_t)

all_sum1<-mean(cnts_trans$Total)
bar1<-ggplot(data=cnts_trans, aes(cnts_trans$cohort, fill=cnts_trans$cohort)) + geom_bar(aes(weight=cnts_trans$Total)) +  
  scale_fill_manual(values=c("Apr17"="lightcyan3", "Aug17"="lightcyan4", "Dec17"="lightcyan3", "Feb17"="lightcyan4", "Jan17"="lightcyan3",
                             "July17"="lightcyan4", "June17"="lightcyan3", "March17"="lightcyan4", "May17"="lightcyan3", "Nov17"="lightcyan4",
                             "Oct17"="lightcyan3", "Sep17"="lightcyan4"), guide=F) + xlab("Cohort") + ylab("Total Fiancés") + theme_light() + 
  scale_y_continuous(limits=c(0, 3500), oob=rescale_none) + geom_hline(yintercept = all_sum1, linetype="dashed", colour="indianred3") + 
  geom_text(aes(x=cnts_trans$cohort, y=cnts_trans$Total, label=cnts_trans$Total), vjust=-1) + ggtitle("Total Number of Fiancés as Operators by Cohort") 
plot(bar1)

#Create new dataset with just the summary statistics
sum_stats<-all_cohorts[,20:21] %>% group_by(cohort) %>% summarise_each(funs(mean(., na.rm = T), sd(., na.rm=T)))
sum_stats$fl<-ifelse(sum_stats$cohort=="Jan17", 1, ifelse(sum_stats$cohort=="Feb17", 2, ifelse(sum_stats$cohort=="March17", 3,
                                                                                               ifelse(sum_stats$cohort=="Apr17", 4, ifelse(sum_stats$cohort=="May17", 5, ifelse(sum_stats$cohort=="June17", 6, ifelse(sum_stats$cohort=="July17", 7,
                                                                                                                                                                                                                      ifelse(sum_stats$cohort=="Aug17", 8, ifelse(sum_stats$cohort=="Sep17", 9, ifelse(sum_stats$cohort=="Oct17", 10, ifelse(sum_stats$cohort=="Nov17", 11,
                                                                                                                                                                                                                                                                                                                                             ifelse(sum_stats$cohort=="Dec17", 12, NA))))))))))))
sum_stats$cohort<-factor(sum_stats$cohort, levels=sum_stats$cohort[order(sum_stats$fl)])

all_sum2<-mean(all_cohorts$count)
bar2<-ggplot(data=sum_stats, aes(sum_stats$cohort, fill=sum_stats$cohort)) + geom_bar(aes(weight=sum_stats$mean)) +  
  scale_fill_manual(values=c("Apr17"="lightcyan3", "Aug17"="lightcyan4", "Dec17"="lightcyan3", "Feb17"="lightcyan4", "Jan17"="lightcyan3",
                             "July17"="lightcyan4", "June17"="lightcyan3", "March17"="lightcyan4", "May17"="lightcyan3", "Nov17"="lightcyan4",
                             "Oct17"="lightcyan3", "Sep17"="lightcyan4"), guide=F) + xlab("Cohort") + ylab("Average Months") + theme_light() + 
  scale_y_continuous(limits=c(8.25,9.25), oob=rescale_none) + geom_hline(yintercept = all_sum2, linetype="dashed", colour="indianred3") + 
  geom_text(aes(x=sum_stats$cohort, y=sum_stats$mean, label=round(sum_stats$mean,2)), vjust=-1) + ggtitle("Average Months Fiancés Remain by Cohort") 
plot(bar2)

myTheme<-ttheme_default(
  core=list(fg_params=list(hjust=1, x=1),
            bg_params=list(fill=c("cornflowerblue", "gray92"))),
  colhead=list(fg_params=list(col="white"),
               bg_params=list(fill="mediumpurple"))
)

trans_table<-tableGrob(t[1:15,], rows=NULL, theme=myTheme, vp=NULL)
plot(trans_table)

