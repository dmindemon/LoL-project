data = read.csv('raw_items.csv')
items = data[,c(3,8,4,6,7,2)]
items = items[order(items$total),]
items = subset(items, purchasable=='True')
items = subset(items, total!=0)
items = items[,-3]
rownames(items)=NULL
groups = c('DoransShowdown', NA)
items = subset(items, group %in% groups | grepl('Boots',group))

condition = function(string){
    set = c('Crit','Attack','Physical','Armor Penetration','LifeSteal')
    r = FALSE
    for (i in 1:5){
        if (grepl(set[i],string)){r = TRUE}
    } 
    r
}

stats = items$stats
con = sapply(stats,condition)
result = items[con,]

pretransform = function(data){
    n = nrow(data)
    for (i in 1:n){
        string = as.character(data$stats[i])
        stat = strsplit(string, "</stats>")[[1]][1]
        others = strsplit(string, "</stats>")[[1]][2]
        if(is.na(others)){passive=NA}else{passive = strsplit(others, "<active>")[[1]][1]}
        if(is.na(passive)){active=NA}else{active = strsplit(others, "<active>")[[1]][2]}
        data[i,'stat'] = stat        
        data[i, 'passive'] = passive
        data[i, 'active'] = active  
    }
    data$stats=NULL
    data    
}
pretrans = pretransform(result)

stattransform = function(data){
    n = nrow(data)
    for (i in 1:n){
        string = as.character(data$stat[i])
        string = gsub('<stats>','',string)
        sets = strsplit(string, "<br>")[[1]]
        sets = gsub('<mana>|<mana>', '', sets)
        m = length(sets)
        for (j in 1:m){
            value = strsplit(sets[j], " ")[[1]][1]
            if (value==""){
                value = strsplit(sets[j], " ")[[1]][2]
            }
            key = gsub(value, "", sets[j])
            key = gsub(" ","",key)
            data[i,key] = value
        }  
    }
    data$stat=NULL
    data
    
}
stattrans = stattransform(pretrans)
names(stattrans)
names(stattrans)[c(13, 20, 26)] = c('Mana', 'ManaRegen', 'FlatArmorPenetration')
for (i in 1:nrow(stattrans)){
    if (is.na(stattrans[i,23])){}
    else {stattrans[i,9] = stattrans[i,23]}
}
stattrans[,23]=NULL
for (i in 7:ncol(stattrans)){
    set = stattrans[,i]
    con = grepl('%', set)
    set = gsub('%', '', set)
    con = con* 0.01
    for (j in 1:length(con)){
        if (con[j]==0){con[j]=1}
    }
    set = as.numeric(set) * con
    stattrans[,i] = set
}

stattrans$group=NULL
rownames(stattrans)=NULL
stattrans = stattrans[,c(1:3,6:24,4:5)]
names(stattrans)=gsub('\\+','',names(stattrans))

write.csv(stattrans,'items.csv')
