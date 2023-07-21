#!/bin/sh 

# Extract the desired variables using jq
name=$(jq -r '.name' default.json)
email=$(jq -r '.email' default.json)
port=$(jq -r '.port' default.json)
sni=$(jq -r '.sni' default.json)
path=$(jq -r '.path' default.json)
keys=$(xray x25519)
pk=$(echo "$keys" | awk '/Private key:/ {print $3}')
pub=$(echo "$keys" | awk '/Public key:/ {print $3}')
serverIp=$(curl -s ifconfig.io)
uuid=$(xray uuid)
shortId=$(openssl rand -hex 8)
json=$(curl -s https://git.sr.ht/~bak96/xr/blob/master/config.json)

url="vless://$uuid@$serverIp:$port?type=http&security=reality&encryption=none&pbk=$pub&fp=chrome&path=$path&sni=$sni&sid=$shortId#$name"

newJson=$(echo $json | jq  \
    --arg pk "$pk" \
    --arg uuid "$uuid" \
    --arg port "$port" \
    --arg sni "$sni" \
    --arg path "$path" \
    --arg email "$email" \
     '.inbounds[0].port = '$port' |
     .inbounds[0].settings.clients[0].email = $email |
     .inbounds[0].settings.clients[0].id = $uuid |
     .inbounds[0].streamSettings.realitySettings.dest = $sni + ":443" |
     .inbounds[0].streamSettings.realitySettings.serverNames += ["'$sni'", "www.'$sni'"] |
     .inbounds[0].streamSettings.realitySettings.privateKey = $pk |
     .inbounds[0].streamSettings.realitySettings.shortIds += ["'$shortId'"]')

echo $newJson | tee /etc/xray/config.json  >/dev/null

#echo "$url"
#qrencode -s 120 -t ANSIUTF8 "$url"
#qrencode -s 50 -o qr.png "$url"

#RUNING 

/usr/bin/xray -confdir=/etc/xray -format=json

exit 0
