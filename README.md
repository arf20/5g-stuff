# Open5GS + srsRAN

Core: Open5GS
gNodeB: srsRAN
UE: Samsung Galaxy S21

IMS kamailio?

## Open5GS

Debian 11 VM (192.168.4.22)
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

osmocom's latest Open5GS build does not like latest srsRAN from git so here we use srsRAN github release 24.04

Baremetal Debian 12 desktop (192.168.4.8)
N40 band, f=2380 arfcn=476000 width=20MHz (CNAF UN-50 indicates that 2370-2390 is for self-provision mobile networks)

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

## State-of-the-art

Data works! Internet access check.

## Resources

### 5G

https://5g.systemsapproach.org/

### Open5GS

https://open5gs.org/open5gs/docs/guide/01-quickstart/

### srsRAN

https://github.com/srsRAN/srsRAN_Project

### VoNR

https://nickvsnetworking.com/
https://www.rfwireless-world.com/terminology/5g-vonr-architecture-call-flow
https://www.sharetechnote.com/html/5G/5G_VoNR.html

https://open5gs.org/open5gs/docs/tutorial/02-VoLTE-setup/
https://kamailioasterisk.com/2023/07/19/volte-setup-with-kamailio-ims-and-open5gs-open-source/
https://ryantheelder.github.io/blog/2023/VoLTE

https://www.kamailio.org/w/2013/05/ims-kamailio/

#### Install kamailio

In Open5GS debian 11 machine

Install kamailio 6.0 commit ba13699fab from git following `https://kamailio.org/docs/tutorials/6.0.x/kamailio-install-guide-git/` with dependencies from Dockerfile and modules.lst from `https://github.com/herlesupreeth/docker_open5gs/blob/master/ims_base/modules.lst`

 - mysql 127.0.0.1:3306
 - redis 127.0.0.1:6379
 - IMS
    - pcscf: 127.0.0.30:3871
    - scscf: 127.0.0.31:3870
    - icscf: 127.0.0.32:3869
    - rtpengine: 127.0.0.1:2223
    - pyhss: 127.0.0.33:3875, 0.0.0.0:8080
 - open5gs
    - scp: 127.0.0.200

Follow dockerfiles and scripts of `https://github.com/herlesupreeth/docker_open5gs/blob/master/sa-vonr-deploy.yaml`
 - https://github.com/herlesupreeth/docker_open5gs/blob/master/ims_base/Dockerfile
 - https://github.com/herlesupreeth/docker_open5gs/blob/master/icscf/icscf_init.sh
 - https://github.com/herlesupreeth/docker_open5gs/blob/master/pcscf/pcscf_init.sh


~Install rtpproxy from ubuntu at `http://es.archive.ubuntu.com/ubuntu/pool/universe/r/rtpproxy/rtpproxy_1.2.1-2.2ubuntu1_amd64.deb`~ lies actually, no rtpproxy

Proceed with configuration as per dockerfile

Attached systemd units under kamailio/ for running the pcscf, scscf and icscf as separate processes

#### rtpengine

Install rtpengine from `https://github.com/sipwise/rtpengine` following kamailioasterisk article

 - install libxtables-dev and libtirpc-dev
 - remove libiptables-dev from debian control file
 - patch recording.c (colliding name in pcap, non breaking)
 - ???
 - profit (build and install deb package)

Attached patch for above by me, apply over e1941be950c24875122630564aa059d98299d8d1

Keep following rtpengine guide but ignore the recording bit (we aren't the NSA)

#### PyHSS

Follow dockerfiles still

But: copy lib/ and services/ to /etc/pyhss/pyhss and install systemd units attached

Adding subscribers described in README https://github.com/herlesupreeth/docker_open5gs


#### Install VoLTE stuff to SIM

https://osmocom.org/projects/cellular-infrastructure/wiki/VoLTE_IMS_Android_Carrier_Privileges



