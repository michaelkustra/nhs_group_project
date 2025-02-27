
ui <- dashboardPage(skin = "purple",
                    dashboardHeader(title = "Epic dashboard"),

                    # Sidebar content
                    dashboardSidebar(

                      sidebarMenu(

                        # lots of icons we can use here: https://fontawesome.com/icons/categories/medical-health
                        menuItem("Overview", tabName = "overview", icon = icon("book-medical"),
                                 badgeLabel = " ", badgeColor = "teal"),
                        menuItem("Effects of COVID", tabName = "temporal", icon = icon("chart-line"),
                                 badgeLabel = " ", badgeColor = "teal"),
                        menuItem("Geographic Analysis", tabName = "geographic", icon = icon("globe"),
                                 badgeLabel = " ", badgeColor = "teal"),
                        menuItem("Demographic Analysis", tabName = "demographic", icon = icon("hospital-user"),
                                 badgeLabel = " ", badgeColor = "teal")
                      )
                    ),

                    # Body content
                    dashboardBody(

                      # First overview tab
                      tabItems(


                        # Overview tab content
                        tabItem(tabName = "overview",

                                fluidRow(
                                  box(width = 2,
                                      background = "teal",
                                      checkboxGroupButtons(
                                        inputId = "year_input",
                                        label = "Select Year",
                                        choices = c("2020", "2021"),
                                        selected = c("2020", "2021"),
                                        justified = TRUE,
                                        checkIcon = list(yes = icon("ok", lib = "glyphicon"))
                                      )
                                  ),
                                  box(
                                    background = "purple",
                                    tags$h4(HTML("This dashboard uses data published by Public Health Scotland relating to the last few years of hospital and health board activity to investigate the winter health crisis. On this tab, graphs show a comparison between non-winter and winter key statistics for bed capacity, admissions, length of stay, and deaths. Shading denotes winter months.", "<br>")), width = 10
                                  ),
                                ),

                                fluidRow(
                                  tabBox(width = 12,
                                         title = textOutput("title_overview"),
                                         id = "tabbox_id",
                                         #Main visual (tabset with plots showing diff in
                                         #KPI's in Winter)

                                         #Admissions
                                         tabPanel("Admissions",
                                                  value = "admissions",

                                                  plotOutput("overview_admissions_plot")
                                         ),

                                         #Bed capacity
                                         tabPanel("Bed Capacity",
                                                  value = "beds",

                                                  plotOutput("overview_beds_plot")

                                         ),

                                         #Length of stay
                                         tabPanel("Length of stay",
                                                  value = "los",

                                                  plotOutput("overview_los_plot")

                                         )
                                  )
                                ),

                                fluidRow(
                                  valueBoxOutput("valuebox_winter_mean", width = 4),
                                  valueBoxOutput("valuebox_winter_max", width = 4),
                                  valueBoxOutput("valuebox_winter_min", width = 4)
                                ),

                                fluidRow(
                                  valueBoxOutput("valuebox_other_mean", width = 4),
                                  valueBoxOutput("valuebox_other_max", width = 4),
                                  valueBoxOutput("valuebox_other_min", width = 4)
                                )

                        ),

                        # Temporal tab content
                        tabItem(tabName = "temporal",

                                fluidRow(
                                  valueBox("-11%", "Emergency admissions",
                                           icon = icon("hospital"),
                                           color = "purple"),

                                  valueBox("-17%", "A&E attendance",
                                           icon = icon("user-injured"),
                                           color = "purple"),

                                  valueBox("+9%", "Deaths",
                                           icon = icon("skull"),
                                           color = "purple")
                                ),

                                fluidRow(
                                  tabBox(title = textOutput("title_pre_post"),
                                         id = "pre_post_id",
                                         width = 12,
                                         tabPanel("Emergency admissions", value = "emergencies", plotOutput("emergency_admissions_plot")),
                                         tabPanel("A&E attendance", value = "aeattendances", plotOutput("a_e_attendance_plot")),
                                         tabPanel("Weekly deaths", value = "weeklydeaths", plotOutput("deaths_weekly_plot")))),

                                fluidRow(
                                  box(background = "purple",
                                      tags$h4(HTML("Graphs comparing emergency admissions, A&E admissions and weekly deaths, with a coloured line showing the running average of each value for times <i>pre</i> and <i>post</i>-COVID. Information boxes display the overall change <i>pre</i> and <i>post</i>-COVID. Shading denotes winter months.")), width = 12)
                                ),

                        ),

                        # Geographic tab content
                        tabItem(tabName = "geographic",
                                fluidRow(
                                  tabBox(title =  textOutput("title"),
                                         id = "geotabs",
                                         width = 12,
                                         tabPanel(value = "area", "Region Data", 
                                                  leafletOutput("heatmap")),
                                         tabPanel(value = "point", "Hospital Data", 
                                                  leafletOutput("hospital_plot")))),
                                fluidRow(
                                  box(background = "purple", 
                                      width = 3, 
                                      radioButtons("map_data",
                                                   "Investigate Winter Increase",
                                                   choices = c(
                                                     "Mortality" = "winter_mortality_increase",
                                                     "Wait Time Tariff Overflow" = "winter_target_wait_time_overshoot_increase",
                                                     "Beds Filled" = "winter_beds_increase"))
                                  ),
                                  
                                  box(background = "purple", 
                                      tags$h4(HTML(" These maps depict the change in beds taken, length of stay and mortality between summer and winter by Scottish health board area between winter and non-winter months.")), 
                                      width = 9)
                                  
                                )),

                        # Demographic tab content
                        tabItem(tabName = "demographic",
                                fluidRow(
                                  tabBox(
                                    title = textOutput("title_demo"),
                                    id = "demotab_1",
                                    width = 12,
                                    tabPanel(value = "simd",
                                             "SIMD Plot",
                                             plotlyOutput("simd_plot")),
                                    tabPanel(value = "age",
                                             "Age Plot",
                                             plotlyOutput("age_plot")),
                                    tabPanel(value = "sex",
                                             "Sex Plot",
                                             plotlyOutput("sex_plot"))
                                  )),

                                fluidRow(column(6,
                                  box(width = 12,

                                      valueBoxOutput("max_diff_demo", width = 6),
                                      infoBoxOutput("min_diff_demo", width = 6)
                                  ),
                                  fluidRow(
                                    box(background = "purple", 
                                        tags$h4(HTML("Understanding the intersectionality of demographics with winter hospital activity statistics is key to making sure the NHS can deliver services to people that need it the most. These graphs show activity by <i>SIMD 5 quintiles</i>, a scale which measures the 5 quintiles of the Scottish Index of Multiple Deprivation, Age, and Gender.<br><br><b>Click on the legend to select/deselect desired lines on plot</b>")), width = 12),
                                  )),

                                  box(plotOutput("micro_graph"), width = 6)
                                ),
                                )
                        )
                      )
                    )

