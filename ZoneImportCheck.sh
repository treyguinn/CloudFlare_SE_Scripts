#!/bin/bash

INPUTFILE=$1
OUTPUTFILE=ZoneCheckResults.txt


#Initialize Output File
printf "Domain,Effective_URL,HTTP_Status_Code,Total_Time,DNS_Lookup_Time,Nameserver1,Nameserver2\n" > $OUTPUTFILE
printf "Output file initialized: $OUTPUTFILE \n"

printf "Inuput file is: $1 \n"
ZONENUMBER=`wc -l < $INPUTFILE`
printf "File contains $ZONENUMBER items \n"

ZONECOUNT=0

# Loop through all zones in the file

while read DNSZONE
do
	# Do http request, following redirects to argument and report
	# which URL ended up on, the HTTP response, the time it took for full response,
	# and the time for the DNS response
	
	(( ZONECOUNT++ ))

	printf "Zone to check: $DNSZONE \n"
	printf "Checking $ZONECOUNT of $ZONENUMBER \n"

	printf "$DNSZONE," >> $OUTPUTFILE

	curl --silent --location --output /dev/null --proto =http -w %{url_effective},%{http_code},%{time_total},%{time_namelookup} --url $DNSZONE >> $OUTPUTFILE

	# For a zone, find NS records and each one
	for NSHOST in $(dig +short -t NS $DNSZONE)
		do
			 printf ",$NSHOST" >> $OUTPUTFILE
		done

#add carriage return
printf "\n" >> $OUTPUTFILE

done < $INPUTFILE


printf "Script Ended \n"

exit 0
