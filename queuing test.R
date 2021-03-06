#Creating simuation process function

clinic_simulation = function(poisson_param, first_show_param, follower_param,
                             consult_param, open_hour, close_hour){
  #Number of doctors
  nb_doctors = 3
  
  #Start time = 9 AM and close time 4pm (16h) (stop admitting new clients)
  #amount of time accorded to receive clients in minutes.
  time_laps = (close_hour - open_hour)*60
  
  #Each patient come at 8 minutes as Poisson parameter.
  #The theorical expectation of the number of patients per day is
  lambda = time_laps*(1/poisson_param)
  
  
  #Appearing time of the first patient after the opening (expectation �qual to 8 minutes)
  #So the value of the exponential law should be 1/8
  first_show = rexp(n = 1, rate = 1/first_show_param)
  
  ##### Now we will simulate the patient arrival time process ####
  
  #Lets initialize the vector of appearance time that should contain the appearances times of patients in the day.
  appearance_times = first_show
  
  #Simulation of appearance time
  while(tail(appearance_times, n=1) < time_laps){
    new_patient_app_time = rexp(n=1, rate=1/follower_param)
    last_appearance_time_cum = tail(appearance_times, n=1) + new_patient_app_time
    appearance_times = c(appearance_times, last_appearance_time_cum)
  }
  
  #Drop the last element that corresponds to the client who come too late
  appearance_times = appearance_times[-length(appearance_times)]
  
  
  
  ##### Now we have to go through the doctors consultation time process #####
  
  #The variables for each doctor to be ready to meet the next patient
  free_times = numeric(nb_doctors)
  
  #Variable to determine the time the patient wait until to see a doctor (vector inialized to 0)
  wait_until_time = numeric(length(appearance_times))
  
  #Initialization of variables to find the next availability time of a doctor and the close hour of hospital
  ready_time = close_time = 0
  
  #The process begin
  for(i in 1:length(appearance_times)){
    
    #The waiting time vector should be updated
    if (appearance_times[i] < ready_time){
      wait_until_time[i] = ready_time - appearance_times[i]
    }
    
    if(ready_time == free_times[1]){ #The first doctor is now available
      
      #Consultation start time
      start_time = max(appearance_times[i], free_times[1])
      
      #Consultation duration
      duration = runif(n = 1, min = 15, max = 30)
      
      #Update the free-time period for this doctor
      free_times[1] = start_time + duration
      
    }
    
    else if(ready_time == free_times[2]){ #The second doctor is available
      
      #Consultation start time
      start_time = max(appearance_times[i], free_times[2])
      
      #Consultation duration
      duration = runif(n = 1, min = 15, max = 30)
      
      #Update the free-time period for this doctor
      free_times[2] = start_time + duration
      
    }
    
    else if(ready_time == free_times[3]){ #The third doctor is available
      
      #Consultation start time
      start_time = max(appearance_times[i], free_times[3])
      
      #Consultation duration
      duration = runif(n = 1, min = 15, max = 30)
      
      #Update the free-time period for this doctor
      free_times[3] = start_time + duration
      
    }
    
    #Update the ready time
    ready_time = min(free_times)
    
    #Close time : Time the last doctor finished the consultation of the last patient should be updated too
    close_time = max(free_times)
  } #End of the process
  
  #Conversion of Close Time
  hour = floor(close_time/60)
  minutes = round(close_time - 60*hour,0)
  close_time_display = paste(open_hour + hour, "h ", minutes,"mn", sep = "") 
  
  #Return the values needed
  return(
    c(length(appearance_times), sum(wait_until_time>0),
      round(mean(wait_until_time[wait_until_time>0]),2), round(close_time,2), 
      close_time_display)
  )
}




#Now, lets answer questions.


## A) Simulation of the process one time
#We use the R base function "replicate" to simulate the process a given number of times

#Get the result
result1 = t(replicate(1,clinic_simulation(8,8,8,0,open_hour = 9, close_hour = 16)))

colnames(result1) = c("nb_patients", "nb_waited_patients", "average_wait_per_minute", 
"close_hour_in_minutes", "close_hour_display")


#We find the results:


data.frame(result1)


## B) Simulation of process 1000 times



result2 = t(replicate(1000,clinic_simulation(8,8,8,0,open_hour = 9, close_hour = 16)))
colnames(result2) = c("nb_patients", "nb_waited_patients", "average_wait_per_minute", 
"close_hour_in_minutes", "close_hour_display")

#Lets have a look at the results
head(data.frame(result2))



### Computation of median and confidence intervals


#Estimation of median
nb_patients = as.numeric(as.character(result2[,"nb_patients"]))
median(nb_patients)




#Confidence Intervals and median
nb_waited_patients = as.numeric(as.character(result2[,"nb_waited_patients"]))
average_wait_per_minute = as.numeric(as.character(result2[,"average_wait_per_minute"]))
close_hour_in_minutes = as.numeric(as.character(result2[,"close_hour_in_minutes"]))

#Look at distributions
par(mfrow = c(2,2))
hist(nb_patients, breaks = 35, col='blue')
hist(nb_waited_patients, breaks = 35, col='red')
hist(average_wait_per_minute, breaks = 35, col='green')
hist(close_hour_in_minutes, breaks = 35, col='yellow')

#As we can see the histogram, we assume the distribution of nb_patients is normal
IC_inf1 = mean(nb_patients) - 1.96*sd(nb_patients)
IC_sup1 = mean(nb_patients) + 1.96*sd(nb_patients)
print(c(IC_inf1, IC_sup1))

#As we can see the histogram, we assume the distribution of nb_waited_patient is normal
IC_inf1 = mean(nb_waited_patients) - 1.96*sd(nb_waited_patients)
IC_sup1 = mean(nb_waited_patients) + 1.96*sd(nb_waited_patients)
print(c(IC_inf1, IC_sup1))





#By the histogram, we assume average_wait_per_minute is following khi-deux distribution
#Confidence intervals for average_wait_per_minute
df = 1000-1 #degree of freedom
c(
  mean(average_wait_per_minute)-sqrt(((df)*sd(average_wait_per_minute)^2)/qchisq(c(.025),df=df, lower.tail=FALSE)),
  mean(average_wait_per_minute)+sqrt(((df)*sd(average_wait_per_minute)^2)/qchisq(c(.975),df=df, lower.tail=FALSE))
)




#By the histogram, we assume average_wait_per_minute is following khi-deux distribution
#Confidence intervals for average_wait_per_minute
c(
  mean(close_hour_in_minutes)-sqrt(((df)*sd(close_hour_in_minutes)^2)/qchisq(c(.025),df=df, lower.tail=FALSE)),
  mean(close_hour_in_minutes)+sqrt(((df)*sd(close_hour_in_minutes)^2)/qchisq(c(.975),df=df, lower.tail=FALSE))
)

