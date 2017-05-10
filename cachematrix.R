## Put comments here that give an overall description of what your
## functions do

## Write a short comment describing this function
## This function creates a special "matrix" object that can cache its inverse.
makeCacheMatrix <- function(x = matrix()) {
   inverse <- NULL
   set <- function(y){
          x <<- y
          inverse <<- NULL
   }
   get <- function() x
   setinverse <- function(solve) inverse <<- solve
   getinverse <- function() inverse
   list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}


## Write a short comment describing this function
## This function computes the inverse of the special "matrix" returned by makeCacheMatrix above. If the inverse has already been calculated (and the matrix has not changed), 
## then cacheSolve should retrieve the inverse from the cache.
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
   inverse <- x$getinverse()
   if(!is.null(inverse)) {
      message("getting cached data")
      return(inverse)
   }
   data <- x$get()
   inverse <- solve(data)
   x$setinverse(inverse)
   inverse
}

## Run example results
##> x <- rbind(c(1,2), c(2,1))
##> m <- makeCacheMatrix(x)
##> m$get()
##     [,1] [,2]
##[1,]    1    2
##[2,]    2    1
##> cacheSolve(m)
##           [,1]       [,2]
##[1,] -0.3333333  0.6666667
##[2,]  0.6666667 -0.3333333
##> cacheSolve(m)
## cached data
##           [,1]       [,2]
##[1,] -0.3333333  0.6666667
##[2,]  0.6666667 -0.3333333