curl -x 127.0.0.1:1087 -o Endpoint.txt http://web.archive.org/cdx/search/cdx/search/cds?url=*.$1/*&output=text&fl=original&collapse=urlkey
curl -x 127.0.0.1:1087 -o $1_Endpoint.txt http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$1&output=json 
curl -x 127.0.0.1:1087 https://crt.sh/?q=%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >>$1.txt
curl -x 127.0.0.1:1087 https://www.threatcrowd.org/searchApi/v2/domain/report/\?domain=$1 |jq .subdomains |grep -o '\w.*$1' >>$1.txt
curl -x 127.0.0.1:1087 https://api.hackertarget.com/hostsearch/\?q\=$1 | grep -o '\w.*$1' >>$1.txt
curl -x 127.0.0.1:1087 https://certspotter.com/api/v0/certs?domain=$1 | grep  -o '\[\".*\"\]' |grep -o '\w.*.$1' >>$1.txt
cat $1_Endpoint.txt | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*"  >>Endpoint.txt
cat Endpoint.txt |sort -u >>$1_files.txt
cat $1.txt |sort -u >>$1
cat seebug.org_files.txt |grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" |sort -u >>Final.txt
rm $1.txt
rm Endpoint.txt
rm $1_Endpoint.txt
rm $1_files.txt
