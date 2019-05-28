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


########### Example with external regressor ########
### We want to be more precise, we use some paraeter tweaking
### Load data
energy_consumption <- read.csv("LondonEnergy2.csv", colClasses = c("Date","numeric")) 
colnames(energy_consumption) <- c("ds","y")

### load weather data
past_weather<- read.csv("LondonWeather_past.csv",colClasses=c("Date","numeric"))
future_weather <- read.csv("LondonWeather_future.csv", colClasses = c("Date","numeric")) 

### Add weather to the dataset
energy_consumption$Temperature <- past_weather$Temp

### Define the model & the external regressor
m <- prophet()
m <- add_regressor(m,"Temperature")
m <- fit.prophet(m,energy_consumption)

### Create 'future' dataset (the days that will concern our prediction)
future_energy <- make_future_dataframe(m, periods = 393)
future_energy$Temperature <- c(past_weather$Temp,future_weather$Temp)

### Generate forecast based on the model m
c_forecast <- predict(m, future_energy)

### Show forecast
complex_forecast <- plot(m, c_forecast)
complex_forecast


########### Example with hypotetical scenario ########
### We want to be more precise, we use some paraeter tweaking
### Load data
energy_consumption <- read.csv("LondonEnergy2.csv", colClasses = c("Date","numeric")) 
colnames(energy_consumption) <- c("ds","y")

### load weather data
past_weather<- read.csv("LondonWeather_past.csv",colClasses=c("Date","numeric"))
hypotetical_cold_weather <- read.csv("LondonWeather_future.csv", colClasses = c("Date","numeric")) 

# create artifical cold weather signal
hypotetical_cold_weather$Temp = sin(seq(0,2*pi,2*pi/392))*11+9
plot(hypotetical_cold_weather, type ="l")

### Add weather to the dataset
energy_consumption$Temperature <- past_weather$Temp

### Define the model & the external regressor
m <- prophet()
m <- add_regressor(m,"Temperature")
m <- fit.prophet(m,energy_consumption)

### Create 'future' dataset (the days that will concern our prediction)
future_energy <- make_future_dataframe(m, periods = 393)
future_energy$Temperature <- c(past_weather$Temp,hypotetical_cold_weather$Temp)

### Generate forecast based on the model m
cold_forecast <- predict(m, future_energy)

### Show forecast
hypotetical_cold_forecast <- plot(m, cold_forecast)
hypotetical_cold_forecast

########### Example with hypotetical warm scenario ########
### We want to be more precise, we use some paraeter tweaking
### Load data

########### Example with hypotetical scenario ########
### We want to be more precise, we use some paraeter tweaking
### Load data
energy_consumption <- read.csv("LondonEnergy2.csv", colClasses = c("Date","numeric")) 
colnames(energy_consumption) <- c("ds","y")

### load weather data
past_weather<- read.csv("LondonWeather_past.csv",colClasses=c("Date","numeric"))
hypotetical_warm_weather <- read.csv("LondonWeather_future.csv", colClasses = c("Date","numeric")) 

# create artifical cold weather signal
hypotetical_warm_weather$Temp = sin(seq(0.2,(2*pi+0.2),(2*pi)/392))*11+15

### Add weather to the dataset
energy_consumption$Temperature <- past_weather$Temp

### Define the model & the external regressor
m <- prophet()
m <- add_regressor(m,"Temperature")
m <- fit.prophet(m,energy_consumption)

### Create 'future' dataset (the days that will concern our prediction)
future_energy <- make_future_dataframe(m, periods = 393)
future_energy$Temperature <- c(past_weather$Temp,hypotetical_warm_weather$Temp)

### Generate forecast based on the model m
warm_forecast <- predict(m, future_energy)

### Show forecast
hypotetical_warm_forecast <- plot(m, warm_forecast)
hypotetical_warm_forecast


plot(b_forecast$yhat[814:1206],type="l",col="black", ylim = c(150,400))
lines(c_forecast$yhat[814:1206],type="l",col="red")
lines(cold_forecast$yhat[814:1206],type="l",col="blue")
lines(warm_forecast$yhat[814:1206],type="l",col="orange")
legend("topleft", 
       legend = c ("Simple forecast", "Complex Forecast", "Hypothetical Cold Forecast", "Hypothetical Warm Forecast"), 
       col = c("black","red", "blue","orange"),lty=1:2, cex=0.8)
