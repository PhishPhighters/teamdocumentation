## Instructions for setting up the new ubuntu server

>These instructions in the CLI on Ubuntu
- check for updates (sudo apt update && sudo apt upgrade -y)
- sudo apt install cifs-utils
- sudo apt-get install nano
- sudo apt install samba
- sudo apt-get install ufw

- sudo ufw allow 22
- sudo ufw allow 139/tcp
- sudo ufw allow 445/tcp
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
       >passdb backend = smbpasswd

- sudo systemctl restart smbd

- sudo adduser username
- sudo smbpasswd -a username (use system name)

>Router
- Set static IP for server

>These instructions in windows 
- Test SSH with username@serverip (then logout)
- Check that the Firewall allows outbound port 139 & 445 (**Run as administrator**) - these commands won't work for me, but not sure why? Will come back.
    - New-NetFirewallRule -DisplayName "Allow Outbound TCP 139" -Direction Outbound -Protocol TCP -LocalPort 139 -Action Allow
    - New-NetFirewallRule -DisplayName "Allow Outbound TCP 445" -Direction Outbound -Protocol TCP -LocalPort 445 -Action Allow

- Enable Network Discovery?
- File Explorer -> Map network drive:
    - serverip\shared
    - use different credentials (samba creds)