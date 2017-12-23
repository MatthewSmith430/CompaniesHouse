# CompaniesHouse
This is an R package aimed at helping in extracting data from companies house: <https://www.gov.uk/government/organisations/companies-house>  

It particular, it provides a way to search for companies and extract a set of componay numbers. These company numbers can then be used to identify company directors.   

This package also provides functions which allow you to build a network of interlocking directors, that is a network of individuals and the companies, linked by board membership. Other networks are also created - such as director networks, this is a set of indiviudals linked by sitting on (at least one of) the same company board of directors. Company networks - a set of companies linked by having (at least one of) the same directors sitting on the board. 

## Packages
THis package is requires a number of other packages, more specifically:

```{r packages,eval=FALSE}
library(igraph)
library(tnet)
library(intergraph)
library(sna)
library(ggplot2)
library(GGally)
library(httr)
library(jsonlite)

#Install CompaniesHouse 
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
The following function allows you to search for companies in Companies House (using the API). You use the search term with your authorisation key, and it returns a list of companies that match the search term. It also give the Companies House Company number, the company address and various other information. The company number is important, as it is used to identify the firm, and is used in many of the other package functions.  
```{r CompanySearch,eval=FALSE}
CompanySearchList<-CompanySearch("COMPANY SEARCH TERM",mkey)
```

## Extract Directors Data
This function extract director information for a company numbers. Where it gives a dataframe containing a list of directors and director information for the company number.

```{r ExtractDirector,eval=FALSE}
DirectorInformation<-ExtractDirectorsData(Company.Number, mkey)

#To extract director data for a list of company numbers:
MultilpleDirectorInfo<-mapply(ExtractDirectorsData,List.of.company.numbers,mkey)
```

## Company Sector Code
This function finds the sector a company operates in - where it gives its SIC code. The function requires the company number.
```{r SIC,eval=FALSE}
CompanySIC<-CompanySIC(Company.Number, mkey)

#To extract director data for a list of company numbers:
MultilpleSIC<-mapply(CompanySIC,List.of.company.numbers,mkey)
```
## Networks
The package can be used to create a set of networks.  
- Interlocking directorates network: a set of companies and individuals, where individuals are tied to companies where they sit on the board of directors.  
- Director network: a set of directors, where they are linked if they sit on the same company board.  
- Company network: a set of companies, where they are linked if they share a director.  

### Create Networks
The follwoing functions create the various networks. Where a list of company numbers is required to create these networks.  

#### Interlocking Directorates Network
There are two ways to create the interlocking directorates network:  
1.) From a list of company numbers  
```{r INTERLOCKS1,eval=FALSE}
INTERLOCKS<-InterlockNetwork(List.of.company.numbers,mkey)
```
2.) From a data frame produced using the ExtractDirectorsData function. This dataframe can be edited manually to use company names (or perhaps another id system) in the network.  
```{r INTERLOCKS2,eval=FALSE}
INTERLOCKS2<-make_interlock(DataFrame)
```

#### Company Network
```{r COMPnet,eval=FALSE}
CompanyNET<-CompanyNetwork(List.of.company.numbers,mkey)
```
#### Director Network
```{r DIRnet,eval=FALSE}
DirNET<-DirectorNetwork(List.of.company.numbers,mkey)
```
### Network Analysis
The network(igraph object) is requried for these functions. These are calculated using the commands from the "Create Networks" section.  

#### Centrality
For each network we can calculate a range of centrality measures. THe director and company networks are one-mode networks, so a wider range of centrality measures can be calculated. 
```{r CENT,eval=FALSE}
INTERLOCKcent<-InterlockCentrality(INTERLOCKS)
COMPANYcent<-CompanyCentrality(CompanyNET)
DIRcent<-DirectorCentrality(DirNET)
```
#### Network properties
We can calculate the properties of the director and company networks.
```{r PROP,eval=FALSE}
COMPANYprop<-CompanyNetworkProperties(CompanyNET)
DIRprop<-DirectorNetworkProperties(DirNET)
```
### Plot Networks
The following function create plots of various networks. The TRUE/FALSE option indivates whether node labels should be included in the plots or not.  The network plots are created from a list of company numbers for a quick inspection of the networks. There are a number of other commands and packages that can be used to create high quality network visualsiations from the network objects in R.  

```{r pressure, eval=FALSE}
#Interlocking Directorates Plot
InterlockNetworkPLOT(List.of.company.numbers,mkey,FALSE)

#Directors Plot
DirectorNetworkPLOT(List.of.company.numbers,mkey,FALSE)

#Company Plot
CompanyNetworkPLOT(List.of.company.numbers,mkey,FALSE)
```
