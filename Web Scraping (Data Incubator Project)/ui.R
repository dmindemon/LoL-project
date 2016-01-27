
shinyUI(fluidPage(theme=shinytheme('united'),
    fixedPanel(height=730, width=1250, top=0,left=0,
               img(src='Ashe.jpg', height=730, width=1250)),
    fixedPanel(height=600, width=800, top=10, left=20,
        tabsetPanel(
            tabPanel('Behavior', plotlyOutput('point')),
            tabPanel('Classified DPS', plotOutput('density')),
            tabPanel('Total DPS', plotOutput('total')),
            tabPanel('Items Comparison',
                     div(style='height:5px;', br()),
                     column(3,
                            br(),br(),
                            p('What is your best next item?'),
                            selectInput('item7',NULL, choices = item_list, selected=0),
                            selectInput('item8','VS.', choices = item_list, selected=0),
                            actionButton('go_comparison','Go')
                            ),
                     column(9,
                            tabsetPanel(
                                tabPanel('Absolute Value', plotOutput('comparison_abs')),
                                tabPanel('Value Per $', plotOutput('comparison_per')),
                                tabPanel('Cost', plotOutput('comparison_cost')),
                                tabPanel('Whole Set', div(style='height: 300px;', plotOutput('comparison_whole')),
                                column(5, div(style='height:60px;',sliderInput("cost_range", NULL, min = 0, 
                                                      max = 4000, value = c(0, 1000))), strong('Cost Range')),
                                column(5, radioButtons("choice", label = NULL, 
                                                             choices = list("Absolute Value" = 1, "Value/100 Golds" = 2),
                                                             selected = 1)),
                                column(2, div(style='height:13px;',br()), actionButton('refresh','Refresh')))))
                     ),
            tabPanel('Champion Data', 
                     column(1),
                     column(3,br(),p('Base'), p(htmlOutput('text2'))),
                     column(1),
                     column(3,br(),p('With Items'), p(htmlOutput('text1')))),
            tabPanel('Calculator',
                     column(1),
                     column(4,br(),p('Calculate the total damage in several seconds.'),
                            numericInput('seconds', label='Seconds (0-300)', value = 10, min=0, max=300),
                            hr(),
                            p('Calculate the seconds need for certain damage.'),
                            numericInput('damage', label='Damage Deal (0-10000)', value=1000, min=0, max=10000),
                            checkboxInput('checkbox', label='R in CD', value=FALSE),
                            actionButton('calculate', 'Calculate')),
                     column(1),
                     column(6,br(),div(style='height:10px;',textOutput('damage')),div(style='height:107px;',htmlOutput('behaviors')),hr(),
                            div(style='height:10px;', textOutput('second')), htmlOutput('behaviors_s')))
            )
        ),
    fixedPanel(height=700, width=400, top=10, left=815,
        column(6,
            h4('CHAMPION'),
            div(style="height: 100px;", 
                selectInput('name','Name', choices = list('Ashe'=1), selected=1)),
            div(style='height: 100px;', sliderInput('level', 'Level', min=1, max=18, value=1)),
            column(6, numericInput('q','Q',value=0, min=0, max=5, step=1), numericInput('w','W',value=0, min=0, max=5, step=1)),
            column(6, numericInput('e','E',value=0, min=0, max=5, step=1), numericInput('r','R',value=0, min=0, max=3, step=1)),
            div(style='color: red;', textOutput('warn'))
            ),
        column(6,
            h4("OPPONENT"),
            sliderInput('armor', 'Armor', min=0, max=200, value=0),
            sliderInput('resist', 'Resist', min=0, max=200, value=0),
            br(),
            actionButton('go','Get Plots'),
            br(), hr())
            ),
    
    fixedPanel(height=350, width=1200, top=450,
        column(2,
            hr(),
            h4("ITEMS"),
            div(style='height:10px;',strong(textOutput('gold'))),
            selectInput('item1','', choices = item_list, selected=0)
            ),
        column(2,br(),br(),br(),br(),
            selectInput('item2','', choices = item_list, selected=0)
            ),
        column(2,br(),br(),br(),br(),
            selectInput('item3','', choices = item_list, selected=0)
            ),
        column(2,br(),br(),br(),br(),
            selectInput('item4','', choices = item_list, selected=0)
            ),
        column(2,br(),br(),br(),br(),
            selectInput('item5','', choices = item_list, selected=0)
            ),
        column(2,br(),br(),br(),br(),
            selectInput('item6','', choices = item_list, selected=0)
            )
        )
    )
)