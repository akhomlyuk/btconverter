#!/bin/bash

red='\033[0;31m'
green='\033[1;32m'
yellow='\033[1;33m'
nyellow='\033[0;33m'
purple='\033[0;35m'
ngreen='\033[0;32m'
cyan='\033[1;36m'
blue='\033[0;34m'
reset='\033[0m'

if [ $# -ne 1 ]; then
  echo -e "Usage: $0 $yellow<ticket.b64|kirbi|ccache>$reset"
  echo ""
  echo -e $green"Created by Exited3n | https://t.me/pt_soft"$reset
  echo ""
  exit 1
fi

input_file=$1
output_file=""

if [[ $input_file == *.b64 ]]; then
  output_file=${input_file%.b64}.ccache
  cat "$input_file" | base64 -d > "${input_file%.b64}.kirbi"
  impacket-ticketConverter "${input_file%.b64}.kirbi" "$output_file"
  export KRB5CCNAME="$output_file"
  echo -e $yellow"[+] ccache ticket: $(pwd)/$output_file"$reset
  echo -e $yellow"[+] export KRB5CCNAME=$output_file"$reset
  echo -e $purple"[+] export complete"$reset

elif [[ $input_file == *.kirbi ]]; then
  output_file=${input_file%.kirbi}.ccache
  impacket-ticketConverter "$input_file" "$output_file"
  export KRB5CCNAME="$output_file"
  echo -e $yellow"[+] ccache ticket: $(pwd)/$output_file"$reset
  echo -e $yellow"[+] export KRB5CCNAME=$output_file"$reset
  echo -e $purple"[+] export complete"$reset

elif [[ $input_file == *.ccache ]]; then
  output_file=${input_file%.ccache}.kirbi
  impacket-ticketConverter "$input_file" "$output_file"
  b64_file=${output_file%.kirbi}.kirbi
  cat "$b64_file" | base64 | tr -d '\n' > "${b64_file%.kirbi}.b64"
  echo -e "$nyellow"
  cat ${b64_file%.kirbi}.b64
  echo -e "$reset"
  echo ""
  echo -e $cyan"[!] Now you can use PassTheTicket: Rubeus.exe ptt /ticket:doIGEjCCB(..snip..)0NBTA=="$reset
  echo ""
  echo -e $yellow"[+] kirbi ticket: $(pwd)/$output_file"$reset
  echo -e $yellow"[+] base64 encoded ticket: $(pwd)/${b64_file%.kirbi}.b64"$reset

else
  echo -e $red"[-] Unsupported file extension. Use one of this [.b64, .kirbi or .ccache]"$reset
  exit 1
fi

echo ""
echo -e $green"Created by Exited3n | https://t.me/pt_soft"$reset
echo ""
