% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_alertness.R
\name{read_alertness}
\alias{read_alertness}
\title{Read ensemble forecast data from the ALERTNESS project}
\usage{
read_alertness(
  dttm,
  parameter,
  file_type = c("fp", "full", "sfx", "sfx_full"),
  experiment = c("REF", "SPP", "REF43", "EDA43", "TSSTP", "TSSTP_weekly_pert", "REF_SST",
    "OP_SST"),
  lead_time = seq(0, 48, 3),
  members = NULL,
  vertical_coordinate = c("pressure", "model", "height", NA),
  transformation = c("none", "interpolate", "regrid", "xsection", "subgrid"),
  transformation_opts = NULL,
  output_file_opts = harpIO::sqlite_opts(),
  return_data = TRUE,
  show_progress = TRUE
)
}
\arguments{
\item{dttm}{A vector of date time strings to read. Can be in YYYYMMDD,
YYYYMMDDhh, YYYYMMDDhhmm, or YYYYMMDDhhmmss format. Can be numeric or
character.}

\item{parameter}{The name of the forecast parameter(s) to read from the
files. Should either be harp parameter names (see show_harp_parameters), or
in the case of netcdf files can be the name of the parameters in the files.
If reading from vfld files, set to NULL to read all parameters.}

\item{file_type}{Which type of file to read from: "fp" for atmospheric data
that have been through the 'fullpos' processing (most useful data are in
here), "full" for raw output on model levels (and some other stuff), "sfx"
for output from SURFEX and "sfx_full" for full output from surfex.}

\item{lead_time}{A vector of lead times to read}

\item{members}{A vector of members to read}

\item{vertical_coordinate}{The vertical co-ordinate for upper air parameters.
Can be "pressure", "model", or "height".}

\item{transformation}{The transformation to apply to 2d fields. Can be
"interpolate" to interpolate to long-lat locations, "regrid" to regrid the
2d field to a new grid and/or projection, "xsection" to extract a vertical
cross section or "subgrid" to take a subset of the input grid.}

\item{transformation_opts}{Options for the different transformations. See
\link[harpIO]{interpolate_opts} for functions to generate options
appropriate to the selected transformation.}

\item{output_file_opts}{Options for outputting. Currently only available for
\code{transformation = "interpolate"} outputting as SQLite format. See
\link[harpIO]{sqlite_opts} for functions to generate options.}

\item{return_data}{Whether to return the data to session. Set to TRUE by
default unlike \link[harpIO]{read_forecast}. Be careful setting this to
TRUE as it can result in running out of memory.}

\item{show_progress}{Whether to show progress reading the data.}

\item{experimnet}{The Alertness experiment}
}
\value{
a harp_fcst object for MEPS
}
\description{
Calls read_forecast from harpIO with paths for Alertness experiments.
}
\examples{
read_meps(
  2022042600,
  "T2m",
  lead_time = c(0, 10),
  members = c(0, 14),
  return_data = TRUE
)
}
