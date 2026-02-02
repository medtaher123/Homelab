# CUPS Network Printing Setup Guide 🖨️

**CUPS** (Common Unix Printing System) is the standard printing system for Linux and macOS. It allows you to share a USB printer connected to your server over the network, so any device on your LAN can print without physically connecting to the printer. 

If you have a printer that doesn't support network connectivity, CUPS turns your server into a print server—connect the printer via USB once, and print from anywhere on your network. 📡

---

## The Story: Why I Set This Up 📖

So I have this printer. It's a perfectly good printer—prints fine, decent quality, no complaints. There's just one tiny problem: **it doesn't connect to the network**. You know, the kind of printer that was born before Wi-Fi became a standard feature. 😅

At first, I thought "no big deal, I'll just use USB." Which worked great... until I wanted to print something from my phone. Or my laptop. Or literally any device that wasn't already plugged into the printer. The routine became:

1. Realize I need to print something
2. Get up from my desk
3. Walk to the printer with my phone/laptop
4. Fumble with the USB cable
5. Finally print
6. Walk back
7. Repeat this dance every single time

After doing this printer pilgrimage for the hundredth time, I thought: *"I have a server running 24/7 in my homelab... surely there's a better way?"* 💡

Enter CUPS. I connected the printer to my server via USB **once**, configured CUPS, and boom—network printing from anywhere in the house. No more walking to the printer. No more cable juggling. Just hit print from my phone while on the couch, and the printer does its thing. 

It's one of those "why didn't I do this sooner?" moments. Best part? It works with literally any device on my network—Linux, Windows, macOS, Android, iOS—everyone gets to print without moving. Living in the future feels good. 🚀

---

## Why Use CUPS? 🤔

* **Network Printing**: Share a USB printer over your network without buying a network-enabled printer.
* **Multi-Platform Support**: Print from Windows, macOS, Linux, Android, and iOS devices.
* **Web Interface**: Manage printers, jobs, and settings through an easy-to-use web UI.
* **No Printer Limitations**: Works with almost any USB printer that has Linux drivers.
* **Centralized Management**: One server handles all print jobs for your homelab.
* **Cost-Effective**: Reuse old USB printers instead of buying expensive network printers.

Perfect for homelabs where you want to share a non-network printer across all your devices.

---

## Installation Steps 🚀

### 1. Install CUPS

Install CUPS on your server:

```bash
sudo apt update
sudo apt install cups
```

### 2. Add Your User to the CUPS Admin Group

To manage CUPS, add your user to the `lpadmin` group:

```bash
sudo usermod -aG lpadmin $USER
```

Log out and back in for the changes to take effect.

### 3. Configure CUPS for Network Access

By default, CUPS only listens on localhost. To access it from other devices on your network, edit the configuration:

```bash
sudo nano /etc/cups/cupsd.conf
```

Find the section that looks like this:

```
# Only listen for connections from the local machine.
Listen localhost:631
```

Change it to listen on all interfaces:

```
# Listen on all network interfaces
Port 631
```

Then, allow network access by modifying the `<Location />` sections. Find:

```
<Location />
  Order allow,deny
</Location>
```

And change it to:

```
<Location />
  Order allow,deny
  Allow @LOCAL
</Location>
```

Do the same for `<Location /admin>` and `<Location /admin/conf>`:

```
<Location /admin>
  Order allow,deny
  Allow @LOCAL
</Location>

<Location /admin/conf>
  AuthType Default
  Require user @SYSTEM
  Order allow,deny
  Allow @LOCAL
</Location>
```

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).

### 4. Restart CUPS

Apply the configuration changes:

```bash
sudo systemctl restart cups
```

### 5. Connect Your USB Printer

1. Plug your printer into the server via USB
2. Check if the printer is detected:
   ```bash
   lsusb
   ```
   You should see your printer in the list.

### 6. Add the Printer via Web Interface

1. Open the CUPS web interface in your browser:
   ```
   http://<server-ip>:631
   ```

2. Go to **Administration** → **Add Printer**

3. Log in with your server username and password (the user must be in the `lpadmin` group)

4. Select your USB printer from the list of **Local Printers**

5. Give it a name and description, and check **Share This Printer**

6. Select the printer manufacturer and model (CUPS will provide a list of drivers)

7. Click **Add Printer** and configure default settings (paper size, quality, etc.)

Your printer is now shared on the network! 🎉

---

## Accessing the Printer from Different Devices 📱💻

### **Linux**

1. Open **Settings** → **Printers**
2. Click **Add Printer**
3. Your CUPS printer should appear automatically (via network discovery)
4. Select it and click **Add**

Alternatively, use the command line:

```bash
lpstat -p -d
```

To print a test page:

```bash
lp -d <printer-name> /usr/share/cups/data/testprint
```

### **Windows**

1. Go to **Settings** → **Devices** → **Printers & Scanners**
2. Click **Add a printer or scanner**
3. Click **The printer that I want isn't listed**
4. Select **Add a printer using a TCP/IP address or hostname**
5. Enter your server's IP address (e.g., `192.168.1.100`) and port `631`
6. Choose **Internet Printing Protocol (IPP)** or **HTTP**
7. Windows will detect the printer and install drivers

Alternatively, you can use the IPP URL:

```
http://<server-ip>:631/printers/<printer-name>
```

### **macOS**

1. Go to **System Preferences** → **Printers & Scanners**
2. Click the **+** button to add a printer
3. Your CUPS printer should appear automatically
4. Select it and click **Add**

macOS supports IPP natively, so detection is usually automatic.

### **Android**

1. Install a printing plugin like **Google Cloud Print** or **Mopria Print Service** (available on Google Play)
2. Open the document or photo you want to print
3. Tap **Share** → **Print**
4. Select your CUPS printer (it should appear automatically)

Alternatively, you can use apps like **PrintHand** or **PrinterShare** that support IPP printing.

### **iOS (iPhone/iPad)**

1. iOS supports AirPrint, but CUPS needs additional configuration for AirPrint support
2. Alternatively, use apps like **Printer Pro** or **PrintCentral** that support IPP printing
3. Enter the IPP URL: `http://<server-ip>:631/printers/<printer-name>`

For native AirPrint support, you'll need to install **avahi-daemon** and configure it (see the AirPrint section below).

---

## Optional: Enable AirPrint for iOS Devices 🍎

To make your CUPS printer AirPrint-compatible for iPhones and iPads:

### 1. Install Avahi

```bash
sudo apt install avahi-daemon
```

### 2. Create an AirPrint Service File

```bash
sudo nano /etc/avahi/services/airprint.service
```

Add the following (replace `<printer-name>` with your actual printer name):

```xml
<?xml version="1.0" standalone='no'?>
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
  <name replace-wildcards="yes">AirPrint %h</name>
  <service>
    <type>_ipp._tcp</type>
    <subtype>_universal._sub._ipp._tcp</subtype>
    <port>631</port>
    <txt-record>txtver=1</txt-record>
    <txt-record>qtotal=1</txt-record>
    <txt-record>rp=printers/<printer-name></txt-record>
    <txt-record>ty=<Printer Description></txt-record>
    <txt-record>adminurl=http://<server-ip>:631/printers/<printer-name></txt-record>
    <txt-record>note=<Printer Location></txt-record>
    <txt-record>priority=0</txt-record>
    <txt-record>product=(GPL Ghostscript)</txt-record>
    <txt-record>printer-state=3</txt-record>
    <txt-record>printer-type=0x801046</txt-record>
    <txt-record>Transparent=T</txt-record>
    <txt-record>Binary=T</txt-record>
    <txt-record>Fax=F</txt-record>
    <txt-record>Color=T</txt-record>
    <txt-record>Duplex=T</txt-record>
    <txt-record>Staple=F</txt-record>
    <txt-record>Copies=T</txt-record>
    <txt-record>Collate=F</txt-record>
    <txt-record>Punch=F</txt-record>
    <txt-record>Bind=F</txt-record>
    <txt-record>Sort=F</txt-record>
    <txt-record>Scan=F</txt-record>
    <txt-record>pdl=application/octet-stream,application/pdf,application/postscript,image/jpeg,image/png,image/urf</txt-record>
    <txt-record>URF=none</txt-record>
  </service>
</service-group>
```

### 3. Restart Avahi

```bash
sudo systemctl restart avahi-daemon
```

Your printer should now appear as an AirPrint printer on iOS devices! 📱

---

## Printer Management via Command Line 🖥️

### Check Printer Status

```bash
lpstat -p -d
```

### Print a Test Page

```bash
lp -d <printer-name> /usr/share/cups/data/testprint
```

### View Print Queue

```bash
lpq
```

### Cancel a Print Job

```bash
cancel <job-id>
```

Or cancel all jobs:

```bash
cancel -a
```

### Set Default Printer

```bash
lpoptions -d <printer-name>
```

---

## Troubleshooting 🔧

### Printer Not Detected

- Check if the USB printer is connected: `lsusb`
- Restart CUPS: `sudo systemctl restart cups`
- Check CUPS logs: `sudo tail -f /var/log/cups/error_log`

### Cannot Access Web Interface

- Make sure CUPS is listening on all interfaces (port 631)
- Check firewall rules: `sudo ufw allow 631/tcp`
- Verify CUPS is running: `sudo systemctl status cups`

### Printer Not Appearing on Network

- Ensure **Share This Printer** is checked in the CUPS web interface
- Restart CUPS: `sudo systemctl restart cups`
- For AirPrint, make sure `avahi-daemon` is running: `sudo systemctl status avahi-daemon`

### Permission Denied

- Ensure your user is in the `lpadmin` group: `groups`
- Log out and back in after adding the user to the group

### Print Jobs Stuck in Queue

- Check printer status: `lpstat -p`
- Cancel stuck jobs: `cancel -a`
- Restart CUPS: `sudo systemctl restart cups`

---

## Security Considerations 🔒

* **Firewall**: Only allow port 631 from your local network:
  ```bash
  sudo ufw allow from 192.168.1.0/24 to any port 631
  ```

* **Authentication**: CUPS requires authentication for admin tasks. Use strong passwords.

* **Encryption**: For sensitive documents, consider using CUPS over SSL (requires additional configuration).

* **Network Restrictions**: Use the `Allow @LOCAL` directive to restrict access to your local network only.

---

## Useful Links 🔗

* [CUPS Official Website](https://www.cups.org/)
* [CUPS Documentation](https://www.cups.org/doc/)
* [CUPS on Ubuntu Documentation](https://ubuntu.com/server/docs/service-cups)
* [CUPS Command-Line Tools](https://www.cups.org/doc/man-lp.html)
* [AirPrint Setup Guide](https://github.com/tjfontaine/airprint-generate)
* [Avahi Documentation](https://www.avahi.org/)

---

## Tips & Notes 💡

* **Driver Compatibility**: If your printer isn't automatically detected, check the [OpenPrinting Database](https://openprinting.org/printers) for Linux-compatible drivers.
* **Network Discovery**: Most modern devices will auto-detect CUPS printers via Bonjour/Zeroconf/mDNS.
* **Pi-hole Integration**: If using Pi-hole, ensure it doesn't block mDNS traffic for printer discovery.
* **Backup Configuration**: Backup `/etc/cups/` folder to preserve printer settings.
* **Multiple Printers**: You can connect multiple USB printers to the same server and share them all.
* **Print from Anywhere**: Combine CUPS with a VPN to print remotely when away from home.

---

> This folder contains notes and configuration examples to help you set up CUPS network printing on your homelab. Enjoy printing from anywhere on your network! 🎉
