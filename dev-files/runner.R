txronaparser::nuke_content(TRUE)
devtools::document()
devtools::document()
devtools::install()
txronaparser::bootstrap()

txronaparser::reload_data_remote()
rm(all_data)


# print(fs::dir_ls(trp_config$working_directory, recurse = TRUE))
# txronaparser::reload_data_remote()

# txronaparser:::load_all_spreadsheet_data()
#
# # data_name_to_save <- names(all_data$raw)[1]
# # txronaparser::save_single_data_local(
# #   data_name_to_save,
# #   all_data$raw[[data_name_to_save]],
# #   "raw"
# # )
# # txronaparser::save_data_list_local(all_data[["raw"]], "raw")
# txronaparser::save_all_data_local()
#
# rm(all_data)
#
# # reloaded <- txronaparser::load_single_data_local(
# #   data_name_to_save,
# #   "raw"
# # )
# # reloaded <- txronaparser::load_data_list_local("raw")
