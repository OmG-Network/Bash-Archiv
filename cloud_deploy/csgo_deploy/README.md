# CSGO Cloud Server Deploy

## Was tut das Script ?

Dieses Script installiert einen 128 Tick CSGO Server, dabei kann man unter mehreren Spielmodies wählen **1vs1**, **Diegel only HS** und **Community MM**.<p>Ziel ist es einen CSGO Server mit diesem Script bereitzustellen, ohne viel Zeit mit der Installation / Konfiguration des Server zu stecken.<p>Dieses Script ist dafür konzipiert um auf einem Cloud Server ausgeführt zu werden. So kann man sich für ein paar Stunden einen Leistungsstarken CSGO Server anschaffen und das für nur ein paar Cents.

## Was bietet das Script für Funktionen ?
Die Einstellungs Parameter werden weiter unten im Detail beschrieben.<p>
Das Script installiert einen CSGO Server ohne Benutzereingabe, nach dem das Script konfiguriert und gestartet wurde, verläuft die Restlich Installation komplett im Hintergrund ab.<p>Der CSGO Server wird nach der Installation automatisch gestartet.<p>Es werden auch eigene Maps unterstützt. Um eine eigene Map auf den Server zu laden, wurde beim installieren eine Upload Seite eingerichtet diese ist unter ```http://(Eure Server IP)/upload``` zu erreichen (Diese Seite ist per Login gesichert).<p>Auf dieser Seite können zum einen neue Maps hochgeladen werden und zum anderen bietet die Seite auch eine Übersicht der Maps die bereits vorhanden sind. Alle Maps, die hochgeladen werden, können automatisch per FastDL bezogen werden. Workshop Maps oder Kollektionen werden momentan noch nicht unterstützt

## Konfigurierbare Parameter

Sind Parameter, die direkt im Script gesetzt werden müssen, um den CSGO Server entsprechend konfigurieren zu können.
Folgende Einstellungen gibt es:
+ **Game Server Options**
    + **GAME_TYPE** : Gibt an wie der Server konfiguriert werden soll. Zur auswahl stehen ```1vs1```, ```Diegel``` oder ```MM``` (Competitive). Zusätzlich liegen im cfg Verzeichniss alle ESL CFGs, diese können nachträglich über RCON geladen werden.
    + **hostname** : Ist der Wert für den CSGO Server Hostname, dieser Name ist im Server Browser (CSGO) sichtbar.
    + **sv_password** : Setzt ein CSGO Server Password, dass benötigt wird um sich auf den Server zu verbinden. Kein Passwort entspricht dem Wert ```""```

+ **FastDL Upload Portal**
    + **fastdl_user** : Gibt den Benutzernamen für das Coustom Map Upload Portal an. ```http://(Server IP)/upload```
    + **fastdl_passwd** : Gibt das Passwort für den **fastdl_user** an.
    + **php_max_upload** : Setzt die maximale Upload größe in MB für einzelne Map Dateien (Veränderte PHP Optionen ```upload_max_filesize``` und ```post_max_size```).
+ **Download Options**
    + **metamod/sourcemod** : Diese Links können durch andere Releases ausgetauscht werden. __Dabei ist zu beachten, dass es sich um ```.tar.gz``` Archive handelt !__
    + **esl_cfg** : Dieses ```tar``` Archiv einthält die ESL CFG Daten, hier kann ein anderes Archiv angegeben werden, der Inhalt wird nach ```csgo/cfg``` entpackt. Zu beachten, dass das Archiv im ```tar``` Format ist und es darf keine Ordnerstruktur enthalten sein.
+ **Install Options**
    + **steamCMD** : Installationspfad von SteamCMD (Wird benötigt um den CSGO Server herunterzuladen) Standardverzeichniss: ```/opt/steamcmd```

    + **server_inst_dir** : Installationspfad vom CSGO Server der Ordner wird im installationsprozess erstellt. __Achtung ein evtl. vorhandener Ordner wird überschrieben !__ Standardverzeichniss: ```/opt/server```

    + **install_user_name** : Der User in dessen Kontext steamCMD (Server Download) und der CSGO Server läuft. Hier kann ein bestehender Benutzer angegeben werden (Nicht empfohlen) diser wird auch nicht verändert. Es sollte aber ein User vom Script erstellt werden, da dieser User wird mit folgenden Eigenschaften erstelt wird: Shell: ```/usr/sbin/nologin``` HomeDIR entspricht dem ```steamCMD``` Installationspfad

    + **retry** : Diese Variable gibt an, die oft nach einem Fehlgeschlagenen Download versucht werden soll, den Server noch einmal herunterlzuladen. Ist diese Zahl überschritten, wird der Vorgang abgebrochen. Sollte dies der fall sein kann unter ```/tmp/tmp.(dieser teil wird generiert)/log``` nach einem fehler gesucht werden.

+ **Optional**
    + **LSB** : Wird verwendet um die Aktuell verwendete Distro zu erfassen, auf Ubuntu und Debian Systemen gibt dieser Befehl den Distro namen zurück.
    + **WAN_IP** : Mittels curl wird die aktuelle WAN IP ermittelt, um diese dann in der ```server.cfg``` als FastDL Server anzugeben.

## Unterstützte Betriebssysteme

Momentan wird **Ubuntu** ab 14.04 LTS und **Debian** ab Version 8 unterstützt.
Vorraussetzungen an andere Distros: apt, apt-get und dpkg erfüllt deine Distro diese Vorgaben, kannst du den Distro check deaktivieren, dazu bei ```# Call Functions``` --> ```check_distro``` entweder mit einem ```#``` auskommentieren oder die Zeile komplett entfernen. 
