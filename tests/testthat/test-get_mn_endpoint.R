test_that("production endpoint can be retrieved", {
  skip_on_cran()
  endpoint <- get_mn_endpoint("urn:node:ARCTIC")

  t <- httr::GET(endpoint)
  expect_equal(t$status_code,200)

  endpoint <- get_mn_endpoint("urn:node:KNB")

  t <- httr::GET(endpoint)
  expect_equal(t$status_code,200)
})

test_that("staging endpoint can be retrieved", {
  skip_on_cran()
  endpoint <- get_mn_endpoint("urn:node:mnTestARCTIC")

  t <- httr::GET(endpoint)
  expect_equal(t$status_code,200)
})
