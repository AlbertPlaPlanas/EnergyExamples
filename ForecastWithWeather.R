library("prophet")

########### Example with external regressor ########
### We want to be more precise, we use some paraeter tweaking
### Load data
energy_consumption <- read.csv("LondonEnergy.csv", colClasses = c("Date","numeric")) 


### load weather data
past_weather<- read.csv("LondonWeather_past.csv",colClasses=c("Date","numeric"))
future_weather <- read.csv("LondonWeather_future.csv", colClasses = c("Date","numeric")) 

### Plot weather & data
plot(energy_consumption,type = "l",ylim = c(0,450), main = "Energy consumption (KWH) & Avg Temperature (0.1c)")
lines(past_weather$Date,past_weather$Temp*10, col = "red")

### Rename columns to fit 'prophet' standards
colnames(energy_consumption) <- c("ds","y")

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


