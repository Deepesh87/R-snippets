age=c(25, 35, 50)
salary <- c(200000, 1200000, 2000000)
df=cbind(age,salary)
df
# Normalise a vector Z normalisation
# USing R built in Scale function
Znormalised <- as.data.frame( scale (df))
Znormalised
# to scale a vector between 0 and 1 use a custom function
df

Myscale= function(x){
return((x-min(x))/(max(x)-min(x)))
 }
Myscale(age)
Myscale(salary)
My_df=cbind(age=Myscale(age),salary=Myscale(salary))
My_df