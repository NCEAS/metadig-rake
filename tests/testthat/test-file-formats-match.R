test_that("file formats match from path and from file", {
  skip_on_cran()
  data_path <- "https://arcticdata.io/metacat/d1/mn/v2/object/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"
  sys_path <- "https://arcticdata.io/metacat/d1/mn/v2/meta/urn:uuid:f4d6ffc1-9fc0-428e-ba7c-c99ff27922f3"

  tp <- tempfile(fileext = ".csv")
  utils::download.file(data_path, tp)
  ts <- tempfile()
  utils::download.file(sys_path, ts)

  expect_true(check_file_format_matches(tp, ts))

  tp <- "not/a/path.csv"
  expect_error(check_file_format_matches(tp, ts))
})

test_that("false is returned when formats do not match", {

  data_path <- system.file("extdata/test.csv", package = "metarake")
  sys_path <- system.file("extdata/sysmeta.xml", package = "metarake")

  x <- XML::xmlParseDoc(sys_path)
  sys <- new("SystemMetadata")
  sys <- datapack::parseSystemMetadata(sys, XML::xmlRoot(x))
  sys@formatId <- "text/plain"
  doc <- datapack::serializeSystemMetadata(sys, version = "v2")
  fs <- tempfile()
  writeLines(doc, fs)

  expect_false(check_file_format_matches(data_path, fs))
})
