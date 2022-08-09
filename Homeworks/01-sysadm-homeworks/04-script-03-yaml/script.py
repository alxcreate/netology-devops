import json
import yaml
import socket
from time import sleep

List = {
    'drive.google.com': '',
    'mail.google.com': '',
    'google.com': ''
}


while True:
    for Name in List:
        ip = socket.gethostbyname(Name)
        print(f'{Name} - {ip}')
        with open(f'{Name}.json', 'w') as jsn:
            jsn.write(json.dumps({Name: ip}))
        with open(f'{Name}.yaml', 'w') as yml:
            yml.write(yaml.dump([{Name: ip}]))
        if ip != List[Name]:
            print(f'[ERROR] {Name} IP mismatch: {List[Name]} {ip}')
        List[Name] = ip
    sleep(10)

