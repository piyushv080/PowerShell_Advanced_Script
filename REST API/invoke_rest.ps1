#fetch the data from incident using get
Invoke-RestMethod -Method Get
#Create the incident using post 
Invoke-RestMethod -Method Post
#Update the incident using put
Invoke-RestMethod -Method Put

# Giving URL using uri
Invoke-RestMethod -Method Uri 