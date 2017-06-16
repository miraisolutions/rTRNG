## TRNG kind of the current engine
TRNGkind()
## set a specific TRNG kind
TRNGkind("yarn5s")
TRNGkind()
\dontrun{
  ## error if kind is not valid
  TRNGkind("invalid")
}
## set the deafult TRNG kind
TRNGkind("default")
TRNGkind()

## seed the current random number engine
TRNGset.seed(117)

## full representation of the current state of the engine in use
s <- TRNG.Random.seed()
s

## draw 10 random variates using the current engine
runif_trng(10)

## restore the engine and its internal state
TRNG.Random.seed(s)

## jump and draw the last 3 variates out of the 10 above
TRNGjump(7) # jump 7 steps ahead
runif_trng(3)

## restore the internal state, split and draw every 5th element starting from
## the 2nd
TRNG.Random.seed(s)
TRNGsplit(5, 2)
runif_trng(2)

## TRNGseed, TRNGjump and TRNGsplit can be combined with r<dist>_trng in c(...)
## as they return NULL
c(TRNGset.seed(117),
  TRNGjump(2), runif_trng(2),
  TRNGsplit(3,2), runif_trng(2))
