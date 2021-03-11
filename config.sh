##########################################################
#			    	User Configurations			         #
##########################################################

##########################################################
#		Firewall host and internal host setup			 #
##########################################################
# nameserver info
NAMESERVER="1.1.1.1"
NAMESERVER_CONFIG_PATH="/etc/resolv.conf"

# Firewall External network info
INTERNET_NIC="eth0"
INTERNET_IP="192.168.1.99"
INTERNET_GATEWAY="192.168.1.254"
INTERNET_NET="192.168.1.0/24"

# Firewall Internal netowrk info 
INTERNAL_NIC="wlan0"
INTERNAL_IP="10.0.0.1"
INTERNAL_NET="10.0.0.0"
INTERNAL_BCAST="10.0.0.255"
INTERNAL_NETMASK="255.255.255.0"

# Client info
CLIENT_NIC="enp0s3"
CLIENT_IP="10.0.0.2"
CLIENT_NETMASK="255.255.255.0"	

EXTERNAL_IP="192.168.1.68"

ALLOW_FIREWALL_SSH="TRUE"
EXTERNAL_ADMIN_SSH_IP="192.168.1.65"

##########################################################
#					Firewall params						 #
########################################################## 
TCP_INBOUND_ALLOWED="20,21,22,80,443"
TCP_OUTBOUND_ALLOWED="20,21,22,80,443"

UDP_INBOUND_ALLOWED="17,53"
UDP_OUTBOUND_ALLOWED="17,53"

ICMP_INBOUND_ALLOWED=( "0" "8" ) 
ICMP_OUTBOUND_ALLOWED=( "0" "8" )

INBOUND_TCP_BLOCK="1024:65535"
INBOUND_UDP_BLOCK=""
BLOCK_ALL_PORTS="0 23 137:139" # TCP, UDP

##########################################################
#				Automatic test params					 #
########################################################## 
OUTPUT_FILE="internal-test-result.txt"
