% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/doc_download_function.R
\name{doc_download}
\alias{doc_download}
\title{Document Download}
\usage{
doc_download(doc_id, mkey, dl_loc, filename, doc_type)
}
\arguments{
\item{doc_id}{Document number}

\item{mkey}{Authorisation key}

\item{dl_loc}{The location you want to download the file to, ending in a \code{'/'}. Directories will
be created recursively if they don't exist}

\item{filename}{The name you want to give the file}

\item{doc_type}{The filetype of the document. Should be one of \code{'application/pdf'},
\code{'application/json'}, \code{'application/xml'}, \code{'application/xhtml+xml'} or \code{'text/csv'}}
}
\value{
Downloads the file to the location specified in the specified format. Expect warning messages for directories that exist
}
\description{
This function downloads a file to the specified location. It's a wrapper for
\code{download.file} and helps extract lots of files into ordered directory trees.
Use with \code{doc_meta_extract} and \code{doc_getlink} for best results.
}
