# EXTRAORDINARY CBT
ExtraOrdinary CBT (VPS Ubuntu)

Tested on : Ubuntu 20.04

## Installation (IP No Domain)

```bash
git clone https://github.com/smkn1kejobong/exocbt
cd exocbt
chmod +x configure-ip.sh
./configure-ip.sh
```
## Installation (Domain)
Note:

Diperlukan konfigurasi DNS Secara Manual Sebelum menjalankan script

Diperlukan setidaknya 1 main domain dan 2 subdomain atau 3 subdomain

Misalkan
```bash
cbtexo.com [MAIN DOMAIN][Client]
panel.cbtexo.com [SUB DOMAIN 1][AdminPanel]
socket.cbtexo.com [SUB DOMAIN 2][Socket]

atau

client.cbtexo.com [SUB DOMAIN 1][Client]
panel.cbtexo.com [SUB DOMAIN 2][AdminPanel]
socket.cbtexo.com [SUB DOMAIN 3][Socket]
```


```bash
git clone https://github.com/smkn1kejobong/exocbt
cd exocbt
chmod +x configure-domain.sh
./configure-domain.sh
```


