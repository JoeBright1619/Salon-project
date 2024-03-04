#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
Menu(){
echo -e "What service would you like?\nPick the number!!"

saloonmenu="$($PSQL 'select * from services')"
echo -e "$saloonmenu"  | sed -E 's/([0-9]+)\|/\1) /'
read SERVICE_ID_SELECTED;
}

echo -e "\n~~Joe's hair saloon~~\n"
Menu;

while [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
do
echo -e "\n~~ Invalid input format!!\nEnter only a digit that corresponds to the service!! ~~\n"
Menu;
done

SERVICE_NAME="$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")";

while [[ -z $SERVICE_NAME ]]
do
echo -e "\n~~ could not find that service!! ~~\n"
Menu;
SERVICE_NAME="$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")";
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

CUSTOMER_NAME="$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")"

if [[ -z $CUSTOMER_NAME ]]
then
echo -e "\nYou do not appear in the database, what's your name?"
read CUSTOMER_NAME
ADD_CUSTOMER=$($PSQL "insert into customers(phone,name)values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi

echo -e "\n What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
while [[ -z $SERVICE_TIME ]]
do
echo -e "\n What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
done

CUSTOMER_ID="$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME'")"
ADD_APPOINTMENT="$($PSQL "insert into appointments(customer_id,service_id,time)values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")"
if [[ $ADD_APPOINTMENT =~ "INSERT" ]]
then
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
