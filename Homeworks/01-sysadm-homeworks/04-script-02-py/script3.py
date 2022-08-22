import socket
from time import sleep

List = {
    "drive.google.com": '',
    "mail.google.com": '',
    "google.com": ''
}
while True:
    for Name in List:
        ip = socket.gethostbyname(Name)
        if ip != List[Name]:
            print(f'[ERROR] {Name} IP mismatch: {List[Name]} {ip}')
        else:
            print(f'{Name} - {ip}')
            List[Name] = ip
    sleep(10)
