source config.sh

##########################################################
#	      Firewall Implementation - DON'T TOUCH			 #
##########################################################

# Setup
iptables -F # Flush all default chains
iptables -X # Delete all user-defined chains
iptables -F -t nat # Flush nat chain
iptables -F -t mangle # Flush mangle chain

# Set default policies
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Create new chains
iptables -N TCP
iptables -N UDP
iptables -N ICMP

##########################################################
#					Default Rules						 #
########################################################## 

# NAT Table
if [[ $ALLOW_FIREWALL_SSH == "TRUE" ]]; then
	iptables -t nat -A PREROUTING -i $INTERNET_NIC ! -s $EXTERNAL_ADMIN_SSH_IP -d $INTERNET_IP -j DNAT --to-destination $CLIENT_IP
else
	iptables -t nat -A PREROUTING -i $INTERNET_NIC -j DNAT --to-destination $CLIENT_IP
fi

iptables -t nat -A POSTROUTING -o $INTERNET_NIC -j SNAT --to-source $INTERNET_IP

# Mangle Table
iptables -A PREROUTING -t mangle -p tcp --sport ssh -j TOS --set-tos Minimize-Delay
iptables -A PREROUTING -t mangle -p tcp --sport ftp -j TOS --set-tos Minimize-Delay
iptables -A PREROUTING -t mangle -p tcp --sport ftp-data -j TOS --set-tos Maximize-Throughput

# SSH
if [[ $ALLOW_FIREWALL_SSH == "TRUE" ]]; then
	iptables -A INPUT -s $EXTERNAL_ADMIN_SSH_IP -d $INTERNET_IP -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
	iptables -A OUTPUT -s $INTERNET_IP -d $EXTERNAL_ADMIN_SSH_IP -p tcp --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
fi

# HTTP
#Drop inbound traffic to port 80 (http) from source ports less than 1024.
iptables -A FORWARD -d $CLIENT_IP -p tcp --sport 0:1023 --dport 80 -j DROP

##########################################################
#					User-defined Rules					 #
########################################################## 

# Block connection requests coming the wrong way
iptables -A FORWARD -d $CLIENT_IP -s $INTERNAL_NET/$INTERNAL_NETMASK -j DROP

# Block inbound connection requests to internal clients on unpermitted ports 
for ports in $BLOCK_ALL_PORTS
{
	iptables -A FORWARD -p tcp -m multiport --dport $ports -j DROP
	iptables -A FORWARD -p udp -m multiport --dport $ports -j DROP
}

# Split traffic to TCP, UDP and ICMP chains
iptables -A FORWARD -p tcp -j TCP
iptables -A FORWARD -p udp -j UDP
iptables -A FORWARD -p icmp -j ICMP

# TCP rules
if [ ! -z $INBOUND_TCP_BLOCK ]
then
	iptables -A TCP -d $CLIENT_IP -p tcp -m multiport --dports $INBOUND_TCP_BLOCK -j DROP 
fi

iptables -A TCP -p tcp -m multiport --dports $TCP_INBOUND_ALLOWED -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A TCP -p tcp -m multiport --sports $TCP_OUTBOUND_ALLOWED -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A TCP -j DROP

# UDP rules
if [ ! -z $INBOUND_UDP_BLOCK ]
then
	iptables -A UDP -d $CLIENT_IP -p udp -m multiport --dports $INBOUND_UDP_BLOCK -j DROP 
fi
iptables -A UDP -p udp -m multiport --dports $UDP_INBOUND_ALLOWED -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A UDP -p udp -m multiport --sports $UDP_OUTBOUND_ALLOWED -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A UDP -j DROP   

# ICMP rules
for port in "${ICMP_INBOUND_ALLOWED[@]}"
{
	iptables -A ICMP -d $CLIENT_IP -p icmp --icmp-type $port -m state --state NEW,ESTABLISHED -j ACCEPT
}
for port in "${ICMP_OUTBOUND_ALLOWED[@]}"
{
	iptables -A ICMP -s $CLIENT_IP -p icmp --icmp-type $port -m state --state NEW,ESTABLISHED -j ACCEPT
}
iptables -A ICMP -j DROP

