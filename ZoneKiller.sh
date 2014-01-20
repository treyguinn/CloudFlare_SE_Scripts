#!/bin/bash

#Simple script to delete all records in a CloudFlare DNS zone

INPUTFILE=$1

DNSZONE= #[ZONENAME]
APIKEY= #[APIKEY]
EMAIL= #[AccountEmail]
ACTION=rec_delete #assuming you want to delete records


while read RECORDLINE
do
	
	(( ZONECOUNT++ ))

	echo $RECORDLINE > ugly.temp

	printf "Record Line $RECORDLINE \n"

	SUBDOMAIN=$(awk -F "\"*,\"*" '{print $1;}' ugly.temp)
	printf "Subdomain: $SUBDOMAIN \n"

	RECORDTYPE=$(awk -F "\"*,\"*" '{print $2;}' ugly.temp)
	printf "RecordType: $RECORDTYPE \n"
	
	VALUE=$(awk -F "\"*,\"*" '{print $3;}' ugly.temp)
	printf "Subdomain: $VALUE \n"

	curl https://www.cloudflare.com/api_json.html  -d "a=$ACTION" -d "tkn=$APIKEY" -d "email=$EMAIL" -d "z=$DNSZONE" -d "type=$RECORDTYPE" -d "name=$SUBDOMAIN" -d "content=$VALUE"

	printf "\n\n"

	sleep 1
	rm ugly.temp

done < $INPUTFILE