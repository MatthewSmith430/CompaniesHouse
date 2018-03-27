Companies House
================

This is an R package aimed at helping in extracting data from companies house: <https://www.gov.uk/government/organisations/companies-house>

It particular, it provides a way to search for companies and extract a set of componay numbers. These company numbers can then be used to identify company directors.

This package also provides functions which allow you to build a network of interlocking directors, that is a network of individuals and the companies, linked by board membership. Other networks are also created - such as director networks, this is a set of indiviudals linked by sitting on (at least one of) the same company board of directors. Company networks - a set of companies linked by having (at least one of) the same directors sitting on the board.

Packages
--------

This package is requires a number of other packages, more specifically:

``` r
library(igraph)
library(tnet)
library(intergraph)
library(sna)
library(ggplot2)
library(GGally)
library(httr)
library(jsonlite)
library(ITNr)

#Install CompaniesHouse:
#library(devtools)
#devtools::install_github("MatthewSmith430/CompaniesHouse")
library(CompaniesHouse)
```

Authorisation Key
-----------------

To extract data from companies house (with the API), you will need to get an authorisation key.

The instructions on how to obtain your key can be found at: <https://developer.companieshouse.gov.uk/api/docs/index/gettingStarted/apikey_authorisation.html/>

When using the package, save your key as `mkey`:

``` r
mkey<-"ENTER YOUR AUTHORISATION KEY"
```

Company Search
--------------

The following function allows you to search for companies in Companies House (using the API). You use the search term with your authorisation key, and it returns a list of companies that match the search term. It also give the Companies House Company number, the company address and various other information. The company number is important, as it is used to identify the firm, and is used in many of the other package functions.

``` r
#Search for a "COMPANY SEARCH TERM"
#In this example we use "unilever"
CompanySearchList<-CompanySearch("unilever",mkey)
head(CompanySearchList)[1:3,]
```


    ##   id.search.term                  company.name company.number
    ## 1       unilever                  UNILEVER PLC       00041424
    ## 2       unilever       UNILEVER BCS UK LIMITED       09521994
    ## 3       unilever UNILEVER BESTFOODS UK LIMITED       BR014135
    ##   Date.of.Creation     company.type company.status
    ## 1       1894-06-21              plc         active
    ## 2       2015-04-01              ltd         active
    ## 3       2009-10-01 uk-establishment         closed
    ##                                                                     address
    ## 1                               Port Sunlight, Wirral, Merseyside, CH62 4ZD
    ## 2 Unilever House, 100 Victoria Embankment, London, United Kingdom, EC4Y 0DY
    ## 3                     Unit 12 Mckinney Industrial Estate Co Antrim, Mallusk
    ##          country postcode
    ## 1           <NA> CH62 4ZD
    ## 2 United Kingdom EC4Y 0DY
    ## 3           <NA>     <NA>

Extract Directors Data
----------------------

This function extract director information for a company numbers. Where it gives a dataframe containing a list of directors and director information for the company number.

``` r
#We conintue to use Uniever as a example, we know that the company
#number for Unilever Plc is "00041424".

#Therefore we can extract the director information
#for Unilvever Plc
DirectorInformation<-ExtractDirectorsData("00041424", mkey)

head(DirectorInformation)[1:3,]
```


    ##         id                 directors start.date end.date
    ## 1 00041424            SOTAMAA, Ritva 2018-01-01     <NA>
    ## 2 00041424 ANDERSEN, Nils Smedegaard 2015-04-30     <NA>
    ## 3 00041424       CHA, Laura May Lung 2013-05-15     <NA>
    ##                          occupation      role residence postcode
    ## 1                              <NA> secretary      <NA> EC4Y 0DY
    ## 2                              None  director   Denmark  EC4 0DY
    ## 3 Deputy Chairman Hsbc Asia Pacific  director Hong Kong EC4Y 0DY
    ##          download.date
    ## 1 27/03/2018  13:13:43
    ## 2 27/03/2018  13:13:43
    ## 3 27/03/2018  13:13:43

``` r
#To extract director data for a list of company numbers - say all 
#firms associated with the Unilever search term we use:
MultilpleDirectorInfo<-mapply(ExtractDirectorsData,as.character(CompanySearchList$company.number),mkey)

#Where CompanySearchList$company.number is the list of company numbers from
#our company search dataframe. 
```

Company Sector Code
-------------------

This function finds the sector a company operates in - where it gives its SIC code. The function requires the company number.

``` r
#Again we use Unilever Plc as an example - using their company number
CompanySIC<-CompanySIC("00041424", mkey)

CompanySIC
```


    ## [1] 70100
    ## Levels: 70100

``` r
#To extract director data for a list of company numbers 
#(using again the example of all company numbers associated with 
#the Unilever search term):
MultilpleSIC<-mapply(CompanySIC,as.character(CompanySearchList$company.number),mkey)
```

Networks
--------

The package can be used to create a set of networks.
- Interlocking directorates network: a set of companies and individuals, where individuals are tied to companies where they sit on the board of directors.
- Director network: a set of directors, where they are linked if they sit on the same company board.
- Company network: a set of companies, where they are linked if they share a director.

### Create Networks

The follwoing functions create the various networks. Where a list of company numbers is required to create these networks.

#### Interlocking Directorates Network

There are two ways to create the interlocking directorates network:
1.) From a list of company numbers

``` r
INTERLOCKS1<-InterlockNetwork(List.of.company.numbers,mkey)

##Example for all company numbers associated with the 
##Unilever search term:
INTERLOCKS1<-InterlockNetwork(as.character(CompanySearchList$company.number),mkey)
```

2.) From a data frame produced using the ExtractDirectorsData function. This dataframe can be edited manually to use company names (or perhaps another id system) in the network.

``` r
INTERLOCKS2<-make_interlock(DataFrame)

##Example for all company numbers associated with the 
##Unilever search term - the dataframe created with ExtractDirectorsData
INTERLOCKS2<-make_interlock(MultilpleDirectorInfo)
```

#### Company Network

``` r
CompanyNET<-CompanyNetwork(List.of.company.numbers,mkey)

##Example for all company numbers associated with the 
##Unilever search term:
CompanyNET<-CompanyNetwork(as.character(CompanySearchList$company.number),mkey)
```

#### Director Network

``` r
DirNET<-DirectorNetwork(List.of.company.numbers,mkey)

##Example for all company numbers associated with the 
##Unilever search term:
DirNET<-DirectorNetwork(as.character(CompanySearchList$company.number),mkey)
```

### Network Analysis

The network(igraph object) is requried for these functions. These are calculated using the commands from the "Create Networks" section.

#### Centrality

For each network we can calculate a range of centrality measures. THe director and company networks are one-mode networks, so a wider range of centrality measures can be calculated.

``` r
INTERLOCKcent<-InterlockCentrality(INTERLOCKS1)
head(INTERLOCKcent)[1:3,]
```


    ##             NAMES Degree.Centrality
    ## 00041424 00041424                34
    ## 09521994 09521994                12
    ## FC024822 FC024822                21

``` r
COMPANYcent<-CompanyCentrality(CompanyNET)
head(COMPANYcent)[1:3,]
```


    ##             NAMES Weighted.Degree.All Binary.Degree.All Betweenness
    ## 00041424 00041424                   3                 2           0
    ## 00307529 00307529                   2                 2           0
    ## 00413828 00413828                  30                 8           0
    ##          Closeness Eigenvector
    ## 00041424    0.0263      0.0458
    ## 00307529    0.0312      0.0183
    ## 00413828    0.0345      0.6643

``` r
DIRcent<-DirectorCentrality(DirNET)
head(DIRcent)[1:3,]
```


    ##                                               NAMES Weighted.Degree.All
    ## ALLEN, Nicholas Graham       ALLEN, Nicholas Graham                  36
    ## ALLGROVE, Jeffrey William ALLGROVE, Jeffrey William                  43
    ## ALLISON, James Brian           ALLISON, James Brian                  20
    ##                           Binary.Degree.All Betweenness Closeness
    ## ALLEN, Nicholas Graham                   29     21.4444    0.0033
    ## ALLGROVE, Jeffrey William                39     68.5333    0.0034
    ## ALLISON, James Brian                     20      0.0000    0.0029
    ##                           Eigenvector
    ## ALLEN, Nicholas Graham         0.2829
    ## ALLGROVE, Jeffrey William      0.3694
    ## ALLISON, James Brian           0.1837

#### Network properties

We can calculate the properties of the director and company networks.

``` r
COMPANYprop<-CompanyNetworkProperties(CompanyNET)
head(COMPANYprop)
```


    ##                       One-Mode Company Network
    ## id                    One-Mode Company network
    ## Size                                        13
    ## Density                              0.5128205
    ## Diameter                                     5
    ## Average.path.lenth                    1.409091
    ## Average.node.stregnth                 22.33333

``` r
DIRprop<-DirectorNetworkProperties(DirNET)
head(DIRprop)
```


    ##                       One-Mode Director Network
    ## Size                                   151.0000
    ## Density                                  0.1890
    ## Diameter                                 4.0000
    ## Average.path.lenth                       2.1579
    ## Average.node.stregnth                   31.2800
    ## Average.Degree                          28.5333

### Plot Networks

The following function create plots of various networks. The TRUE/FALSE option indivates whether node labels should be included in the plots or not. The network plots are created from a list of company numbers for a quick inspection of the networks. There are a number of other commands and packages that can be used to create high quality network visualsiations from the network objects in R. You can also specify the node size - with the default being size 6. In the following examples we use the default.

``` r
#Interlocking Directorates Plot
InterlockNetworkPLOT(as.character(CompanySearchList$company.number),mkey,FALSE,NodeSize = 6)
```

![](README_files/figure-markdown_github/ploti-1.png)

``` r
#Directors Plot
DirectorNetworkPLOT(as.character(CompanySearchList$company.number),mkey,FALSE,NodeSize = 6)
```


![](README_files/figure-markdown_github/plotd-1.png)

``` r
#Company Plot
CompanyNetworkPLOT(as.character(CompanySearchList$company.number),mkey,FALSE,NodeSize = 6)
```


![](README_files/figure-markdown_github/plotc-1.png)

You can also create grid plots - showing a plot of all three networks on a single grid using the `cowplot` library. In the example below we plot the networks in a grid, setting node size to degree centrality.

``` r
##Load cowplot library
library(cowplot)

##Create plot objects with node size based on centrality
interlock.plot<-InterlockNetworkPLOT(as.character(CompanySearchList$company.number),
                                     mkey,FALSE,NodeSize = "CENTRALITY")
director.plot<-DirectorNetworkPLOT(as.character(CompanySearchList$company.number),
                                   mkey,FALSE,NodeSize = "CENTRALITY")
company.plot<-CompanyNetworkPLOT(as.character(CompanySearchList$company.number), 
                                 mkey,FALSE,NodeSize = "CENTRALITY")

##Plot as a grid
plot_grid(interlock.plot,director.plot,company.plot,
          labels=c("Interlocks","Directors","Companies"))
```


![](README_files/figure-markdown_github/COWplot-1.png)
