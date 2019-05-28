library("prophet")

########### Example with hypotetical cold year scenario ########
### We want to be more precise, we use some paraeter tweaking
### Load data
energy_consumption <- read.csv("LondonEnergy.csv", colClasses = c("Date","numeric")) 
colnames(energy_consumption) <- c("ds","y")

# create artificial cold weather signal
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
# create artifical warm weather signal
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


#### We show the forecast for the warm scenario and for the cold scenario
plot(cold_forecast$ds[814:1206],cold_forecast$yhat[814:1206],type="l",col="blue", ylim = c(150,400), main= "Energy Consumption", xlab="Date", ylab="KWH")
#lines(cold_forecast$yhat[814:1206],type="l",col="blue")
lines(warm_forecast$ds[814:1206],warm_forecast$yhat[814:1206],type="l",col="orange")
legend("topleft", legend = c ( "Hypothetical Cold Forecast", "Hypothetical Warm Forecast"), 
       col = c("blue","orange"),lty=1, cex=0.8)
