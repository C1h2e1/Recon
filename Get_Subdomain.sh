mkdir $1
curl -x 127.0.0.1:12333 -sX GET "http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$1&output=json" | jq -r .url | sort -u >>endpoint.txt
curl -x 127.0.0.1:12333 https://crt.sh/?q=%.$1 | grep "$1" | cut -d '>' -f2 | cut -d '<' -f1 | grep -v " " | sort -u >> $1.txt.bak
curl -x 127.0.0.1:12333 --connect-timeout 1 -m 20 "http://dns.bufferover.run/dns?q=.$1" | jq -r '.FDNS_A[],.RDNS[]' | awk -F ',' '{print $2}' | sort -u >> $1.txt.bak
sort -u $1.txt.bak >>$1.txt
sudo python schema.py $1.txt >>$1_schema.txt
sudo python status_code.py $1_schema.txt
sudo rm $1.txt.bak
cd webscreenshot
python2 webscreenshot.py -i ../live.txt -P 127.0.0.1:12333 -t 30 -s
cd ../
echo "subjs Start"
cat endpoint.txt |go run subjs.go | grep 'http.*.js' -o >>$1_js.txt
cat $1_schema.txt | go run subjs.go | grep 'http.*.js' -o >>$1_js.txt |sort -u $1_js.txt
cat $1_js.txt
echo "LinkFinder Start"
mv $1.txt $1
mv $1_schema.txt $1
mv live.txt $1
mv fuzz_it.txt $1
mv endpoint.txt $1
mv $1_js.txt /home/c1h2e1/Documents/LinkFinder/
cd /home/c1h2e1/Documents/LinkFinder/
cat $1_js.txt | sudo sh LINKFINDER.sh 
mv /home/c1h2e1/Documents/LinkFinder/$1_js.txt /home/c1h2e1/Desktop/recon/$1
echo "file:///home/c1h2e1/Documents/LinkFinder/"
echo "file:///home/c1h2e1/Desktop/recon/$1"
mv /home/c1h2e1/Desktop/recon/webscreenshot/screenshots/*.png /home/c1h2e1/Desktop/recon/$1
