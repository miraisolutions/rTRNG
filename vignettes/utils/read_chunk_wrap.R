read_chunk_wrap <- function(...) {
  .sep.label_0 <- knitr:::.sep.label
  on.exit(assignInNamespace(".sep.label", .sep.label_0 ,"knitr"))
  assignInNamespace(".sep.label",
                    sub("^\\^#\\+", "^[#/]+", .sep.label_0),
                    "knitr")
  knitr::read_chunk(...)
}
