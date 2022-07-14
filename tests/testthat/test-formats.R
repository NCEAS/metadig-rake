test_that("checking text formats works as expected", {

  data <- "'x','y'\r1,2\r3,4"
  csvfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".csv")
  writeLines(data, csvfile)

  expect_true(check_text_file_format(csvfile, delimiter = ",", header_lines = 1))


})
