library(rvest)

champion_name = html("http://leagueoflegends.wikia.com/wiki/List_of_champions")
namelist = champion_name %>%
    html_nodes("span a") %>%
    html_text()
newlist = namelist[5:255]
names = c()
n=1
for (i in 1:251){
    if (newlist[i] != ""){
        names[n]=newlist[[i]]
        n = n+1
    }
}
table = data.frame(id=seq(1:126))
table$name = names
table
write.csv(table, file="Champions_names.csv")
