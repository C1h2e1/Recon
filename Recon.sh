#!/bin/bash
altdns()
{
python -m altdns
}
httprobe()
{
	go run /Users/mac/Desktop/tools/httprobe/main.go
}
sudo curl -x 127.0.0.1:1087 -o Endpoint.txt http://web.archive.org/cdx/search/cdx/search/cds?url=*.$1/*&output=text&fl=original&collapse=urlkey
curl -x 127.0.0.1:1087  http://index.commoncrawl.org/CC-MAIN-2018-22-index\?url\=\*.$1\&output\=json |jq .url >>Endpoint.txt
curl -x 127.0.0.1:1087 https://crt.sh/?q=%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >>$1.txt
curl -x 127.0.0.1:1087 https://www.threatcrowd.org/searchApi/v2/domain/report/\?domain=$1 |jq .subdomains |grep -o '\w.*$1' >>$1.txt
curl -x 127.0.0.1:1087 https://api.hackertarget.com/hostsearch/\?q\=$1 | grep -o '\w.*$1' >>$1.txt
curl -x 127.0.0.1:1087 https://certspotter.com/api/v0/certs?domain=$1 | grep  -o '\[\".*\"\]' |grep -o '\w.*.$1' >>$1.txt
grep -v '^$' $1.txt|grep -v "*" >>ok.txt
nslookup $1 | grep -m2 Address | tail -n1 | cut -d : -f 2 |tee -a ip_$1.txt
for ip in `cat ip_$1.txt`
do
curl -x 127.0.0.1:1087 -X GET https://ipinfo.io/${ip} |jq .org
done
cat ok.txt |httprobe -c 50 >>$1_live.txt
cat Endpoint.txt |sort -u >>$1_files.txt
cat $1.txt |sort -u >>$1
cat $1_files.txt |sort -u|grep -v 'png'|grep -v 'jpg'|grep -v 'jpeg'|grep -v 'gif'|grep -v 'css'|grep -v 'woff'| grep -v 'ico'  >>$1_Final.txt
cat $1_files.txt |grep 'js' >>$1_js.txt
rm $1.txt
rm $1_files.txt
rm ok.txt
rm Endpoint.txt
rm ip_$1.txt
#altdns -i $1  -w words.txt -r -s altdns_$1.txt
#./meg paths.txt $1_live.txt #meg https://github.com/tomnomnom/meg
#./meg --verbose --rawhttp /%%0a0afoo:bar $1
#grep -Hnri '(footle<|"bootle")' out/
#grep -Hnri 'sftp_flags' out/
#grep -Hnri 'User-agent:' out/
#grep -Hnri '< Set-Cookie: crlf' out/
#grep -Hnri 'favicon.ico' out/
#grep -Hnri 'Location: //example' out/
echo_URL(){
echo https://censys.io/ipv4?q=$1
echo 'shodan_asn+censys '
}
screenshot(){
mv $1_live.txt ~/Desktop/tools/webscreenshot/
python3 webscreenshot.py -i $1_live.txt
cd screenshot
sudo sh run.sh
python -m SimpleHTTPServer 
echo "http://192.168.31.252:8000"
}
Port_Scan(){
for subdomain in `cat $1`
do
nmap -sV -T3 -Pn -p2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,19000,19080 ${subdomain}
done
}
