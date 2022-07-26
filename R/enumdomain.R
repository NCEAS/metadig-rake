#add documentation

#read in a data file
#grab unique values from the column name given
#grab enumerated domain from the att name given
#run setdiff, print the diff

check_enum_elems <- function(fileName, columnName, tableName){
  #if 1 dt in dataset
  #write code for no dataTable index needed

  #if greater than one dt in dataset, only works for csvs at the moment
  data_pid <- selectMember(dp, name = "sysmeta@fileName", value = fileName)
  file <- read.csv(text=rawToChar(getObject(d1c@mn, data_pid))) #expand for all data file types
  unique_column_vals <- unique(file$columnName)
  dt_n <- which_in_eml(doc$dataset$dataTable, "entityName", tableName)
  att_n <- which_in_eml(doc$dataset$dataTable[[dt_n]]$attributeList$attribute, "attributeName", columnName)
  enum_domain_vals <- c()
  for (i in seq_along(doc$dataset$dataTable[[dt_n]]$attributeList$attribute[[att_n]]$measurementScale$nominal$nonNumericDomain$enumeratedDomain$codeDefinition)) {
    enum_domain_vals[[i]] <- paste(doc$dataset$dataTable[[dt_n]]$attributeList$attribute[[att_n]]$measurementScale$nominal$nonNumericDomain$enumeratedDomain$codeDefinition[[i]]$code)
  }
  results1 <- setdiff(unique_column_vals, enum_domain_vals) #in column but not in enum
  results2 <- setdiff(enum_domain_vals, unique_column_vals) #in enum but not in column
  print("The values in the data column but not in the enumeratedDomain are:", results1)
  print("The values in the enumeratedDomain but not in the data column are:", results2)
  #make sure to eventually add something to return SUCCESS/TRUE vs FAILURE/FALSE vs ERROR
  #maybe add a case if there's only one attribute in the dataset with that name, you don't need to provide the entity name,
  #or it checks all attributes by that name in the dataset
}
