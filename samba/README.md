# Samba File Sharing Guide 📂

**Samba** is used for file sharing over a local area network (LAN).

## Installation

Install Samba with:

```
sudo apt install samba
```

## Configuring Shared Folders

Modify the directories you want to share in the configuration file:

```
sudo nano /etc/samba/smb.conf
```

Example configuration added:

```
[SharedFolder]
   path = <the path to the shared folder>
   browseable = yes
   read only = no
   valid users = <username>
   force user = <username>
```

## Restart Samba

After modifying the configuration, restart the Samba service:

```
sudo systemctl restart smbd
```

## Creating a Samba User

Add a Samba user with:

```
sudo smbpasswd -a <username>
```

When connecting from Windows, use this username and its password for authentication.
