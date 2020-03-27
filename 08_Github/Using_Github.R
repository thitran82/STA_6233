#Using Github with R Studio.
#First thing you should have a Github account. If you do not, then navigate to github.com and create one.

#Github has Repositories that allow you to store and create code along with other files like pdfs, powerpoints, word documents, etc.
#The power of using Github and R is that you can easily store code by saving it to the cloud or pull projects you or others have and run them quickly.
#Let us work through a few steps to get this to work.

#First some basics. Pull commands allow us to pull down code from a public Git repository. The easiest way to do this is create an R Project
#and make it link to the respository you want to bring in. In this case it is: https://github.com/mattdemography/STA_6233

#Navigate to File -> New Project -> Version Control -> Git -> and paste the link above into the gitrepo field.
#Now you will have all of the course materials in an R project. This project is static - it will not change as new items are put into the folder.
#In order to make sure you are seeing the newest versions of items you will use:
system("git pull https://github.com/mattdemography/STA_6233")


#https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
