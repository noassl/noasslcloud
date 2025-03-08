#!/bin/bash

# env file sourcen: https://stackoverflow.com/a/43267603/11864516
set -a
source .env.sh
set +a

current_ip=$(curl -s 'https://api.ipify.org')

if [ "$current_ip" == "$current_cloudflare_ip" ]; then
	echo "IP address unchanged."
	return 0
fi

export current_cloudflare_ip="$current_ip"

for record in "${!DNS_RECORDS[@]}"; do
  name=${DNS_RECORDS[$record]}

  curl --request PUT \
    --url "https://api.cloudflare.com/client/v4/zones/ae6319a2837df20a106a61e11313816c/dns_records/${record}" \
    --header "Content-Type: application/json" \
    --header "X-Auth-Email: $CLOUDFLARE_EMAIL" \
    --header "Authorization: Bearer $CLOUDFLARE_TOKEN" \
    --data '{
      "comment": "Automatic update (NUC)",
      "name": "'"$name"'",
      "proxied": true,
      "ttl": 1,
      "content": "'"$current_ip"'",
      "type": "A"
    }'
done
