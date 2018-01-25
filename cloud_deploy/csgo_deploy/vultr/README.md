# Vultr CSGO Cloud Deploy

## Und was kann das ?

[Vultr](https://vultr.com) ist ein Cloud Server Anbieter, mit Stundengenauer abrechnung. Das hier gezeigte Script ist ein "One klick" installer für einen CSGO Server.
Das tolle daran ist, es ist einfach möglich sich für ein paar Stunden einen Privaten Leistungsstarken CSGO Server zu erstellen und das ganze kostet nur ein paar Cents !

## Was bietet das Script für Funktionen ?

Das Script installiert einen 128 Tick CSGO Server und konfiguriert diesen, es werden Metamod und Sourcemod installiert, die Versionen lassen sich leicht anpassen. Zusätzlich werden je nach konfiguration plugins und maps installiert.
Das Script bietet die möglichkeit drei unterschiedliche Server Typen bereitzustellen

1. 1vs1 Wie der name schon sagt, handelt es sich um einen 1vs1 Server auf der Map aim_redline Weitere Maps können über die Console geladen werden. Diese Maps befinden sich noch im Maps Ordner (Alle Maps werden über einen FasDL Server bereitgestellt):
+ aim_dust2
+ aim_map_classic
+ aim_dust_go
+ aim_map
+ aim_prac_ak47

2. Diegel Es wird die Map aim_deagle7k geladen und in einen loop gesetzt, danch wird ein Only HS Plugin heruntergeladen und aktiviert. Jetzt kann man nur noch mit einem Deagle Headshoot schaden verursachen. :trollface:
3. MM Klassisches Community Competitive spielbar auf allen Maps die in CSGO Standardmäßig enthalten sind. Es können natürlich auch eigene Maps auf dem Server per sFTP geladen werden, dabei ist aber darauf zu achten, dass die Map bei allen spielern bereits im Maps Ordner vorhanden ist oder die Map auf dem [[OmG] Network FastDL](http://fastdl.omg-network.de/csgo/csgo/maps) Server verfügbar ist.

## Konfiguration des Scripts (Vultr Config)

Ausschnitt aus der <code>csgo_cloud_vultr_pre.sh</code>

```bash
# Game Settings
export GAME_TYPE=Diegel
export hostname="[OmG] Network DEV Server"
export sv_password="WaSd"
export rcon_password="lelek"
export sv_setsteamaccount=""
```
Unter <code>GAME_TYPE</code> muss einer der drei oben genannten Typen angegeben werden.<p>
<code>hostname</code> Name des Servers<p>
<code>sv_password</code> Passwort das benötigt wird um auf den Server zu kommen. (Möchte man kein Passwort setzen dann reicht <code>""</code> )<p>
<code>rcon_password</code> Passwort um vom CSGO Client Befehle an den Server zu senden. (Möchte man kein Passwort setzen dann reicht <code>""</code> )<p>
<code>sv_setsteamaccount</code> Hier muss der [Game Server Token](https://steamcommunity.com/dev/managegameservers?l=german) eingefügt werden :heavy_exclamation_mark: Ohne diesen Token startet der Server NICHT !
<br></br>
Die Anderen Optionen sollten selbsterklärend sein, wenn nicht lass bitte die finger davon :boom:<p>
(Kleiner Anriss, da man sich unter "<code>retry</code>" nicht viel vorstellen kann. Diese Option setzt die Wirderholungen fest, wie oft nach einem Fehlgeschlagenen CSGO Server Download erneut versucht werden soll diesen herunterzuladen.") 
```bash
# Download options
export metamod="https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git961-linux.tar.gz"
export sourcemod="https://sm.alliedmods.net/smdrop/1.8/sourcemod-1.8.0-git6040-linux.tar.gz"
export esl_cfg="http://fastdl.omg-network.de/csgo/esl.tar"

# Install options
export steamCMD=/opt/steamcmd
export server_inst_dir=/opt/server
export install_user_name=csgo
export retry=5
```
## Einbinden des Scripts auf Vultr

Um das Script nutzen zu können muss es bei [Vultr](https://vultr.com) unter "Startup Scripts" das <code>csgo_cloud_vultr_pre.sh</code> Script hinterlegt werden, dabei ist zu achten dass sich es um ein Script vom Type "Boot" handelt (Ist Standardmäßig ausgewählt...). Nachdem alle Optionen ensprechend Konfiguriert wurden, kann das Script gespeichert werden.

Und damit ist die Konfiguration auch schon abgeschlossen, jetzt kann unter "Server" auf dem :heavy_plus_sign: ein Server erstellt werden. Hier kann man jetzt eine Region für den Server wählen, danach kommt die Betriebssystem auswahl. Hier muss entwender Ubuntu oder Debian ausgewählt werden. Ein anderes OS wird nich unterstützt ! (Getestet wurde bisher auf Ubunut 14.04 / 16.04 und Debian 8 / 9). Im nächsten schritt wählt man den eigentlichen Server aus (Ich emfehle nicht unter 2 CPUs zu gehen). Die "Additional Features" können ignoriert werden. Als nächstes muss das zuvor angelegte Startup Scripts ausgewählt werden. Schritt 6 "SSH Keys" kann ebenfalls ignoriert werden. Bei Schritt 7 muss noch ein name für den Server eingetragen werden, dieser bezieht sich nur auf den Server und nicht auf den CSGO hostnamen.

Danach kann der Server "Deployt" werden, die installation des Server inclusive CSGO Server dauert rund 10 min. :grimacing:
