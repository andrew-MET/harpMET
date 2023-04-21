#' Read forecast data from MEPS
#'
#' Calls read_forecast from harpIO with paths for MEPS.
#'
#' @param dttm A vector of date time strings to read. Can be in YYYYMMDD,
#'   YYYYMMDDhh, YYYYMMDDhhmm, or YYYYMMDDhhmmss format. Can be numeric or
#'   character.
#' @param parameter The name of the forecast parameter(s) to read from the
#'   files. Should either be harp parameter names (see show_harp_parameters), or
#'   in the case of netcdf files can be the name of the parameters in the files.
#'   If reading from vfld files, set to NULL to read all parameters.
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
read_meps <- function(
  dttm,
  parameter,
  lead_time = seq(0, 66, 3),
  members   = NULL,
  vertical_coordinate = c("pressure", "model", "height", NA),
  transformation = c("none", "interpolate", "regrid", "xsection", "subgrid"),
  transformation_opts = NULL,
  output_file_opts = harpIO::sqlite_opts(),
  return_data = TRUE,
  show_progress = TRUE
) {

  vertical_coordinate <- match.arg(vertical_coordinate)
  transformation <- match.arg(transformation)

  meps_path <- "/lustre/storeB/immutable/archive/projects/metproduction/meps"
  meps_template <- "{YYYY}/{MM}/{DD}/meps_lagged_6_h_subset_2_5km_{YYYY}{MM}{DD}T{HH}Z.nc"
  meps_opts <- harpIO::netcdf_opts("met_norway_eps")

  harpIO::read_forecast(
    dttm                = dttm,
    fcst_model          = "meps",
    parameter           = parameter,
    lead_time           = lead_time,
    members             = members,
    vertical_coordinate = vertical_coordinate,
    file_path           = meps_path,
    file_template       = meps_template,
    file_format_opts    = meps_opts,
    transformation      = transformation,
    transformation_opts = transformation_opts,
    output_file_opts    = output_file_opts,
    return_data         = return_data,
    show_progress       = show_progress
  )
}
