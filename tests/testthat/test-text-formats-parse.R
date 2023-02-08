test_that("checking text formats works as expected", {
  # csv with one header line of column names
  data <- "'x','y'\r1,2\r3,4"
  csvfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".csv")
  writeLines(data, csvfile)

  expect_true(check_text_file_parsable(csvfile, delimiter = ",", header_lines = 1))

  # csv with two header lines
  data <- "'extra header line'\r'x','y'\r1,2\r3,4"
  csvfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".csv")
  writeLines(data, csvfile)

  expect_true(check_text_file_parsable(csvfile, delimiter = ",", header_lines = 2))

  # no header lines
  data <- "1,2\r3,4"
  csvfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".csv")
  writeLines(data, csvfile)

  expect_true(check_text_file_parsable(csvfile, delimiter = ",", header_lines = 0))

  # semi colon delimited
  data <- "'x';'y'\r1;2\r3;4"
  csvfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".csv")
  writeLines(data, csvfile)

  expect_true(check_text_file_parsable(csvfile, delimiter = ";", header_lines = 1))

  # inconsistent delimiter
  data <- "'x' 'y'\r1,2\r3 4"
  csvfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".csv")
  writeLines(data, csvfile)

  expect_false(check_text_file_parsable(csvfile, delimiter = ",", header_lines = 1))

})
