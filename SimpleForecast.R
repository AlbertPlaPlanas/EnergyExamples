### Load Prophet library
library("prophet")
### Set working path
setwd("/Users/i0365030/Documents/MBA Class/HandsOn/")

########### Basic example ########
### Load & plot data
energy_consumption <- read.csv("LondonEnergy.csv", colClasses = c("Date","numeric")) 
plot(energy_consumption, type = "l")

### Rename columns to fit 'prophet' standards
colnames(energy_consumption) <- c("ds","y")

### Train the model
m <- prophet(energy_consumption)

### Create 'future' dataset (the days that will concern our prediction)
future_energy <- make_future_dataframe(m, periods = 365)

### Generate forecast based on the model m
b_forecast <- predict(m, future_energy)

### Show forecast
plain_forecast <- plot(m, b_forecast)
plain_forecast
