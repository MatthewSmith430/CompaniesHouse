# CompaniesHouse
This is an R package aimed at helping in extracting data from companies house: <https://www.gov.uk/government/organisations/companies-house>  

It particular, it provides a way to search for companies and extract a set of componay numbers. These company numbers can then be used to identify company directors.   

This package also provides functions which allow you to build a network of interlocking directors, that is a network of individuals and the companies, linked by board membership. Other networks are also created - such as director networks, this is a set of indiviudals linked by sitting on (at least one of) the same company board of directors. Company networks - a set of companies linked by having (at least one of) the same directors sitting on the board. 

## Packages
This package is requires a number of other packages, more specifically:

```{r packages,eval=FALSE}
library(igraph)
library(tnet)
library(intergraph)
library(sna)
library(ggplot2)
library(GGally)
library(httr)
library(jsonlite)

#Install CompaniesHouse:
#library(devtools)
#devtools::install_github("MatthewSmith430/CompaniesHouse")
library(CompaniesHouse)
```

## Authorisation Key
To extract data from companies house (with the API), you will need to get an authorisation key.  

The instructions on how to obtain your key can be found at:
<https://developer.companieshouse.gov.uk/api/docs/index/gettingStarted/apikey_authorisation.html/>  

When using the package, save your key as `mkey`:  
```{r mkey,eval=FALSE}
mkey<-"ENTER YOUR AUTHORISATION KEY"
```

## Company Search
The following function allows you to search for companies in Companies House (using the API). You use the search term with your authorisation key, and it returns a list of companies that match the search term. It also give the Companies House Company number, the company address and various other information. The company number is important, as it is used to identify the firm, and is used in many
