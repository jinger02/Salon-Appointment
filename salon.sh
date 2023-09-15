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
      echo "$SERVICE_ID) $SERVICE"
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
    echo "What's your phone number? eg. 123-456-7890"
    read PHONE_NUMBER
    # check if phone number exist
    if [[ ! $PHONE_NUMBER =~ ^[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9] ]]
    then
        echo -e "That is an invalid number.\n"
        APPOINT
    else
        # check if in db
        PHONE_NUMBER_RESULT=$($PSQL "SELECT phone FROM customers WHERE phone='$PHONE_NUMBER'")
        # if does not exist
        if [[ -z $PHONE_NUMBER_RESULT ]]
        then
            # ask for name
            echo "I don't have a record for that phone number, what's your name?"
            read CUSTOMER_NAME
            # insert to database
            NAME_PHONE_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$PHONE_NUMBER','$CUSTOMER_NAME')")
        fi
        # ask for appointment time
        CUSTOMER_NAME_RESULT=$($PSQL "SELECT name FROM customers WHERE phone='$PHONE_NUMBER'")
        CUSTOMER_ID_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$PHONE_NUMBER'")
        echo "What time would you like your cut,$CUSTOMER_NAME_RESULT?"
        read TIME
        # insert appointment time
        INSERT_APPOINTMENT=$($PSQL INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID_RESULT,$SERVICE_ID_RESULT,'$TIME))


    fi
}


MAIN