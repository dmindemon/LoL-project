data = read.csv('items.csv')

checklist = data.frame('name'=data$name, 'passive'=data$passive, 'active'=data$active)
checklist$passive[c(4,5,7,9,14,21,23,25,26,28,33,34,36)] = NA
checklist$passive = gsub('<br>', '', checklist$passive)
checklist$passive = gsub('<unique>','',checklist$passive)
checklist$passive = gsub('<passive>','',checklist$passive)
checklist$passive[8] = 'energized: 12 per attack, 30 magic damage.'
passiveList = c('energized')
checklist$passive[13] = NA
data$Health[13] = 150
checklist$passive[15] = NA
data$AttackDamage[15] = 15
checklist$passive[16] = 'spellblade: 1.00 attack damage, 1.5 cd.'
passiveList = c(passiveList, 'spellblade')

checklist$passive[17] = NA
data$FlatArmorPenetration[17] = 10

checklist$passive[18] = NA
data$CooldownReduction[18] = 0.1

checklist$passive[19] = NA

checklist$passive[20] = NA

checklist$passive[22] = 'bleed: critical - 0.6 attack damage as magic damage, over 3 seconds.'
passiveList = c(passiveList, 'bleed')

checklist$passive[24] = NA
data$CooldownReduction[24] = 0.1

checklist$passive[27] = NA
data$PercentArmorPenetration = NA
data$PercentArmorPenetration[27] = 0.3 

data = data[-32,]
checklist = checklist[-32,]

checklist$passive[30] = NA

checklist$passive[34] = 'bleed: critical - 0.9 attack damage as magic damage, over 3 seconds.'

checklist = checklist[c(-36,-37),]
data = data[c(-36,-37),]

checklist$passive[36] = 'stack: 6 attack damage, 0.01 life steal, 5 times.'
passiveList = c(passiveList, 'stack')

checklist = checklist[-37,]
data = data[-37,]

checklist$passive[37] = 'energized: 12 per attack, 50-200 magic damage.'

checklist$passive[38] = NA
data$AttackDamage[38] = 15

checklist$passive[39] = 'energized: 12 per attack, 50-150 magic damage'

checklist$passive[40] = NA

checklist$passive[41] = NA

checklist$passive[42] = 'spellblade: 1.25 attack damage, 1.5 cd.'

checklist$passive[44] = NA
data$PercentArmorPenetration[44] = 0.4

checklist$passive[45] = NA

checklist$passive[46] = NA

checklist$passive[47] = 'magicresist: -25'
passiveList = c(passiveList, 'magicresist')
data$MagicDamageonHit[47] = 40

checklist$passive[48] = NA
checklist$passive[49] = NA

checklist$passive[50] = NA
data$CooldownReduction[50] = 0.2
data$MagicDamageonHit[50] = 15

checklist$passive[51] = NA
checklist$passive[52] = NA
data$FlatArmorPenetration[52] = 20

checklist$passive[53] = 'spellblade: 0.75 attack damage, 1.5 cd, 0.50 ability.'

checklist$passive[54] = NA

checklist$passive[55] = NA
data$LifeSteal[55] = 0.15

checklist$passive[56] = NA
data$LifeSteal[56] = 0.12

checklist$passive[57] = NA

checklist$passive[58] = NA
data$PercentArmorPenetration[58] = 0.3

checklist$passive[59] = 'infinity: 0.5 bonus critical damage.'
passiveList = c(passiveList, 'infinity')

checklist$passive[60] = NA

checklist$passive[61] = 'cooldown: 0.3 of critical chance as cd reduction.'
passiveList = c(passiveList, 'cooldown')
data$CooldownReduction[61] = 0.1

checklist$passive[62] = 'bleed: critical - 1.5 attack damage as magic damage, over 3 seconds.'
checklist$passive[63] = NA
checklist$passive[64] = NA

checklist$passive[65] = NA
data$LifeSteal[65] = 0.2

checklist$passive[66] = 'spellblade: 2.00 attack damage, 1.5 cd. '

data$passive = checklist$passive
data$passive[43] = NA
data$X = NULL
data$name = as.character(data$name)
data = rbind(data, c("None", 0, 0, rep(NA,23)))

write.csv(data, 'adc_items.csv')
