#If you are getting errors see: https://stackoverflow.com/questions/45395849/cant-execute-rsdriver-connection-refused
#shell('docker container ls -a')  #Shows what is open. 
#If you are getting an error about execution failed 125 then be sure to close previous containers
#shell('docker rm -f <container name>) #Kills prevous connection
#If you get Selenium unable to create session from error
  #Update Webbrowser
  #Update webdriver example: webdriver-manager update --chromedriver


library(RSelenium)
library(seleniumPipes)
library(dplyr)
library(httr)

#Locate the browswer you will use. Here we use Chrome
#browser = c("chrome", "firefox", "phantomjs", "internet explorer")
  #shell('docker-machine ip default')
  #shell('curl http://192.168.99.100:4445')
  #shell('docker pull atsnngs/phantomjs')
  shell('docker pull selenium/standalone-chrome') 
  shell('docker run -d -p 4445:4444 selenium/standalone-chrome')
  remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445, browserName = "chrome")

#Open Driver
  remDr$open()

#Go to website - Here we look at ToScrape.com
  #driver$navigate("https://www.southwest.com/")
  remDr$navigate("http://toscrape.com/")
  remDr$navigate("http:/r-project.org")
  
  #driver$navigate("http://google.com/ncr")
  #elements<-driver %>% findElements("name", "q")
  #webElem <- remDr %>% findElement("name", "q") %>%
    
  #Find Elements in the website
  elements <- remDr$findElements("a",using = "css")
  # get the navigation div
  navElem <- elements %>% findElement("css", "div[role='navigation']")
  # find all the links in this div
  navLinks <- elements %>% findElementsFromElement("css", "a")
  nLinks <- sapply(elements, function(x) x %>% getElementText)
  
  # click the first link 
  elements[[1]]$clickElement()
  driver$getTitle()
  
#Find the element
  elements <- driver$findElements("a",using = "css")
  sessionInfo()
  
#Close the Driver
  remDr$close()
  
#Close Server
  r$server$stop()
  
