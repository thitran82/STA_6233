
#Insert Your Number Here
your_num<-22

set.seed(your_num)
if(your_num>21){
  feedback_nums<-sample(21:40, 2, replace=F)  
}else{
  feedback_nums<-sample(1:20, 2, replace=F)  
}

print(paste0("You Will Provide Feedback for Poster Position: ", feedback_nums[1], " and ", feedback_nums[2]))
