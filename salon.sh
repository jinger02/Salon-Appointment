#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ JINGER'S SALON ~~~~~\n"
echo -e "Welcome to Jinger's Salon, how can I help you?\n"

MAIN(){
    if [[ $1 ]]
    then
      echo -e "\n$1"
    fi  

    #display services
    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
    do
      echo "$SERVICE_ID) $SERVICE_NAME"
    done

    read SERVICE_ID_SELECTED
    
    #check if SERVICE_ID_SELECTED is in services database
    SERVICE_ID_RESULT=$($PSQL "SELECT service_id FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
    if [[ -z $SERVICE_ID_RESULT ]]
    then
      MAIN "I could not find that service. What would you like today?"
    else
      APPOINT
    fi
    
    
}

APPOINT(){
  
}

MAIN