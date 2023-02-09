test_that("file formats match from path and from file", {

  data_path <- "https://arcticdata.io/metacat/d1/mn/v2/object/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"
  sys_path <- "https://arcticdata.io/metacat/d1/mn/v2/meta/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"
  expect_true(check_file_format_matches(data_path, sys_path))

  tp <- tempfile()
  utils::download.file(data_path, tp, ext = ".csv")
  ts <- tempfile()
  utils::download.file(sys_path, ts)

  expect_true(check_file_format_matches(tp, ts))

  tp <- "not/a/path.csv"
  expect_error(check_file_format_matches(tp, ts))
})

test_that("false is returned when formats do not match", {

  sys_path <- "https://arcticdata.io/metacat/d1/mn/v2/meta/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"
  data_path <- "https://arcticdata.io/metacat/d1/mn/v2/object/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"

  ts <- tempfile()
  utils::download.file(sys_path, ts)

  x <- XML::xmlParseDoc(ts)
  sys <- new("SystemMetadata")
  sys <- datapack::parseSystemMetadata(sys, XML::xmlRoot(x))
  sys@formatId <- "text/plain"
  doc <- datapack::serializeSystemMetadata(sys)
  fs <- tempfile()
  writeLines(doc, fs)

  expect_false(check_file_format_matches(data_path, fs))
})
