source config.sh

echo "" >$OUTPUT_FILE
CASE_LABEL="##########################################################################
#								Case %s					 			 	 #
##########################################################################\n"

while [ -n "$1" ]; do
	case "$1" in
	-internal)
		echo "internal test running..."

		#########################################
		#				Case 1					#
		#########################################
		printf "$CASE_LABEL" '1' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 443 --keep --destport 443 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 443 --keep --destport 443 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 5 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 2					#
		#########################################
		printf "$CASE_LABEL" '2' >>$OUTPUT_FILE
		printf "Command: hping3 --fast --udp -c 5 --baseport 17 --keep --destport 17 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast --udp -c 5 --baseport 17 --keep --destport 17 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 3					#
		#########################################
        printf "$CASE_LABEL" '3' >>$OUTPUT_FILE
		printf "Command: hping3 --fast --icmp -c 5 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
        hping3 --fast --icmp -c 5 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 5 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 4					#
		#########################################
        printf "$CASE_LABEL" '4' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 100 --destport 18 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
        hping3 --fast -c 5 -S --baseport 100 --destport 18 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 --udp --baseport 100 --destport 18 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
        hping3 --fast -c 5 --udp --baseport 100 --destport 18 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		printf "Command: hping3 --fast --icmp-ts -c 5 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
        hping3 --fast --icmp-ts -c 5 $EXTERNAL_IP &>>$OUTPUT_FILE
        printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 5					#
		#########################################
		printf "$CASE_LABEL" '5' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S -A --baseport 443 --destport 443 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S -A --baseport 443 --destport 443 $EXTERNAL_IP &>>$OUTPUT_FILE
        printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 6					#
		#########################################
		printf "$CASE_LABEL" '6' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S -F --baseport 443 --destport 443 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S -F --baseport 443 --destport 443 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 7					#
		#########################################
		printf "$CASE_LABEL" '7' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 23 --keep --destport 23 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 23 --keep --destport 23 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 8					#
		#########################################
		printf "$CASE_LABEL" '8' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 22 --keep --destport 22 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 22 --keep --destport 22 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 5 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 9					#
		#########################################
		printf "$CASE_LABEL" '9' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 1025 --keep --destport 80 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 443 --keep --destport 1024 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 5 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		;;

	-external)
		echo "external test running..."

		#########################################
		#				Case 1					#
		#########################################
        printf "$CASE_LABEL" '1' >>$OUTPUT_FILE
		printf "Command: hping3 --fast --udp -c 5 --baseport 17 --keep --destport 17 $INTERNET_IP\n" &>>$OUTPUT_FILE
		hping3 --fast --udp -c 5 --baseport 17 --keep --destport 17 $INTERNET_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 2					#
		#########################################
        printf "$CASE_LABEL" '2' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 100 --destport 18 $INTERNET_IP\n" &>>$OUTPUT_FILE
        hping3 --fast -c 5 -S --baseport 100 --destport 18 $INTERNET_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 --udp --baseport 100 --destport 18 $INTERNET_IP\n" &>>$OUTPUT_FILE
        hping3 --fast -c 5 --udp --baseport 100 --destport 18 $INTERNET_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		printf "Command: hping3 --fast --icmp-ts -c 5 $INTERNET_IP\n" &>>$OUTPUT_FILE
        hping3 --fast --icmp-ts -c 5 $INTERNET_IP &>>$OUTPUT_FILE
        printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 4					#
		#########################################
		printf "$CASE_LABEL" '4' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 22 --destport 22 $INTERNET_IP\n" &>>$OUTPUT_FILE
        hping3 --fast -c 5 -S --baseport 22 --destport 22 $INTERNET_IP &>>$OUTPUT_FILE
		printf "Expected Result: 5 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S -A --baseport 22 --destport 22 $INTERNET_IP\n" &>>$OUTPUT_FILE
        hping3 --fast -c 5 -S -A --baseport 22 --destport 22 $INTERNET_IP &>>$OUTPUT_FILE
        printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 5					#
		#########################################
		printf "$CASE_LABEL" '5' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 20 --keep --destport 60000 $INTERNET_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 20 --keep --destport 60000 $INTERNET_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		printf "Command: hping3 --fast --udp -c 5 -S --baseport 17 --keep --destport 60000 $INTERNET_IP\n" &>>$OUTPUT_FILE
		hping3 --fast --udp -c 5 -S --baseport 17 --keep --destport 60000 $INTERNET_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
        #########################################
		#				Case 6					#
		#########################################
		printf "$CASE_LABEL" '6' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --spoof 10.0.0.3 --baseport 443 --keep --destport 443 $INTERNET_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --spoof 10.0.0.3 --baseport 443 --keep --destport 443 $INTERNET_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 7					#
		#########################################
		printf "$CASE_LABEL" '7' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S -F --baseport 443 --destport 443 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S -F --baseport 443 --destport 443 $EXTERNAL_IP &>>$OUTPUT_FILE
        printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 8					#
		#########################################
		printf "$CASE_LABEL" '8' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 23 --keep --destport 23 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 23 --keep --destport 23 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 9					#
		#########################################
		printf "$CASE_LABEL" '9' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 70 --keep --destport 80 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 70 --keep --destport 80 $EXTERNAL_IP &>>$OUTPUT_FILE
        printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		#########################################
		#				Case 10					#
		#########################################
		printf "$CASE_LABEL" '10' >>$OUTPUT_FILE
		printf "Command: hping3 --fast -c 5 -S --baseport 0 --keep --destport 0 $EXTERNAL_IP\n" &>>$OUTPUT_FILE
		hping3 --fast -c 5 -S --baseport 0 --keep --destport 0 $EXTERNAL_IP &>>$OUTPUT_FILE
		printf "Expected Result: 0 PACKETS RECEIVED\n\n" &>>$OUTPUT_FILE
		
		;;

	*) echo "Option $1 not recognized" ;;
	esac
	shift
done
