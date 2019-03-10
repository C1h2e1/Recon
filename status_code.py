import queue
import sys
import requests
import threading
filename=sys.argv[1]

f=open(filename,'r')
save=open('live.txt','a')
q = queue.Queue()
def get_code(target,save):
	fi=open('fuzz_it.txt','a')
	proxies = {
    "http": "http://127.0.0.1:12333",
    'https': 'http://127.0.0.1:12333'
}
	headers={'user-agent':'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36'}
	code=[403,404,302,301]
	req=requests.get(target,headers=headers,proxies=proxies,timeout=2)
	if req.status_code == 200 :
		save.write(target+'\n')
	elif req.status_code in code :
		fi.write(target+'\n')
		print(target+str(req.status_code))
def main(f,save,q):
	global target
	for target in f.readlines() :
		target=target.strip('\n')
		q.put(target)
		while not q.empty():
			target=q.get()
			try:
				get_code(target,save)
			except :
				print("pass")
				pass
main(f,save,q)	
