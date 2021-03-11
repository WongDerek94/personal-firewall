source config.sh

# Helper function to flush out and reset firewall existing firewall policies and chains
function flush_firewall() {
	iptables -F # Flush all default chains
	iptables -X # Delete all user-defined chains
	iptables -F -t nat # Flush nat chain
	iptables -F -t mangle # Flush mangle chain
}

# Helper function to flush out existisng routing table
function flush_route_table() {
	ip route flush table main
}

# Set up external and internal network information on firewall
function firewall_configuration() {
    clear
    echo "Setting up firewall host..."
    flush_route_table
    flush_firewall

    clear
    echo "1) Enable forwarding  :1"
    echo "1" >/proc/sys/net/ipv4/ip_forward

    echo "nameserver $NAMESERVER" >$NAMESERVER_CONFIG_PATH
    echo "2) Nameserver         :$NAMESERVER"

    echo "3) Internal NIC IP    :$INTERNAL_IP"
    echo "   Internal Network   :$INTERNAL_NET"
    ifconfig $INTERNAL_NIC down
    ifconfig $INTERNAL_NIC $INTERNAL_IP broadcast $INTERNAL_BCAST netmask $INTERNAL_NETMASK
	route del -net $INTERNAL_NET gw 0.0.0.0 netmask $INTERNAL_NETMASK dev $INTERNAL_NIC &> /dev/null
	route add -net $INTERNAL_NET netmask $INTERNAL_NETMASK gw $INTERNAL_IP

    echo "4) Internet gateway   :$INTERNET_GATEWAY"
    echo "   Internet NIC IP    :$INTERNET_IP"
    echo "   Internet           :$INTERNET_NET"
    ifconfig $INTERNET_NIC $INTERNET_IP up
    ip route add $INTERNET_NET dev $INTERNET_NIC
    route add default gw $INTERNET_GATEWAY

    echo "5) PREROUTING         :$INTERNET_IP --> $CLIENT_IP (DNAT)"
    echo "   POSTROUTING        :$CLIENT_IP --> $INTERNET_IP (SNAT)"

    echo "6) Bring up firewall  :./firewall.sh"
    ./firewall.sh

    echo ""
    route -n
    echo ""
}

# Set up internal host 
function client_configuration() {
    clear
    echo "Setting up internal host..."
    flush_route_table
    flush_firewall

    clear
    echo "nameserver $NAMESERVER" >$NAMESERVER_CONFIG_PATH
    echo "1) Nameserver         :$NAMESERVER"
    ifconfig $CLIENT_NIC down
    ifconfig $CLIENT_NIC $CLIENT_IP broadcast $INTERNAL_BCAST netmask $INTERNAL_NETMASK
    route add default gw $INTERNAL_IP

    echo "2) Internet gateway   :$INTERNAL_IP"
    echo "   Client IP        	:$CLIENT_IP"
    echo "   Internal Network   :$INTERNAL_NET"

    echo ""
    route -n
    echo ""
}

# Updates Firewall Rules based on the user defined configurations
function firewall_update() {
    clear
    ./firewall.sh
    echo "TCP inbound 	: $TCP_INBOUND_ALLOWED"
    echo "TCP outbound	: $TCP_OUTBOUND_ALLOWED"
    echo "UDP inbound 	: $UDP_INBOUND_ALLOWED"
    echo "UDP outbound	: $UDP_OUTBOUND_ALLOWED"
    echo "ICMP inbound	: $ICMP_INBOUND_ALLOWED"
    echo "ICMP outbound	: $ICMP_OUTBOUND_ALLOWED"

    echo ""
    echo "TCP blocked	: $INBOUND_TCP_BLOCK"
    echo "UDP blocked	: $INBOUND_UDP_BLOCK"
    echo "Block all     : $BLOCK_ALL_PORTS"
    echo "Firewall updated!"
}

# List all default and user-defined chains
function iptables_list() {
    clear
    iptables -L -v -n -x --line-numbers # Verbose, supressing DNS, no rounding, and show rule positioning options
}

# Wrapper function to run firewall test on internal or external host
function automatic_test_run() {
    clear
    echo "Running firewall test, please wait..."
    ./firewall-test.sh $1
    while :; do # Flush out existisng routing table
        echo "Test completed, Would you like to view it now? [y/n]"
        read -p " > " ltr
        case ${ltr} in
        y | "")
            vim $OUTPUT_FILE
            break
            ;;
        n)
            echo "To view test reulst later, check $OUTPUT_FILE"
            break
            ;;
        *)
            echo "Please enter a valid choice, default [y]"
            ;;
        esac
    done
}

options=(
    "Configure Firewall" 
	"Configure Client" 
	"Update Firewall Rules" 
	"List iptable Policies" 
	"Internal Firewall Test" 
	"External Firewall Test"
)

# command-line menu display
clear
while true; do
    for i in "${!options[@]}"; do
        echo "$i) ${options[$i]}"
    done
    echo "q) quit"
    read -p " > " ltr rest
    case ${ltr} in
    [0])
        firewall_configuration
        exit
        ;;
    [1])
        client_configuration
        exit
        ;;
    [2])
        firewall_update
        exit
        ;;
    [3])
        iptables_list
        exit
        ;;
    [4])
        automatic_test_run -internal
        exit
        ;;
    [5])
        automatic_test_run -external
        exit
        ;;
    [Qq])
        exit
        ;;
    *)
        clear
        echo "Unrecognized choice: ${ltr}"
        ;;
    esac
done			
