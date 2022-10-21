#' Read 2d fields from the MET Norway 1km Nordic Analysis
#'
#' Calls read_analysis from harpIO with paths for the MET analysis.
#'
#' @param date_times A vector of date time strings to read. Can be in YYYYMMDD,
#'   YYYYMMDDhh, YYYYMMDDhhmm, or YYYYMMDDhhmmss format. Can be numeric or
#'   character. If date_times is not NULL, start_date, end_date and by are
#'   ignored.
#' @param parameter The name of the forecast parameter(s) to read from the
#'   files. Should either be harp parameter names (see show_harp_parameters), or
#'   in the case of netcdf files can be the name of the parameters in the files.
#' @param transformation The transformation to apply to 2d fields. Can be
#'   "interpolate" to interpolate to long-lat locations, "regrid" to regrid the
#'   2d field to a new grid and/or projection, "xsection" to extract a vertical
#'   cross section or "subgrid" to take a subset of the input grid.
#' @param transformation_opts Options for the different transformations. See
#'   \link[harpIO]{interpolate_opts} for functions to generate options
#'   appropriate to the selected transformation.
#' @param return_data Whether to return the data to session. Set to TRUE by
#'   default unlike \link[harpIO]{read_analysis}. Be careful setting this to
#'   TRUE as it can result in running out of memory.
#' @param show_progress Whether to show progress reading the data.
#'
#' @return a harp_analysis object for met_analysis
#' @export
#'
#' @examples
#' library(harpIO)
#' read_met_analysis(
#'   seq_dates(2022081612, 2022081615, "1h"),
#'   "Pcp"
#' )
#'
#' read_met_analysis(
#'   seq_dates(2022081612, 2022081615, "1h"),
#'   "T2m"
#' )

read_met_analysis <- function(
  date_times,
  parameter,
  transformation = c("none", "interpolate", "regrid", "xsection", "subgrid"),
  transformation_opts = NULL,
  return_data = TRUE,
  show_progress = TRUE
) {

  transformation = match.arg(transformation)

  ma_path = "/lustre/storeB/immutable/archive/projects/metproduction/yr_short"
  ma_template = "{YYYY}/{MM}/{DD}/met_analysis_1_0km_nordic_{YYYY}{MM}{DD}T{HH}Z.nc"
  ma_opts = harpIO::netcdf_opts(proj4_var = "projection_lcc")

  if (tolower(parameter) == "pcp") {
    pcp_name  <- parameter
    parameter <- "precipitation_amount"
  }

  res <- harpIO::read_analysis(
    date_times          = date_times,
    analysis_model      = "met_analysis",
    parameter           = parameter,
    file_path           = ma_path,
    file_template       = ma_template,
    file_format_opts    = ma_opts,
    transformation      = transformation,
    transformation_opts = transformation_opts,
    return_data         = return_data,
    show_progress       = show_progress
  )

  if (exists("pcp_name")) {
    res[[1]] <- dplyr::mutate(res[[1]], parameter = pcp_name)
  }

  res

}
