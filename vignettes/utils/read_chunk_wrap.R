read_chunk_wrap <- function(path, ...) {
  knitr::read_chunk(path = path, lines = chunk_cpp2R(readLines(path)), ...)
}

chunk_cpp2R <- function(lines) {
  gsub("^(//)+(\\s*----+)", "#\\2", lines)
}
