## Class yarn2 used in the examples below can be replaced by any other TRNG
## engine class (only of a parallel kind for jump and split examples).

## basic constructor with default internal state (and parameters)
r <- yarn2$new()
## show the internal parameters and state
r
## return internal parameters and state as character string
r$toString()

## seed the random number engine
r$seed(117)
r
## construct with given initial seed
s <- yarn2$new(117)
all.equal(s$toString(), r$toString())

## construct from string representation
s <- yarn2$new(r$toString()) # implicitly creates a copy
all.equal(s$toString(), r$toString())
s <- yarn2$new("") # same as yarn2$new()
all.equal(s$toString(), yarn2$new()$toString())
\dontrun{
  ## error if the string is not a valid representation
  s <- yarn2$new("invalid")
}

## copy vs. reference
r_ref <- r # reference to the same engine object
r_cpy <- r$copy() # copy an engine
all.equal(r_cpy$toString(), r$toString())
rbind(c(runif.trng(4, engine = r), runif.trng(6, engine = r_ref)),
      runif.trng(10, engine = r_cpy))

## jump (and draw from reference)
runif.trng(10, engine = r_cpy)
r_ref$jump(7) # jump 7 steps ahead
runif.trng(3, engine = r) # jump has effect on the original r


## split
r_cpy <- r$copy()
runif.trng(10, engine = r)
r_cpy$split(5, 2) # every 5th element starting from the 2nd
runif.trng(2, engine = r_cpy)

## seed, jump and split can be used in c(...) as they return NULL
r <- yarn2$new()
r_cpy <- r$copy()
r$seed(117)
runif.trng(10, engine = r)
c(r_cpy$seed(117),
  r_cpy$jump(2), runif.trng(2, engine = r_cpy),
  r_cpy$split(3,2), runif.trng(2, engine = r_cpy))

## TRNG engine name/kind
r$kind()
r$name()

## use $.Random.seed() to set the current engine (as a copy)
r$.Random.seed()
TRNG.Random.seed(r$.Random.seed())
