source('calculation.R')
items = read.csv('adc_items.csv')
rownames(items)=NULL
champions = read.csv('champions.csv')
rownames(champions)=NULL
spells = read.csv('adcList.csv')
rownames(spells)=NULL
items = items[-53,]

Ashe = function(champions, level, item, spells, spell_level, armor, resist){
    champ = return_info(champions,'Ashe',level)
    r = rtable(champ, item)
    rtable = r[[1]]
    rpassive = r[[2]]
    spell = spells[1:6,]
    q = spell[spell_level[1]+1,]
    w = spell[spell_level[2]+1,]
    e = spell[spell_level[3]+1,]
    r = spell[spell_level[4]+1,]
    if ('Infinity Edge' %in% item$name){bonus_critical_damage=0.5}else{bonus_critical_damage=0}
    bonus_rate_multiply = 1.1 + (rtable$CriticalStrikeChance[1]*(1+bonus_critical_damage))
    damage = rtable$AttackDamage[1]
if(spell_level[1]!=0){
        interval = function(){
            fast = 1/(rtable$AttackSpeed[1]*(1+q$q_speed))
            slow = 1/rtable$AttackSpeed[1]
            v = c(0)
            n = 0
            repeat{if(n > 300){break}else{
                    t = n + spell$q_speed[1]
                    repeat{if(n > t){
                        list = n + seq(slow, by=slow,length.out = spell$q_c[1] - 1)
                        v = c(v,list)
                        n = n + slow * (spell$q_c[1] - 1)
                        break
                        }else{
                            n = n + fast
                            v = c(v,n)
                        }}}
            }
            v
        }
        time_list = interval()
        damage_list = rep(damage, length(time_list))
        type_list = rep('Basic', length(time_list))
        result = data.frame('time'=time_list, 'damage'=damage_list, 'type'=type_list)

# Q ability simulation.
        q_interval = function(){
            fast = 1/(rtable$AttackSpeed[1]*(1+q$q_speed))
            slow = 1/rtable$AttackSpeed[1]
            v = c(0)
            n = 0
            repeat{if(n > 300){break}else{
                t = n + spell$q_speed[1]
                repeat{if(n > t){
                    n = n + slow * (spell$q_c[1] - 1)
                    break
                }else{
                    n = n + fast
                    v = c(v,n)
                    }
                }}
            }
            v
        }
        q_damage = q$q_ad_p * damage * spell$q_ad_p[1]
        q_time_list = q_interval()
        q_damage_list = rep(q_damage, length(q_time_list))
        q_type_list = rep('Q', length(q_time_list))
        result = rbind(result, data.frame('time'=q_time_list, 'damage'=q_damage_list, 'type'=q_type_list))
}else{
        time_list = seq(0, 300, by = 1/rtable$AttackSpeed[1])
        damage_list = rep(damage, length(time_list))
        type_list = rep('Basic', length(time_list))
        result = data.frame('time'=time_list, 'damage'=damage_list, 'type'=type_list)   
    }
# W ability simulation.
if(spell_level[2]!=0){
    w_time_list = seq(0, 300, by=w$w_c*(1-rtable$CooldownReduction[1]))
    w_damage_list = rep((w$w_ad+damage*w$w_ad_p), length(w_time_list))
    w_type_list = rep('W', length(w_time_list))
    result = rbind(result, data.frame('time'=w_time_list, 'damage'=w_damage_list, 'type'=w_type_list))
}else{}
# R ability simulation
if(spell_level[4]!=0){
    r_time_list = seq(0, 300, by=r$r_c*(1-rtable$CooldownReduction[1]))
    r_damage_list = rep((r$r_ap+r$r_ap_p*rtable$AbilityPower[1]), length(r_time_list))
    r_type_list = rep('R', length(r_time_list))
    result = rbind(result, data.frame('time'=r_time_list, 'damage'=r_damage_list, 'type'=r_type_list))
}else{}
# Add damage caused by items' passive.
    passive = function(rpassive, result, time_list, chance, resist){
        basic = subset(result, type='Basic')
        attack = basic[1,2]
        n = length(rpassive)
        for (i in 1:n){
            p = rpassive[[i]]
            if(grepl('bleed', p)){damage=as.numeric(substr(p,19,21))*attack/5; damage=damage*(1+chance)
                                  result = rbind(result, data.frame('time'=seq(0,300), 'damage'=rep(damage,301), 'type'=rep('Bleed',301)))}
            if(grepl('energized',p)){lower=as.numeric(substr(p,27,28));upper=as.numeric(substr(p,30,32))
                                          if(is.na(upper)){damage=lower}else{damage=lower+(level-1)*(upper-lower)/17}
                                          passive_time_list = time_list[seq(1,length(time_list),by=8)]
                                          result = rbind(result, data.frame('time'=passive_time_list, 'damage'=rep(damage,length(passive_time_list)), 'type'=rep('Energized',length(passive_time_list))))}
            if(grepl('spellblade',p)){damage=attack*as.numeric(substr(p,13,16))-attack;interval=as.numeric(substr(p,33,35))+0.5
                                           passive_time_list=seq(0,300,by=interval);damage_list=rep(damage,length(passive_time_list));type_list=rep('SpellBlade', length(passive_time_list))
                                           result = rbind(result, data.frame('time'=passive_time_list, 'damage'=damage_list, 'type'=type_list))}
            if(grepl('stack',p)){stack=as.numeric(substr(p,8,8)); t=as.numeric(substr(p,42,42)); extra=stack*t
                                 result = rbind(result, data.frame('time'=time_list, 'damage'=rep(extra,length(time_list)), 'type'=rep('Stack',length(time_list))))}
            if(grepl('magicresist',p)){change=as.numeric(substr(p,14,18));resist=resist+change}
        }
        a = list(result, resist)
        a
    }
    rr = passive(rpassive, result, time_list, rtable$CriticalStrikeChance[1], resist)
    result = rr[[1]]
    resist = rr[[2]]

# Adjust damage by armor, resist and Ashe's passive.
    result$time = as.numeric(result$time)
    result$damage = as.numeric(result$damage)
    result$damage = bonus_rate_multiply*result$damage
    armor_ratio = 100/(100+armor)
    resist_ratio = 100/(100+resist)
    for (i in 1:nrow(result)){
        if (result[i,3] %in% c('R', 'Bleed', 'Energized')){result[i,2]=result[i,2]*resist_ratio}
        else{result[i,2]=result[i,2]*armor_ratio}}

    result
}

adj_ashe = function(result){
    result$time = ceiling(result$time)
    sum = tapply(result$damage, list(result$time, result$type), sum)
    c = ncol(sum)
    nd = data.frame('time'=as.numeric(rownames(sum)), 'damage'=sum[,1], 'type'=colnames(sum)[1])
    if(c>=2){for (i in 2:c){nd = rbind(nd, data.frame('time'=as.numeric(rownames(sum)), 'damage'=sum[,i], 'type'=colnames(sum)[i]))}}
    nd = nd[complete.cases(nd),]
    rownames(nd) = NULL
    nd
}

item_comparison <- function(champions, level, item, spells, spell_level, armor, resist, item1, item2){
    result_og <- Ashe(champions, level, item, spells, spell_level, armor, resist)
    
    set_1 <- rbind(item, item1)
    result_1 <- Ashe(champions, level, set_1, spells, spell_level, armor, resist)
    set_2 <- rbind(item, item2)
    result_2 <- Ashe(champions, level, set_2, spells, spell_level, armor, resist)
    
    r_og <- sum(result_og$damage)/300
    r_1 <- sum(result_1$damage)/300
    r_2 <- sum(result_2$damage)/300
    
    plus_1 <- r_1 - r_og
    plus_2 <- r_2 - r_og
    
    value_1 <- as.numeric(item1$total)
    value_2 <- as.numeric(item2$total)
    
    dollar_1 <- 100*(plus_1/value_1)
    dollar_2 <- 100*(plus_2/value_2)
    
    list(plus_1,plus_2,dollar_1,dollar_2) 
}

