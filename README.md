
# MyVeeam Report for Veeam Backup & Replication v11a and v12
Original script taken from Marco Horstmann Repo, as I needed some automation that could send out reports without having to spin up Veeam One for a small environment.

Tested under Hyper-V with Veeam v12. Added additional configuration for sending emails, so that I could include CC and BCC emails.

## What’s New
See changelog within the main script for updates.

## Download
You can download the installer with the following oneliner:

```Invoke-WebRequest -UseBasicParsing https://raw.githubusercontent.com/znabel-a/MyVeeamReport/refs/heads/main/Install.ps1 -OutFile c:\temp\install.ps1```

Edit the install.ps1 file to suit your needs.

## Disclaimer
This project is made with love for Powershell, Veeam, Virtualisation and automation.

## Contribution
Thanks to [Marco Horstmann](https://github.com/marcohorstmann/MyVeeamReport) for making an updated version available on github. 
