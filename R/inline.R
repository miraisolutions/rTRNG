# Inline plugin used by sourceCpp.
inlineCxxPlugin <- Rcpp::Rcpp.plugin.maker(
  libs = rTRNGLdFlags(),
  package = "rTRNG"
)
