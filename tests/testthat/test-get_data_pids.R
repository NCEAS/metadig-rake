test_that("get_data_pids fails gracefully", {
  skip_on_cran()
  expect_error(get_data_pids("something", "urn:node:ARCTIC"))
  expect_error(get_data_pids("doi:10.18739/A2R49GB1J", "something"))
})

test_that("get_data_pids returns a list of identifiers", {
  skip_on_cran()
  # dataset with no files should still return one pid (the metadata pid)
  res <- get_data_pids("doi:10.18739/A2R49GB1J", "urn:node:ARCTIC")
  expect_equal(res, "doi:10.18739/A2R49GB1J")

  # dataset with files should return character
  res <- get_data_pids("doi:10.18739/A2W950P9J", "urn:node:ARCTIC")
  expect_type(res, "character")


})
