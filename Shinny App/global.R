library(grid)
library(shiny)
library(reshape2)
library(ggplot2)
library(rCharts)
source('calculation.R')
source('simulator.R')
library(plotly)
library(shinythemes)

items$X = NULL
items = items[order(items$name),]
item_name = items$name
item_id = items$id
item_list = list()
item_list = item_id
names(item_list) = item_name

total_damage <- function(matrix, seconds){
    damage <- 0
    Behaviors <- c()
    for (i in 1:nrow(matrix)){
        if (matrix[i,1]>seconds){break}
        else{
            damage = damage + matrix[i,2]
            if(matrix[i,3] %in% c('Q','W','E','R','Basic')){
                Behaviors = c(Behaviors, as.character(matrix[i,3]))}
        }
    }
    table = table(Behaviors)
    list(damage, table)
}

second_need <- function(matrix, damage){
    did <- 0
    Behaviors <- c()
    for(i in 1:nrow(matrix)){
        did = did + matrix[i,2]
        if(matrix[i,3] %in% c('Q','W','E','R','Basic')){Behaviors = c(Behaviors, as.character(matrix[i,3]))}
        if(did >= damage){second <- round(matrix[i,1], 1); break}
    }
    table = table(Behaviors)
    list(second, table)
}

item_all <- function(champions, level, item, spells, spell_level, armor, resist, items){
    result_og <- Ashe(champions, level, item, spells, spell_level, armor, resist)
    plus <- c()
    dollar <- c()
    r_og <- sum(result_og$damage)/300
    
    for(i in 1: (nrow(items)-1)){
        set <- rbind(item, items[i,])
        result <- Ashe(champions, level, set, spells, spell_level, armor, resist)
        r_new <- sum(result$damage)/300
        n_plus <- r_new-r_og
        plus <- c(plus, n_plus)
        value <- as.numeric(items[i,]$total)
        dollar <- c(dollar, 100*(n_plus/value))
    }
    r1 <- data.frame('name'=items$name[-66], 'value'=plus, 'gold'=items$total[-66])
    r2 <- data.frame('name'=items$name[-66], 'value'=dollar, 'gold'=items$total[-66])
    r1$name <- factor(r1$name, levels = r1$name[order(r1$value,decreasing=TRUE)])
    r2$name <- factor(r2$name, levels = r2$name[order(r2$value,decreasing=TRUE)])
    list(r1,r2)
}

