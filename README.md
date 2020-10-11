Companies House
================

This is an R package aimed at helping in extracting data from companies
house: <https://www.gov.uk/government/organisations/companies-house>

It particular, it provides a way to search for companies and extract a
set of company numbers. These company numbers can then be used to
identify company directors.

This package also provides functions which allow you to build a network
of interlocking directors, that is a network of individuals and the
companies, linked by board membership. Other networks are also created -
such as director networks, this is a set of individuals linked by
sitting on (at least one of) the same company board of directors.
Company networks - a set of companies linked by having (at least one of)
the same directors sitting on the board.

To install follow these steps

``` r
#Install CompaniesHouse:
library(devtools)
devtools::install_github("MatthewSmith430/CompaniesHouse")
library(CompaniesHouse)
```

## Authorisation Key

To extract data from companies house (with the API), you will need to
get an authorisation key.

The instructions on how to obtain your key can be found at:
<https://developer.companieshouse.gov.uk/api/docs/index/gettingStarted/apikey_authorisation.html/>

When using the package, save your key as `mkey`:

``` r
mkey<-"ENTER YOUR AUTHORISATION KEY"
```

## Company Search

The following function allows you to search for companies in Companies
House (using the API). You use the search term with your authorisation
key, and it returns a list of companies that match the search term. It
also give the Companies House Company number, the company address and
various other information. The company number is important, as it is
used to identify the firm, and is used in many of the other package
functions. There are three versions for this command:  
1\. `CompanySearch_limit_first` This returns the first company from the
search results  
2\. `CompanySearch_limit` This return the first page of search results  
3\. `CompanySearch` This returns all search results

In the following example I will use `CompanySearch_limit` (yet I will
only display the first three results to save space)

``` r
#Search for a "COMPANY SEARCH TERM"
#In this example we use "unilever"

CompanySearchList<-CompanySearch_limit("unilever",mkey)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

id.search.term

</th>

<th style="text-align:left;">

company.name

</th>

<th style="text-align:left;">

company.number

</th>

<th style="text-align:left;">

Date.of.Creation

</th>

<th style="text-align:left;">

company.type

</th>

<th style="text-align:left;">

company.status

</th>

<th style="text-align:left;">

address

</th>

<th style="text-align:left;">

Locality

</th>

<th style="text-align:left;">

postcode

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

unilever

</td>

<td style="text-align:left;">

UNILEVER PLC

</td>

<td style="text-align:left;">

00041424

</td>

<td style="text-align:left;">

1894-06-21

</td>

<td style="text-align:left;">

plc

</td>

<td style="text-align:left;">

active

</td>

<td style="text-align:left;">

Port Sunlight, Wirral, Merseyside, CH62 4ZD

</td>

<td style="text-align:left;">

Merseyside

</td>

<td style="text-align:left;">

CH62 4ZD

</td>

</tr>

<tr>

<td style="text-align:left;">

unilever

</td>

<td style="text-align:left;">

UNILEVER AUSTRALIA INVESTMENTS LIMITED

</td>

<td style="text-align:left;">

00137659

</td>

<td style="text-align:left;">

1914-09-12

</td>

<td style="text-align:left;">

ltd

</td>

<td style="text-align:left;">

active

</td>

<td style="text-align:left;">

Unilever House, 100 Victoria Embankment, London, EC4Y 0DY

</td>

<td style="text-align:left;">

London

</td>

<td style="text-align:left;">

EC4Y 0DY

</td>

</tr>

<tr>

<td style="text-align:left;">

unilever

</td>

<td style="text-align:left;">

UNILEVER AUSTRALIA PARTNERSHIP LIMITED

</td>

<td style="text-align:left;">

00315312

</td>

<td style="text-align:left;">

1936-06-17

</td>

<td style="text-align:left;">

ltd

</td>

<td style="text-align:left;">

active

</td>

<td style="text-align:left;">

Unilever House, 100 Victoria Embankment, London, EC4Y 0DY

</td>

<td style="text-align:left;">

London

</td>

<td style="text-align:left;">

EC4Y 0DY

</td>

</tr>

</tbody>

</table>

## Extract Directors Data

This function extracts director information for a company numbers. Where
it gives a dataframe containing a list of directors and director
information for the company number. In this example, I will ouput a
small selection of the directors from Unilever Plc.

``` r
#We conintue to use Uniever as a example, we know that the company
#number for Unilever Plc is "00041424".

#Therefore we can extract the director information
#for Unilvever Plc
DirectorInformation<-company_ExtractDirectorsData("00041424", mkey)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

company.id

</th>

<th style="text-align:left;">

director.id

</th>

<th style="text-align:left;">

directors

</th>

<th style="text-align:left;">

start.date

</th>

<th style="text-align:left;">

end.date

</th>

<th style="text-align:left;">

occupation

</th>

<th style="text-align:left;">

role

</th>

<th style="text-align:left;">

residence

</th>

<th style="text-align:left;">

postcode

</th>

<th style="text-align:left;">

nationality

</th>

<th style="text-align:right;">

birth.year

</th>

<th style="text-align:right;">

birth.month

</th>

<th style="text-align:left;">

former.name

</th>

<th style="text-align:left;">

download.date

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

00041424

</td>

<td style="text-align:left;">

i-a1nTc06VZikEBTLGW9DYwuANM

</td>

<td style="text-align:left;">

SOTAMAA, Ritva

</td>

<td style="text-align:left;">

2018-01-01

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

secretary

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

EC4Y 0DY

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NULL

</td>

<td style="text-align:left;">

2020-10-11

</td>

</tr>

<tr>

<td style="text-align:left;">

00041424

</td>

<td style="text-align:left;">

ZI4TtLjPrlcnIckJGNlqCLV2s\_Y

</td>

<td style="text-align:left;">

ANDERSEN, Nils Smedegaard

</td>

<td style="text-align:left;">

2015-04-30

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

None

</td>

<td style="text-align:left;">

director

</td>

<td style="text-align:left;">

Denmark

</td>

<td style="text-align:left;">

EC4 0DY

</td>

<td style="text-align:left;">

Danish

</td>

<td style="text-align:right;">

1958

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:left;">

NULL

</td>

<td style="text-align:left;">

2020-10-11

</td>

</tr>

<tr>

<td style="text-align:left;">

00041424

</td>

<td style="text-align:left;">

E3FTMwTYyFn9\_AXshohmRCws23c

</td>

<td style="text-align:left;">

CHA, Laura May Lung

</td>

<td style="text-align:left;">

2013-05-15

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Deputy Chairman Hsbc Asia Pacific

</td>

<td style="text-align:left;">

director

</td>

<td style="text-align:left;">

Hong Kong

</td>

<td style="text-align:left;">

EC4Y 0DY

</td>

<td style="text-align:left;">

Chinese

</td>

<td style="text-align:right;">

1949

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:left;">

NULL

</td>

<td style="text-align:left;">

2020-10-11

</td>

</tr>

</tbody>

</table>

\#\#Company Sector Code  
This function finds the sector a company operates in - where it gives
its SIC code. The function requires the company number.

``` r
#Again we use Unilever Plc as an example - using their company number
CompanySIC<-CompanySIC("00041424", mkey)

CompanySIC
```

    ## No encoding supplied: defaulting to UTF-8.

<table>

<thead>

<tr>

<th style="text-align:left;">

x

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

70100

</td>

</tr>

</tbody>

</table>

## Director Information

In `CompaniesHouse` you can also examine the boards that a director sits
on, if you have the director id.
