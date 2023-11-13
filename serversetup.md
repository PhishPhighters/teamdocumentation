## Instructions for setting up the new ubuntu server

>These instructions in the CLI on Ubuntu
- check for updates (sudo apt update && sudo apt upgrade -y)
- sudo apt install cifs-utils
- sudo apt-get install nano
- sudo apt install samba
- sudo apt-get install ufw

- sudo ufw allow 22
- sudo ufw status

- sudo systemctl restart ssh
- sudo service ssh status

- sudo mkdir /home/guest
- sudo nano /etc/samba/smb.conf
    - add:
       >[shared]
       >path = /home/guest
       >writable = yes
       >guest ok = no
       >read only = no
       >create mask = 0777
       >directory mask = 0777
       >server signing = mandatory
       >client signing = mandatory

- sudo systemctl restart smbd

- sudo smbpasswd -a username (use unique name)

>Router
- Set static IP for server

>These instructions in windows 
- Test SSH with username@serverip (then logout)
- File Explorer -> Map network drive:
    - serverip\shared
    - use different credentials (samba creds)