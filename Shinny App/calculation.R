source('base_functions.R')

rtable = function(champ, item){
    attack_c = 0
    attack_cp = 0
    speed_c = 0
    chance_c = 0
    move_c = 0
    health_c = 0
    magic_c = 0
    LifeSteal_c = 0
    LifeonHit_c = 0
    Cooldown_c = 0
    MagiconHit_c = 0
    FlatArmorPen_c = 0
    PercentArmorPen_c = 0
    passive = c()
    n = nrow(item)
    for (i in 1:n){
        set = item[i,]
        for (j in 1:length(set)){
            if(is.na(set[j])){set[j]=0}
        }
        attack_c = attack_c + set[6]
        attack_cp = attack_cp + set[21]
        speed_c = speed_c + set[5]
        chance_c = chance_c + set[7]
        move_c = move_c + set[20]
        health_c = health_c + set[8]
        magic_c = magic_c + set[17]
        LifeSteal_c = LifeSteal_c + set[9]
        LifeonHit_c = LifeonHit_c + set[10]
        Cooldown_c = Cooldown_c + set[12]
        MagiconHit_c = MagiconHit_c + set[16]
        FlatArmorPen_c = FlatArmorPen_c + set[23]
        PercentArmorPen_c = PercentArmorPen_c + set[26]
        if (is.na(set[24])){passive=passive}else{passive = c(passive, set[24])}
    }
    data = data.frame(
        attack = champ$attack + attack_c + champ$attack * attack_cp,
        speed = champ$speed * (1+speed_c),
        chance = champ$chance + chance_c,
        move = champ$move * (1+move_c),
        health = champ$health + health_c,
        magic = champ$magic + magic_c,
        lifeSteal = LifeSteal_c,
        lifeonHit = LifeonHit_c,
        cooldown = Cooldown_c,
        magiconHit = MagiconHit_c,
        flatArmorPen = FlatArmorPen_c,
        percentArmorPen = PercentArmorPen_c)
    data[2,] = c(champ[1,][c(2,3,4,5,6,8)], c(0,0,0,0,0,0))
    part = data.frame('Name'=c(champ$name, champ$name), 'State'=c('Result', 'Origin'))
    data = cbind(part,data)
    
# Dealing with item's passive - cooldown reduction
    get_reduction = function(passive, chance){
        reduction = 0
        n = length(passive)
        for(i in 1:n){
            p=passive[[i]]
            if(grepl('cooldown',p)){reduction=reduction+chance*as.numeric(substr(p,11,13))}
            else{}
        }
        reduction
    }
    cd_reduction = get_reduction(passive, data$CriticalStrikeChance[1])
    data$CooldownReduction[1] = data$CooldownReduction[1] + cd_reduction
    if(data$CooldownReduction[1]>0.4){data$CooldownReduction[1]=0.4}
    a = list(data, passive)
    a
}

dps = function(rtable){
    set = rtable[1,]
    adps = as.numeric(set[3]*set[4]*(1+set[5]))
    apps = as.numeric(set[12])
    c('Pyisical dps'=adps[[1]], 'Magical dps'=apps[[1]])
}

health = function(rtable, second){
    health_c = rtable[1,7] - rtable[2,7]
    lifesteal = rtable[1,9] * dps(rtable)[[1]] + rtable[1,10]
    health_cs = as.numeric(health_c + lifesteal * second)
    c('Health increase'=health_cs)
}

adj_dps = function(rtable, armor, resist){
    dps = dps(rtable)
    armor = armor - rtable[1,13]
    if (armor < 0 ){armor=0}
    dps = as.numeric(dps) * (100/(100+c(armor,resist)))
    names(dps) = c('Pyisical dps', 'Magical dps')
    dps
}
