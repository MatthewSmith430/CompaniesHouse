Companies House
================

**NOTE: README TO BE UPDATED SOON - THERE HAVE BEEN CHANGES TO THE FUNCTION NAMES ETC.** 

This is an R package aimed at helping in extracting data from companies house: <https://www.gov.uk/government/organisations/companies-house>

It particular, it provides a way to search for companies and extract a set of company numbers. These company numbers can then be used to identify company directors.

This package also provides functions which allow you to build a network of interlocking directors, that is a network of individuals and the companies, linked by board membership. Other networks are also created - such as director networks, this is a set of individuals linked by sitting on (at least one of) the same company board of directors. Company networks - a set of companies linked by having (at least one of) the same directors sitting on the board.


Authorisation Key
-----------------

To extract data from companies house (with the API), you will need to get an authorisation key.

The instructions on how to obtain your key can be found at: <https://developer.companieshouse.gov.uk/api/docs/index/gettingStarted/apikey_authorisation.html/>

When using the package, save your key as `mkey`:

``` r
mkey<-"ENTER YOUR AUTHORISATION KEY"
```
