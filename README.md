# Open5GS + srsRAN

Core: Open5GS
gNodeB: srsRAN
UE: Samsung Galaxy S21

IMS kamailio?

## Open5GS

Debian 11 VM
Note: Open5GS doesn't like 12's libcurl: `[sbi] WARNING: ogs_sbi_client_handler() failed [-1] (../lib/sbi/path.c:62)`

Installed Open5GS from osmocom Debian repo

Installed WebUI from git as per instructions

Configuration attached, based off Open5GS quickstart
 - PLMN 00101
 - net name ARFNET
 - Corrected bind IP addresses, rest left at localhost

Added two UEs via WebUI, one sysmoISIM SIM #178, other made up for UERANSIM

Applied quickstart sysctl and NAT rules from quickstart

Start only neccesary services for 5G SA: smf, upf, nrf, scp, ausf, udm, pcf, nssf, bsf, udr, amf, [webui] in that order (not limited to)

## srsRAN

Baremetal Debian 12 desktop
N78 band, should change to that selfprovisioning N40 band (CNAF UN-50)

Software: srsRAN 5G
Hardware: USRP B200 mini with Leo GPSDO

Configuration based off the default `gnb_rf_b200_tdd_n78_20mhz.yml`
 - PLMN 00101
 - AMF IP address points to Open5GS

## UERANSIM

Same baremetal desktop

Default custom config, just
 - point to Open5GS
 - PLMN 00101
 - comment out sd in N-SSAI matching core

## UE

Model: Samsung Galaxy S21
SIM: sysmoISIM-SJA5-S17 #178

Changed SIM IMSI PLMN to 00101 with pySIM, everything left as is

Insert in SIM slot 2 (the other is populated with an AVANZAFIBRA one)
Mobile data to SIM slot 2
Manual network selection -> ARFNET

 - ARFNET appears in the network list
 - Registration successful
 - Gets IPv4 address and route

## Debugging

Attach wireshark to baremetal desktop, filter by SCTP and GTP to core

Attach tcpdump to core

