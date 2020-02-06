#### For Loops ####
  #Let's say I want to do an action like print a phrase.
  print("Number 1")
  
  #If I want to print to phrases in sequence I could write two print statements
  print("Number 1")
  print("Number 2")
  
  #OR.... Loop through a list to print 1 through 10 phrases in order.
  for(i in 1:10){
    print("Number")
  }
  
  #Why didn't an acutal number print?
  #How can we change this?
  
  #We can also use an object instead of counting to 10
  nums<-1:10
  #for(i in nums)

#Now let's try loops with real data.
dat<-read.csv("https://raw.githubusercontent.com/mattdemography/STA_6233/master/Data/SampleMattData.csv", stringsAsFactors = F)

#Checking the Names of the variables
  names(dat)
  head(dat)
  str(dat)
  
  #What if I want to change the names of the variables to be var_1, var_2, etc. for all variables in the data set? - Do so with a loop
  
  
  #Changing to One-Word Column names that are more useful
  new_names<-c("District", "Risks", "Recommend","WorkValued", "Tools", "Vision", "Retention", "Recognized",
               "LiveValues", "Information", "Growth", "Role")
  names(dat)<-new_names
  
  #Check that Names have been transformed
  names(dat)
  
  #Sort Data by District Name
  dat<-dat[order(dat$District),]
  
  #See which variables have likert scale because I want to change these to numbers
  head(dat)
  
  #Now see what scale looks like
  table(dat$Risks)
  
  #Create Loop to convert to numeric values with 0 being strongly disagree and strongly agree being 5
  #First grab all the names of variables that will be transformed
  vars<-names(dat[2:11])
  
  for(i in 1:length(vars)){
    eval(parse(text=paste0('dat$', vars[i], '<- ifelse(dat$', vars[i], '=="Strongly Disagree", 0, 
              ifelse(dat$', vars[i], '=="Disagree", 1, 
              ifelse(dat$', vars[i], '=="Somewhat Disagree", 2, 
              ifelse(dat$', vars[i], '=="Somewhat Agree", 3,
              ifelse(dat$', vars[i], '=="Agree", 4, 
              ifelse(dat$', vars[i], '=="Strongly Agree", 5, NA))))))')))
  }
  
  #Before we run the function let's break down the elements of it first.
  
  #Now I want to print out a table for each of the variables I just changed. How would I do this in a loop?
  
#### While Loops ####
  #What of instead of a for loop, I want to loop while a condition is true?
  #I want to print while a calculation is below 10,000
  i=1
  while(i<10000){
    print("Still Below 10,000")
    i=i+(i*i)
  }
  
  #How many times did the while loop print? Is this correct?
  
  #What if I wanted to add an iteration number and the value of i to the while loop above?
  
#### Functions ####
  
  testfun<-function (connection, table, joinvar, rdata)
  {
    p<-data.frame(rdata[,1])
    p2<-NULL
    j=1
    while(j<nrow(rdata)){
      p1<-paste0("t.", joinvar, "=", p[j,], " OR ")
      p2 <-paste0(p2, p1)
      j=j+1
    }
    rm(p1)
    p3<-paste0("(", p2, "t.", joinvar, "=", p[nrow(rdata),], ")")
  }
  }

