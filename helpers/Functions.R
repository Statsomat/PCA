# Continuity cutoff with respect to sample size 
cutoffcont <- function(n){
  
  # Cutoff for continuity f(n)=a*log10(n)+b, f(10)=0.75, , f(50)=0.4, f(100)=0.25
  
  b=125
  a=-50
  
  if (n<=50) {  
    cut <- min(1,round((a*log10(n)+b)/100,2))
  } else {
    
    # 20 unique values for sample sizes greater than 50
    cut <- 20/n
  }
  return(cut)
}

# Variables can be: Pure continuous or continuous with max 3 replications or other discrete distribution which can be approximated by continuous 
continuous <- function(col){
  
  dt <- data.table(col)
  reps <- na.omit(dt[,.N,by=col])
  
  if ( (all(reps[,2]<=3)) || 
       (length(unique(na.omit(col))) / length(na.omit(col)) >= cutoffcont(length(na.omit(col))))   ){
    return(TRUE)
  } else {return(FALSE)
  }
}


# Compute outliers by knn proximity based method, liberal 
knnoutlier <- function(data){
  data <- data[complete.cases(data),]
  outliers_scores <- LOOP(data, k=10, lambda=3)
  outliers <- which(outliers_scores > 0.90, arr.ind = TRUE)
  return(outliers)
} 


# Check normality of one variable 
normality <- function(col){
  
  qq <- qqnorm(col,plot=FALSE)
  qqcor <- with(qq,cor(x,y))
  
  if (qqcor >=0.975){
    return(TRUE)
  } else {
    return(FALSE)
  }
}
  

# p-value format
pformat <- function(p){
  if (is.na(p)){
    return(NA)
  } else if (p<0.001){ 
    return("<0.001")
  } else return (round(p,3))
}



