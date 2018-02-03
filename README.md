# Bash-Archiv Projektübersicht

## AdAway for DNSmasq
Konfiguriert DNSmasq als DNS Relay Server und blockiert AdServer, die Server liste wird von AdAway automatisch heruntergeladen und angewendet (IPv4 & IPv6). Eine automatische aktualisierung kann über <code>cron</code> erreicht werden.

## CSGO Server Installer

Ein einfaches CSGO Server installations Script, mit Benutzerabfrage.
Dabei installiert das Script auch steamCMD.

## Cloudflare DynDNS

Hier wird ein Cloudflare A oder AAAA Record dynamisch über die Cloudflare API aktualisiert werden.
Hier in diesem Script, wird die WAN IP einer FritzBox ausgelesen und mit der IP im Cloudflare A Record abgeglichen. Unterscheiden sich beide Adressen, wird die FritzBox IP in den A Record geschrieben.
Das einbinden über <code>cron</code> ist möglich.

## Cloud Deploy

Könne als ein eigenes Repository gesehen werden, hier werden alle Cloud Server Scripts aingestellt, auszeichen tuen diese sich, durch die tatsache das sie silent ausgeführt werden. Und somit ein "One Klick" Deploy möglich ist.<p>
Bisher eingestellte Scripts:<p>
+ Standard Deploy (Systemvorbereitung) 
+ CSGO Deploy ("One Klick" CSGO Server installer)

## iptables Firewalls
### iptables firewall whitelisted
IP whitelisting von Deutschsprachigen ländern auf einen Host.
### region whitelist
Hier wird eine iptables Whitelist Script dynamisch erstellt, das Whitelisting ist Anwendungsbezogen (eine Port und Protokoll angabe ist erforderlich) die erstellte Whitelist Konfiguration wird im anschluss per iptables geladen.
Verwendeter iptables Syntax: <code> iptables -A INPUT -p udp --dport 53 -s 8.8.8.8 -j ACCEPT</code>

## Sinusbot Installer

Sinusbot multi installer, installiert unbegrenz viele Sinusbots Bots auf einmal. (Hat aber noch ein paar Macken. Die conig.ini muss manuell bearbeitet werden.)
