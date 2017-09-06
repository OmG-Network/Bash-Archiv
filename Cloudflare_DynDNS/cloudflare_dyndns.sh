#!/bin/bash

###
### Cloudflare DynDNS Script
###     2017-04-08
###       Markus
###


# FritzBox WAN IP Check
ip_check_box=$(curl "http://fritz.box:49000/igdupnp/control/WANIPConn1" -H "Content-Type: text/xml; charset="utf-8"" -H "SoapAction:urn:schemas-upnp-org:service:WANIPConnection:1#GetExternalIPAddress" -d "<?xml version='1.0' encoding='utf-8'?> <s:Envelope s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/' xmlns:s='http://schemas.xmlsoap.org/soap/envelope/'> <s:Body> <u:GetExternalIPAddress xmlns:u='urn:schemas-upnp-org:service:WANIPConnection:1' /> </s:Body> </s:Envelope>" -s | grep -Eo '\<[[:digit:]]{1,3}(\.[[:digit:]]{1,3}){3}\>')

# Cloudflare IP Check
ip_check_cloudflare=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/:zone_id:/dns_records/:dns_id:" \
     -H "X-Auth-Email: :Auth-Email:" \
     -H "X-Auth-Key: :api_key:" \
     -H "Content-Type: application/json" \
     | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

# IPs Vergleichen

if [ $ip_check_box != $ip_check_cloudflare ]; then

# IPs sind NICHT gleich

echo "Achtung IPs sind nicht gleich !"

# Cloudflare DNS Update (API Call)

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/:zone_id:/dns_records/:dns_id:" \
     -H "X-Auth-Email: :Auth-Email:" \
     -H "X-Auth-Key: :api_key:" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"www","content":"'$ip_check_box'","ttl":120,"proxied":true}'


else

#IPs sind GLEICH

echo "Achtung IPs sind gleich nix machen"

fi

exit 0