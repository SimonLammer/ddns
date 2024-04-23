#!/bin/sh
ak=$(cat ak.txt)
sk=$(cat sk.txt)
api=https://porkbun.com/api/json/v3

ipv4file=ipv4.txt
touch "$ipv4file"
# add -f to fail silently
ipv4=$(curl -m 5 -w '\n' -s 'https://api4.ipify.org')
if [ -z "$ipv4" -o "$(cat $ipv4file)" = "$ipv4" ]; then
	# couldn't fetch IP, or IP hasn't changed
	echo -n "."
	exit 0
fi
echo -n "$ipv4" >"$ipv4file"
echo ''
echo -n "$(date +"%Y%m%dT%H%M%S"); $ipv4;"

# curl --header "Content-Type: application/json" \
# 	--request POST \
# 	--data "{ \
# 		\"apikey\" : \"$ak\", \
# 		\"secretapikey\" : \"$sk\" \
# 	}" \
# 	$api/domain/listAll
# echo -n ';'
#{"status":"SUCCESS","domains":[{"domain":"lammer.top","status":"ACTIVE","tld":"top","createDate":"2024-04-17 21:00:42","expireDate":"2025-04-17 21:00:42","securityLock":"1","whoisPrivacy":"1","autoRenew":"1","notLocal":0}]}root@raspi4sl:/opt/ddns# vim update.sh

# curl --header "Content-Type: application/json" \
# 	--request POST \
# 	--data "{ \
# 		\"apikey\" : \"$ak\", \
# 		\"secretapikey\" : \"$sk\" \
# 	}" \
# 	$api/dns/retrieveByNameType/lammer.top/A/
# echo -n ';'
# {"status":"SUCCESS","cloudflare":"enabled","records":[{"id":"395077081","name":"lammer.top","type":"A","content":"185.253.19.3","ttl":"600","prio":"0","notes":""}]}

# curl --header "Content-Type: application/json" \
# 	--request POST \
# 	--data "{ \
# 		\"apikey\" : \"$ak\", \
# 		\"secretapikey\" : \"$sk\" \
# 	}" \
# 	$api/dns/retrieveByNameType/lammer.top/A/*
# echo -n ';'
# {"status":"SUCCESS","cloudflare":"enabled","records":[{"id":"394904179","name":"*.lammer.top","type":"A","content":"185.253.19.3","ttl":"600","prio":"0","notes":""}]}



echo -n " lammer.top:"
# {"id":"395077081","name":"lammer.top","type":"A","content":"185.253.19.3","ttl":"600","prio":"0","notes":""}
curl -s --header "Content-Type: application/json" \
	--request POST \
	--data "{ 
		\"secretapikey\" : \"$sk\",
		\"apikey\" : \"$ak\",
		\"name\" : \"@\",
		\"type\" : \"A\",
		\"content\" : \"$ipv4\",
		\"ttl\" : \"600\"
	}" \
	$api/dns/edit/lammer.top/395077081
echo -n ';'

echo -n " *.lammer.top:"
# {"id":"394904179","name":"*.lammer.top","type":"A","content":"185.253.19.3","ttl":"600","prio":"0","notes":""}
curl -s --header "Content-Type: application/json" \
	--request POST \
	--data "{ 
		\"secretapikey\" : \"$sk\",
		\"apikey\" : \"$ak\",
		\"name\" : \"*\",
		\"type\" : \"A\",
		\"content\" : \"$ipv4\",
		\"ttl\" : \"600\"
	}" \
	$api/dns/edit/lammer.top/394904179
# curl -s --header "Content-Type: application/json" \
# 	--request POST \
# 	--data "{ 
# 		\"apikey\" : \"$ak\",
# 		\"secretapikey\" : \"$sk\",
# 		\"content\" : \"$ipv4\",
# 		\"ttl\" : \"600\"
# 	}" \
# 	$api/dns/editByNameType/lammer.top/A/%40
echo -n ';'
