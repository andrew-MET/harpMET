#' Read ensemble forecast data from the ALERTNESS project
#'
#' Calls read_forecast from harpIO with paths for Alertness experiments.
#'
#' @param date_times A vector of date time strings to read. Can be in YYYYMMDD,
#'   YYYYMMDDhh, YYYYMMDDhhmm, or YYYYMMDDhhmmss format. Can be numeric or
#'   character. If date_times is not NULL, start_date, end_date and by are
#'   ignored.
#' @param parameter The name of the forecast parameter(s) to read from the
#'   files. Should either be harp parameter names (see show_harp_parameters), or
#'   in the case of netcdf files can be the name of the parameters in the files.
#'   If reading from vfld files, set to NULL to read all parameters.
#' @param file_type Which type of file to read from: "fp" for atmospheric data
#'   that have been through the 'fullpos' processing (most useful data are in
#'   here), "full" for raw output on model levels (and some other stuff), "sfx"
#'   for output from SURFEX and "sfx_full" for full output from surfex.
#' @param experimnet The Alertness experiment
#' @param lead_time A vector of lead times to read
#' @param members A vector of members to read
#' @param vertical_coordinate The vertical co-ordinate for upper air parameters.
#'   Can be "pressure", "model", or "height".
#' @param transformation The transformation to apply to 2d fields. Can be
#'   "interpolate" to interpolate to long-lat locations, "regrid" to regrid the
#'   2d field to a new grid and/or projection, "xsection" to extract a vertical
#'   cross section or "subgrid" to take a subset of the input grid.
#' @param transformation_opts Options for the different transformations. See
#'   \link[harpIO]{interpolate_opts} for functions to generate options
#'   appropriate to the selected transformation.
#' @param output_file_opts Options for outputting. Currently only available for
#'   \code{transformation = "interpolate"} outputting as SQLite format. See
#'   \link[harpIO]{sqlite_opts} for functions to generate options.
#' @param return_data Whether to return the data to session. Set to TRUE by
#'   default unlike \link[harpIO]{read_forecast}. Be careful setting this to
#'   TRUE as it can result in running out of memory.
#' @param show_progress Whether to show progress reading the data.
#'
#' @return a harp_fcst object for MEPS
#' @export
#'
#' @examples
#' read_meps(
#'   2022042600,
#'   "T2m",
#'   lead_time = c(0, 10),
#'   members = c(0, 14),
#'   return_data = TRUE
#' )
read_alertness <- function(
  date_times,
  parameter,
  file_type = c("fp", "full", "sfx", "sfx_full"),
  experiment = c("REF", "SPP", "REF43", "EDA43", "TSSTP", "TSSTP_weekly_pert", "REF_SST"),
  lead_time = seq(0, 48, 3),
  members   = NULL,
  vertical_coordinate = c("pressure", "model", "height", NA),
  transformation = c("none", "interpolate", "regrid", "xsection", "subgrid"),
  transformation_opts = NULL,
  output_file_opts = harpIO::sqlite_opts(),
  return_data = TRUE,
  show_progress = TRUE
) {

  file_type <- match.arg(file_type)
  file_type <- paste0("_", file_type)
  if (file_type == "_full") file_type <- ""
  experiment <- match.arg(experiment)
  fcst_model <- gsub("[[:digit:]]+", "", experiment)
  vertical_coordinate <- match.arg(vertical_coordinate)
  transformation <- match.arg(transformation)

  alert_path <- file.path(
    "/lustre/storeB/project/nwp/alertness/wp4", experiment, "netcdf"
  )
  alert_template <- paste0("fc{YYYY}{MM}{DD}{HH}", file_type, ".nc")
  alert_opts <- harpIO::netcdf_opts("met_norway_eps")

  harpIO::read_forecast(
    date_times          = date_times,
    fcst_model          = fcst_model,
    parameter           = parameter,
    lead_time           = lead_time,
    members             = members,
    vertical_coordinate = vertical_coordinate,
    file_path           = alert_path,
    file_template       = alert_template,
    file_format_opts    = alert_opts,
    transformation      = transformation,
    transformation_opts = transformation_opts,
    output_file_opts    = output_file_opts,
    return_data         = return_data,
    show_progress       = show_progress
  )
}
