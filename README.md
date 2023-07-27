# datamods_reprex
datamods filter module bug

I have recently encountered the issue while using the `{datamods}` filter module. The problem arises when the dataset contains a column "class" with the data type `"POSIXct" "POSIXt"` that includes timestamps. Specifically, when utilizing the `dateRangeInput` function, the last day's data is not displayed as expected.

To provide a clear understanding, I have included a sample dataset along with the corresponding reprex app code below:

data:
```{r}
> dat
# A tibble: 8 x 2
     ID TESTTM             
  <int> <dttm>             
1     1 2018-06-09 11:50:00
2     2 2017-04-06 12:30:00
3     3 2018-01-23 23:59:00
4     4 2017-12-20 11:20:00
5     5 2018-03-18 23:59:00
6     6 2017-12-29 12:12:00
7     7 2018-09-07 20:38:20
8     8 2018-09-07 23:59:00
```
sample data can be downloaded from here;
[sample data](https://github.com/ramamet/datamods_reprex/blob/31558291f49f4003e36d16c5815078ce8e128219/dat.rds)

Shiny app reprex code;

````{r}
# load packages
library(shiny)
library(datamods)
library(DT)

# read data
dat <- readRDS('dat.rds')

# ui
ui <- fluidPage(
  tags$h3("Import data"),
  fluidRow(
    column(
      width = 4,
      filter_data_ui("filtering", max_height = "500px")
    ),
    column(
      width = 8,
      tags$b("Imported data:"),
      DT::dataTableOutput("mytable")
    )
  )
)


# server side
server <- function(input, output, session) {

  res_filter <- filter_data_server(
    id = "filtering",
    data = reactive(dat),
    name = reactive("dat"),
    vars = reactive(names(dat))
    , widget_char = c("select")
    , widget_num = c("slider")
    , widget_date = c("range")
    , label_na = "empty_cell"
  )

  output$mytable = DT::renderDataTable({
    res_filter$filtered()
  })

}

# run app
shinyApp(ui, server)  

````

Additionally, for your convenience, I have attached screenshots and the session info.

initial data;

![image](https://github.com/ramamet/datamods_reprex/blob/31558291f49f4003e36d16c5815078ce8e128219/out1.png)

last day data (selected 2018-09-07; app shows `0` output);

![image](https://github.com/ramamet/datamods_reprex/blob/31558291f49f4003e36d16c5815078ce8e128219/out2.png)

```{r}

> sessionInfo()
R version 4.1.0 (2021-05-18)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 19044)

Matrix products: default

locale:
[1] LC_COLLATE=English_India.1252  LC_CTYPE=English_India.1252    LC_MONETARY=English_India.1252
[4] LC_NUMERIC=C                   LC_TIME=English_India.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] DT_0.28        datamods_1.4.1 shiny_1.7.4.1 

loaded via a namespace (and not attached):
 [1] zip_2.3.0              Rcpp_1.0.11            jquerylib_0.1.4        bslib_0.5.0           
 [5] cellranger_1.1.0       compiler_4.1.0         pillar_1.9.0           later_1.3.1           
 [9] shinyWidgets_0.7.6     forcats_1.0.0          phosphoricons_0.2.0    tools_4.1.0           
[13] digest_0.6.33          memoise_2.0.1          jsonlite_1.8.7         lifecycle_1.0.3.9000  
[17] tibble_3.2.1           pkgconfig_2.0.3        rlang_1.1.1            openxlsx_4.2.5.2      
[21] cli_3.6.1              rstudioapi_0.15.0.9000 crosstalk_1.2.0        yaml_2.3.7            
[25] writexl_1.4.2          curl_5.0.1             haven_2.5.3            rio_0.5.29            
[29] fastmap_1.1.1          withr_2.5.0            sass_0.4.7             htmlwidgets_1.6.2     
[33] vctrs_0.6.3            hms_1.1.3              reactable_0.4.4        glue_1.6.2            
[37] data.table_1.14.8      R6_2.5.1               fansi_1.0.4            readxl_1.4.3          
[41] foreign_0.8-81         magrittr_2.0.3         promises_1.2.0.1       ellipsis_0.3.2        
[45] htmltools_0.5.5        rsconnect_1.0.1        mime_0.12              xtable_1.8-4          
[49] httpuv_1.6.11          utf8_1.2.3             shinybusy_0.3.1        stringi_1.7.12        
[53] cachem_1.0.8

```

Thank you for your attention to this matter.

