#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Shop ~~~~~\n"

# Common function to handle appointments
handle_appointment() {
  local SERVICE_ID_SELECTED="$1"
  local SERVICE_NAME
  local CUSTOMER_PHONE
  local CUSTOMER_NAME
  local SERVICE_TIME
  local CUSTOMER_ID_REQUESTED

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z "$CUSTOMER_NAME" ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  echo -e "\nWhat time would you like your appointment, $CUSTOMER_NAME?"
  read SERVICE_TIME

  CUSTOMER_ID_REQUESTED=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  INSERT_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID_REQUESTED, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  SERVICE_NAME=$(echo "$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")" | tr -d '\n')

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"
}

MAIN_MENU() {
  if [[ $1 ]]; then
    echo -e "\n$1"
  else
    echo "Welcome to My Salon, how can I help you?"
  fi

  echo -e "\n1) Cut \n2) Color \n3) Perm \n4) Style \n5) Trim \n6) Exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) handle_appointment 1 ;; # Call common function
    2) handle_appointment 2 ;;
    3) handle_appointment 3 ;;
    4) handle_appointment 4 ;;
    5) handle_appointment 5 ;;
    6) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU
