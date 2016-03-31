library(rvest)
library(stringr)
data = read.csv("Champions_names.csv")
data$X = NULL
data$id = NULL
names = data$name
names=tolower(names)
names=gsub("'","",names)
names=gsub(" ","",names)
names=gsub('[[:punct:]]','',names)
names[as.logical(match(names,'wukong'))]="monkeyking"
colnames = c('Health', 'Health.level', 'Health_Regen', 'Health_Regen.level','Mana','Mana.level','Mana_Regen',
             'Mana_Regen.level','Attack_dmg','Attack_dmg.level','Armor','Armor.level',
             'Attack_spd','Attack_spd.level_percent','Magic_Resist','Magic_Resist.level','Move_spd')
data[colnames] = NA

get_stat = function(name){
    url = paste("http://gameinfo.na.leagueoflegends.com/en/game-info/champions/",name,sep="")
    lol = html(url)
    list = lol %>% 
        html_nodes(".stat-value") %>%
        html_text()
    glist = gsub('\n','',list)
    nlist = gsub(' ','',glist)
    nl = gsub('perlevel)','',nlist)
    sl = strsplit(nl, '\\(')
    if (length(sl)==9 & length(sl[[2]])==2){
        vector = c(sl[[1]][1],sl[[1]][2],sl[[6]][1],sl[[6]][2],sl[[2]][1],sl[[2]][2],sl[[7]][1],
                sl[[7]][2],sl[[3]][1],sl[[3]][2],sl[[8]][1],sl[[8]][2],sl[[4]][1],sl[[4]][2],
                sl[[9]][1],sl[[9]][2],sl[[5]][1])
    }else if(length(sl)==9 & length(sl[[2]]==1)){
        vector = c(sl[[1]][1],sl[[1]][2],sl[[6]][1],sl[[6]][2],sl[[2]][1],NA,sl[[7]][1],
                   NA,sl[[3]][1],sl[[3]][2],sl[[8]][1],sl[[8]][2],sl[[4]][1],sl[[4]][2],
                   sl[[9]][1],sl[[9]][2],sl[[5]][1])
    }else{
        vector = c(sl[[1]][1],sl[[1]][2],sl[[5]][1],sl[[5]][2],NA,NA,NA,
                    NA,sl[[2]][1],sl[[2]][2],sl[[6]][1],sl[[6]][2],sl[[3]][1],sl[[3]][2],
                    sl[[7]][1],sl[[7]][2],sl[[4]][1])
    }
    vector
}

for(i in 1:nrow(data)){
    data[i,-1] = get_stat(names[i])
}

data$Attack_spd.level_percent = as.numeric(sub('%','',data$Attack_spd.level_percent))/100

write.csv(data, file="champions.csv")
