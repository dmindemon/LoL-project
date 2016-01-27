source('calculation.R')
source('simulator.R')

shinyServer(function(input, output) {
    action_refresh <- eventReactive(input$refresh, withProgress(message='Calculating... Maybe 10 seconds :)', value=0, {
        ids = c(input$item1,input$item2,input$item3,input$item4,input$item5,input$item6,input$item7,input$item8)
        item = rbind(items[items$id==ids[1],],items[items$id==ids[2],],items[items$id==ids[3],],items[items$id==ids[4],],items[items$id==ids[5],],items[items$id==ids[6],])
        results = item_all(champions, input$level, item, spells, c(input$q, input$w, input$e, input$r), input$armor, input$resist, items)
    }))
    
    output$comparison_whole <- renderPlot({
        result <- action_refresh()
        if (input$choice==1){r <- result[[1]]}else{r <- result[[2]]}
        low <- input$cost_range[1]
        high <- input$cost_range[2]
        r <- subset(r, gold>=low & gold<=high)
        g <- ggplot(r, aes(x=name, y=value)) + geom_bar(stat='identity',fill="#56B4E9")+
            theme(axis.text.x = element_text(angle = 90, hjust=1), plot.margin=unit(c(0.1,0.5,3.3,0),'cm')) + labs(x=NULL, y=NULL)
        g
    })
    
    output$warn <- renderText({
        sum <- input$q + input$e + input$w + input$r
        string <- ' '
        if (input$level < sum){
            string <- paste("Error: the champion's level is not high enough to have these spells levels.")
        }
        string
    })
    
    output$gold <- renderText({
        ids = c(input$item1,input$item2,input$item3,input$item4,input$item5,input$item6,input$item7,input$item8)
        item = rbind(items[items$id==ids[1],],items[items$id==ids[2],],items[items$id==ids[3],],items[items$id==ids[4],],items[items$id==ids[5],],items[items$id==ids[6],])
        sum = sum(item$total)
        paste0('TOTAL COST: ', sum)
    })
    
    action_comp <- eventReactive(input$go_comparison, {
        ids = c(input$item1,input$item2,input$item3,input$item4,input$item5,input$item6,input$item7,input$item8)
        item = rbind(items[items$id==ids[1],],items[items$id==ids[2],],items[items$id==ids[3],],items[items$id==ids[4],],items[items$id==ids[5],],items[items$id==ids[6],])
        item1 = items[items$id==ids[7],]
        item2 = items[items$id==ids[8],]
        name1 = as.character(item1$name)
        name2 = as.character(item2$name)
        result = item_comparison(champions, input$level, item, spells, c(input$q,input$w,input$e,input$r), input$armor, input$resist, item1, item2)
        list(result, name1, name2, item1, item2)
    })
    output$comparison_abs <- renderPlot({
        r = action_comp()
        r1 = r[[1]][[1]]
        r2 = r[[1]][[2]]
        name1 = r[[2]]
        name2 = r[[3]]
        df = data.frame('name'=c(name1,name2), 'dps'=c(r1,r2))
        g = ggplot(df, aes(x=name, y=dps, fill=name)) + geom_bar(stat='identity') +
            labs(x='Name', y='Bonus Damage/second') + guides(fill=FALSE)
        g
    })
    output$comparison_cost <- renderPlot({
        r = action_comp()
        name1 = r[[2]]
        name2 = r[[3]]
        item1 = r[[4]]
        item2 = r[[5]]
        cost1 = item1$total
        cost2 = item2$total
        df = data.frame('name'=c(name1,name2), 'cost'=c(cost1,cost2))
        g = ggplot(df, aes(x=name, y=cost, fill=name)) + geom_bar(stat='identity') +
            labs(x='Name', y='Cost') + guides(fill=FALSE)
        g        
    })
    output$comparison_per <- renderPlot({
        r = action_comp()
        r1 = r[[1]][[3]]
        r2 = r[[1]][[4]]
        name1 = r[[2]]
        name2 = r[[3]]
        df = data.frame('name'=c(name1,name2), 'dps'=c(r1,r2))
        g = ggplot(df, aes(x=name, y=dps, fill=name)) + geom_bar(stat='identity') +
            labs(x='Name', y='Bonus DPS/100 Golds') + guides(fill=FALSE)
        g
    })
    
    action_cal <- eventReactive(input$calculate, {
        ids = c(input$item1,input$item2,input$item3,input$item4,input$item5,input$item6)
        item = rbind(items[items$id==ids[1],],items[items$id==ids[2],],items[items$id==ids[3],],items[items$id==ids[4],],items[items$id==ids[5],],items[items$id==ids[6],])
        visual = Ashe(champions, input$level, item, spells, c(input$q,input$w,input$e,input$r), input$armor, input$resist)
        visual = visual[order(visual$time),]
        if (input$checkbox==TRUE){
            visual = subset(visual, type!='R')
        }
        a = total_damage(visual, input$seconds)
        b = second_need(visual, input$damage)
        result <- list(a,b)
    })
    action <- eventReactive(input$go, {
        ids = c(input$item1,input$item2,input$item3,input$item4,input$item5,input$item6)
        item = rbind(items[items$id==ids[1],],items[items$id==ids[2],],items[items$id==ids[3],],items[items$id==ids[4],],items[items$id==ids[5],],items[items$id==ids[6],])
        visual = Ashe(champions, input$level, item, spells, c(input$q,input$w,input$e,input$r), input$armor, input$resist)
        visual
    })
    output$damage <- renderText({paste('Damage Deal:', round(action_cal()[[1]][[1]]))})
    output$behaviors <- renderUI({
        table = action_cal()[[1]][[2]]
        string = ""
        n = nrow(table)
        for(i in 1:n){
                part = paste0(names(table)[i],": ", table[i])
                string = paste(string, part, sep='<br/>')}
        HTML(string)
        })
    output$second <- renderText({paste('Seconds Needed:', action_cal()[[2]][[1]])})
    output$behaviors_s <- renderUI({
        table = action_cal()[[2]][[2]]
        string = ""
        n = nrow(table)
        for(i in 1:n){
            part = paste0(names(table)[i],": ", table[i])
            string = paste(string, part, sep='<br/>')}
        HTML(string)
    })
    
    output$text1 = renderUI({
        ids = c(input$item1,input$item2,input$item3,input$item4,input$item5,input$item6)
        item = rbind(items[items$id==ids[1],],items[items$id==ids[2],],items[items$id==ids[3],],items[items$id==ids[4],],items[items$id==ids[5],],items[items$id==ids[6],])
        champ = return_info(champions, 'Ashe', input$level)
        table = rtable(champ,item)[[1]][1,]
        table[1,] = round(as.numeric(table[1,]),2)
        b = paste(names(table)[3], table[3], sep=':')
        c = paste(names(table)[4], table[4], sep=':')
        d = paste(names(table)[5], table[5], sep=':')
        e = paste(names(table)[6], table[6], sep=':')
        f = paste(names(table)[7], table[7], sep=':')
        g = paste(names(table)[8], table[8], sep=':')
        h = paste(names(table)[9], table[9], sep=':')
        i = paste(names(table)[11], table[11], sep=':')
        j = paste(names(table)[12], table[12], sep=':')
        k = paste(names(table)[13], table[13], sep=':')
        l = paste(names(table)[14], table[14], sep=':')
        
        HTML(paste(b,c,d,e,f,g,h,i,j,k,l, sep='<br/>'))
    })
    
    output$text2 = renderPrint({
        ids = c(input$item1,input$item2,input$item3,input$item4,input$item5,input$item6)
        item = rbind(items[items$id==ids[1],],items[items$id==ids[2],],items[items$id==ids[3],],items[items$id==ids[4],],items[items$id==ids[5],],items[items$id==ids[6],])
        champ = return_info(champions, 'Ashe', input$level)
        table = rtable(champ,item)[[1]][2,]
        table[1,] = round(as.numeric(table[1,]),2)
        b = paste(names(table)[3], table[3], sep=':')
        c = paste(names(table)[4], table[4], sep=':')
        d = paste(names(table)[5], table[5], sep=':')
        e = paste(names(table)[6], table[6], sep=':')
        f = paste(names(table)[7], table[7], sep=':')
        g = paste(names(table)[8], table[8], sep=':')
        h = paste(names(table)[9], table[9], sep=':')
        i = paste(names(table)[11], table[11], sep=':')
        j = paste(names(table)[12], table[12], sep=':')
        k = paste(names(table)[13], table[13], sep=':')
        l = paste(names(table)[14], table[14], sep=':')
        
        HTML(paste(b,c,d,e,f,g,h,i,j,k,l, sep='<br/>'))
    })
    
    output$point = renderPlotly({
        visual = action()
        gg = ggplot(visual, aes(x=time, y=damage, colour=type)) + geom_point() + 
            xlim(-0.8, 20.8) + labs(x='Second', y='Damage') + ylim(0,1000)
        gg
        })
    
    output$density = renderPlot({
        df = action()
        adj_df = adj_ashe(df)
        gg = ggplot(adj_df, aes(x=time, y=damage, fill=type)) + geom_bar(stat='identity') + 
            xlim(-0.8, 20.8) + labs(x='Second', y='Damage')
        gg
    })
    
    output$total = renderPlot({
        visual = action()
        sum = tapply(visual$damage, visual$time, sum)
        df = data.frame('time'=as.numeric(names(sum)), 'damage'=as.numeric(sum))
        gg = ggplot(df, aes(x=time, y=damage)) + geom_area(stat='smooth', colour='grey', fill="#FF9999") + 
            xlim(-0.8, 20.8) + labs(x='Second', y='Damage')
        gg
    })
})