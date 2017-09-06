# region_whitelist
Whitelistet alle Deutschsprachigen Länder auf bestimmte Ports

## Variablen

Es müssen 2 Variablen angepasst werden und das Script nutzen zu können

1.) Port: Der Port der Anwendung die nur von Deutschsprechigen Ländern aus erreichet werden soll<p>
2.) Protokoll TCP, UDP, usw...

## Achtung

Bei einer bestehenden Frewall Konfiguration ist darauf zu achen, dass das Script die Iptables Firewall mit "<code>iptables -F</code>" zurücksetzt heißt alle Firewall einstellugnen gehen verloren.<p>

Um das zu verhindern sollte der Code wie folgt erweitert werden:<p>
Zeile 59:
<code>
/pfad/deinFirewallScript.sh && $dir/iptables.sh &
</code>
