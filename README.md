
<!-- README.md is generated from README.Rmd. Please edit that file -->

# recruitR <a href='https://recruitR.sportsdataverse.org/'><img src='https://raw.githubusercontent.com/sportsdataverse/recruitR/main/logo.png'  align="right" width="30%" min-width="100px" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg?style=for-the-badge)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Version-Number](https://img.shields.io/github/r-package/v/sportsdataverse/recruitR?label=recruitR&logo=R&logoColor=white&style=for-the-badge)](https://github.com/sportsdataverse/recruitR)
[![R-CMD-check](https://img.shields.io/github/workflow/status/sportsdataverse/recruitR/R-CMD-check?label=R-CMD-Check&logo=R&logoColor=white&style=for-the-badge)](https://github.com/sportsdataverse/recruitR/actions/workflows/R-CMD-check.yaml)
![Contributors](https://img.shields.io/github/contributors/sportsdataverse/recruitR?style=for-the-badge)
[![Twitter
Follow](https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=twitter&style=for-the-badge)](https://twitter.com/saiemgilani)
<!-- badges: end -->

A college football recruiting package

`recruitR` is an R package for working with college sports recruiting
data. It is an R API wrapper around
[collegefootballdata’s](https://collegefootballdata.com/) recruiting and
roster endpoints.

**Note:** For details on the data sources, please go the website linked
above. Sometimes there are inconsistencies in the underlying data
itself. Please report issues here or to
<https://collegefootballdata.com/>.

## Installation

You can install the released version of
[**`recruitR`**](https://github.com/sportsdataverse/recruitR) from
[GitHub](https://github.com/sportsdataverse/recruitR) with:

``` r
# You can install using the pacman package using the following code:
if (!requireNamespace('pacman', quietly = TRUE)){
  install.packages('pacman')
}
pacman::p_load_current_gh("sportsdataverse/recruitR")
```

``` r
# if you would prefer devtools installation
if (!requireNamespace('devtools', quietly = TRUE)){
  install.packages('devtools')
}
# Alternatively, using the devtools package:
devtools::install_github(repo = "sportsdataverse/recruitR")
```

## Offensive Tackle Example

``` r
library(recruitR)
library(dplyr)
library(ggplot2)
```

Let’s say that we are interested in seeing how many offensive tackles in
the 2020 recruiting cycle were:

-   located in Florida
-   located in the states bordering Florida
-   ranked inside the top 1000

``` r
FL_OTs <- cfbd_recruiting_player(2020, recruit_type = 'HighSchool', state='FL', position ='OT')
GA_OTs <- cfbd_recruiting_player(2020, recruit_type = 'HighSchool', state='GA', position ='OT')
AL_OTs <- cfbd_recruiting_player(2020, recruit_type = 'HighSchool', state='AL', position ='OT')
SE_OTs <- dplyr::bind_rows(FL_OTs, GA_OTs, AL_OTs)

SE_OTs_1k <- SE_OTs %>% 
  dplyr::filter(ranking < 1000) %>% 
  dplyr::arrange(ranking)

SE_OTs_1k %>% 
  dplyr::select(ranking, name, school, committed_to, position, 
         height, weight, stars, rating, city, state_province)
#> # A tibble: 20 × 11
#>    ranking name    school committed_to position height weight stars rating city 
#>      <int> <chr>   <chr>  <chr>        <chr>     <dbl>  <int> <int>  <dbl> <chr>
#>  1      11 Broder… Litho… Georgia      OT         77      298     5  0.995 Lith…
#>  2      38 Tate R… Darli… Georgia      OT         78      322     4  0.982 Rome 
#>  3      74 Myles … Great… Stanford     OT         78      308     4  0.966 Norc…
#>  4     110 Marcus… St. T… LSU          OT         77      305     4  0.952 Fort…
#>  5     128 Jalen … Oakle… Miami        OT         78      331     4  0.942 Oran…
#>  6     157 Issiah… Norla… Florida      OT         76      309     4  0.931 Miami
#>  7     271 Joshua… Suwan… Florida      OT         78      335     4  0.905 Live…
#>  8     318 Connor… Jesuit Stanford     OT         79      260     4  0.897 Tampa
#>  9     333 Javion… Centr… Alabama      OT         77      295     4  0.895 Phen…
#> 10     491 Cayden… Fort … North Carol… OT         78      260     3  0.879 Fort…
#> 11     530 Austin… South… Georgia      OT         77      278     3  0.876 Guyt…
#> 12     538 Michae… Lenna… Georgia Tech OT         77      295     3  0.876 Rusk…
#> 13     562 Jordan… Gaine… Georgia Tech OT         78      310     3  0.874 Gain…
#> 14     577 Brady … St. P… Ole Miss     OT         79      310     3  0.873 Mobi…
#> 15     614 Trey Z… Roswe… North Carol… OT         78      294     3  0.871 Rosw…
#> 16     658 Gerald… Cardi… Florida      OT         77      320     3  0.868 Fort…
#> 17     752 Jake W… Marie… Colorado     OT         77      300     3  0.864 Mari…
#> 18     934 Joshua… Centr… Kentucky     OT         76.5    304     3  0.856 Phen…
#> 19     953 Wing G… Lee C… Georgia Tech OT         79      285     3  0.855 Lees…
#> 20     971 Kobe M… Herit… Cincinnati   OT         78      275     3  0.855 Ring…
#> # … with 1 more variable: state_province <chr>
```

## Plotting the Offensive Tackles by State

You can also create a plot:

``` r
SE_OTs_1k$stars <- factor(SE_OTs_1k$stars,levels = c(5,4,3,2))

SE_OTs_1k_grp <- SE_OTs_1k %>%
  dplyr::group_by(state_province, stars) %>%
  dplyr::summarize(players = n()) %>% 
  dplyr::ungroup()

ggplot(SE_OTs_1k_grp ,aes(x = state_province, y = players, fill = factor(stars))) +
  geom_bar(stat = "identity",colour='black') +
  xlab("State") + ylab("Number of Players") +
  labs(title="Top-1000 Offensive Tackles in FL, GA, and AL - Class of 2020",
       subtitle="Figure: @SaiemGilani | Data: @CFB_data with #recruitR")+
  geom_text(aes(label = players),size = 4, position = position_stack(vjust = 0.5))+
  scale_fill_manual(values=c("dodgerblue2","lightskyblue","red3","ghostwhite"))+
  theme(legend.title = element_blank(),
        legend.text = element_text(size = 12, margin=margin(t=0.2,r=0,b=0.2,l=-1.2,unit=c("mm")), 
                                   family = "serif"),
        legend.background = element_rect(fill = "grey99"),
        legend.key.width = unit(.2,"cm"),
        legend.key.size = unit(.3,"cm"),
        legend.position = c(0.25, 0.84),
        legend.margin=margin(t = 0.4,b = 0.4,l=-1.2,r=0.4,unit=c('mm')),
        legend.direction = "horizontal",
        legend.box.background = element_rect(colour = "#500f1b"),
        axis.title.x = element_text(size = 12, margin = margin(0,0,1,0,unit=c("mm")), 
                                    family = "serif",face="bold"),
        axis.text.x = element_text(size = 10, margin=margin(0,0,1,0,unit=c("mm")),
                                   family = "serif"),
        axis.title.y = element_text(size = 12, margin = margin(0,0,0,0,unit=c("mm")), 
                                    family = "serif",face="bold"),
        axis.text.y = element_text(size = 12, margin = margin(1,1,1,1,unit=c("mm")), 
                                    family = "serif"),
        plot.title = element_text(size = 14, margin = margin(t=0,r=0,b=1.5,l=0,unit=c("mm")),
        lineheight=-0.5, family = "serif",face="bold"),
        plot.subtitle = element_text(size = 12, margin = margin(t=0,r=0,b=2,l=0,unit=c("mm")), 
                                     lineheight=-0.5, family = "serif"),
        plot.caption = element_text(size = 12, margin=margin(t=0,r=0,b=0,l=0,unit=c("mm")),
                                    lineheight=-0.5, family = "serif"),
        strip.text = element_text(size = 10, family = "serif",face="bold"),
        panel.background = element_rect(fill = "grey95"),
        plot.background = element_rect(fill = "grey85"),
        plot.margin=unit(c(top=0.4,right=0.4,bottom=0.4,left=0.4),"cm"))
```

<img src="man/figures/README-plot_OTs-1.png" width="100%" />

## **Documentation**

For more information on the package and function reference, please see
the [**`recruitR`** documentation
website](https://recruitR.sportsdataverse.org).

## **Breaking Changes**

[**Full News on
Releases**](https://recruitR.sportsdataverse.org/news/index.html)

## Follow the [SportsDataverse](https://twitter.com/SportsDataverse) on Twitter and star this repo

[![Twitter
Follow](https://img.shields.io/twitter/follow/SportsDataverse?color=blue&label=%40SportsDataverse&logo=twitter&style=for-the-badge)](https://twitter.com/SportsDataverse)

[![GitHub
stars](https://img.shields.io/github/stars/sportsdataverse/recruitR.svg?color=eee&logo=github&style=for-the-badge&label=Star%20recruitR&maxAge=2592000)](https://github.com/sportsdataverse/recruitR/stargazers/)

## **Our Authors**

-   [Saiem Gilani](https://twitter.com/saiemgilani)  
    <a href="https://twitter.com/saiemgilani" target="blank"><img src="https://img.shields.io/twitter/follow/saiemgilani?color=blue&label=%40saiemgilani&logo=twitter&style=for-the-badge" alt="@saiemgilani" /></a>
    <a href="https://github.com/saiemgilani" target="blank"><img src="https://img.shields.io/github/followers/saiemgilani?color=eee&logo=Github&style=for-the-badge" alt="@saiemgilani" /></a>

## **Citations**

To cite the [**`cfbfastR`**](https://cfbfastR.sportsdataverse.org/) R
package in publications, use:

BibTex Citation

``` bibtex
@misc{gilani_2021_recruitr,
  author = {Gilani, Saiem},
  title = {recruitR: The SportsDataverse's R Package for College Sports Recruiting Data.},
  url = {https://recruitR.sportsdataverse.org/},
  year = {2021}
}
```
