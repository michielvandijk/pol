# filler
filler <- function(x, n){
  if(is.na(x[n])){
    x[n] <- filler(x, (n-1))
  }
  return(x[n])
}

backer <- function(x){
  for(n in length(x):2){
    x[n] <- filler(x, n)
  }
  return(x)
}