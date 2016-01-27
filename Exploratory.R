data <- read.csv('champions.csv')
library(ggplot2)
library(Rmisc)

# Health vs. Mana
a = qplot(data$Health,data$Mana,xlab='Health',ylab='Mana',main='Level1: Health vs. Mana')
data$Max_Health = data$Health + data$Health.level * 17
data$Max_Mana = data$Mana + data$Mana.level * 17
b = qplot(data$Max_Health, data$Max_Mana,xlab='Max_Health',ylab='Max_Mana',main='Level18: Health vs. Mana')
multiplot(a,b,cols=2)

# Attack vs. Armor
c = qplot(data$Attack_dmg, data$Armor+data$Magic_Resist,xlab='Attack Damage',ylab='Armor & Magic Resist',main='Level1: Attack Damage vs. Armor')
d = qplot(data$Attack_spd, data$Armor+data$Magic_Resist,xlab='Attack Speed',ylab='Armor & Magic Resist', main='Level1: Attack Speed vs. Armor')
data$Max_Attack_dmg = data$Attack_dmg + data$Attack_dmg.level * 17
data$Max_Attack_spd = data$Attack_spd * (1 + data$Attack_spd.level_percent * 17)
data$Max_Armor = data$Armor + data$Armor.level * 17
data$Max_Magic_Resist = data$Magic_Resist + data$Magic_Resist.level * 17
e = qplot(data$Max_Attack_dmg, data$Max_Armor+data$Max_Magic_Resist,xlab='Attack Damage',ylab='Armor & Magic Resist',main='Level18: Attack Damage vs. Armor')
f = qplot(data$Max_Attack_spd, data$Max_Armor+data$Max_Magic_Resist,xlab='Attack Speed',ylab='Armor & Magic Resist',main='Level18: Attack Speed vs. Armor')
multiplot(c,d,e,f, cols=2)
