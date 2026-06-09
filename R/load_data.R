load_yere_data <- function(
) {
  etl_dir <- Sys.getenv(
    "FAMCARE_ETL_GOVERNED"
  )

  if (
    etl_dir == ""
  ) {
    stop(
      "Environment variable FAMCARE_ETL_GOVERNED is not set.",
      "Please define it in your .Renviron."
    )
  }
  # Load ETL helper environment (build subsets, fiscal date functions,
  #   cartography files, etc.)
  source(
    file.path(
      etl_dir,
      "etl/setup.R"
    ),
    local = environment()
  )
  
  store_path <- file.path(
    etl_dir,
    "_targets"
    )
  
  # Run tar_make() inside the ETL repo directory
  old_dir <- getwd()
  on.exit(
    setwd(
      old_dir
      ),
    add = TRUE
    )
  
  setwd(
    etl_dir
    )
  
  # Ensure ETL is up to date
  targets::tar_make(
    store = store_path
    )
  
  # Read the ETL output for BCR
  yere_data <- targets::tar_read(
    yere_etl,
    store = store_path
    )
  
  cartography_data <- targets::tar_read(
    cartography_bundle,
    store = store_path
    )

  return(
    list(
      yere_data = yere_data,
      cartography_data = cartography_data
    )
  )
}