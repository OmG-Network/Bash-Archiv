# CSGO Cloud Server Deploy

## Was tut das Script ?

Nach dem Start wird ein CSGO Server installiert, dabei kann man über die Variable <code>GAME_MODE</code> angeben wie der CSGO Server konfigurtiert werden soll. Das besondere daran ist, dass die Installation und konfiguration komplett unbeaufsichtigt erfolgen kann. Daher ist das Script bestens geeignet um in Cloud ungebungen eingesetzt zu werden.

Ziel ist es einen Cloud Server mit diesem Script zu deployen, sodas man sich zum schluss nur noch zum Server verbinden muss.

## Konfigurierbare Parameter

<code>GAME_TYPE</code> gibt an wie der Server konfiguriert werden soll. Zur auswahl stehen 1vs1, Diegel oder MM (Competitive). Zusätzlich liegen im cfg Verzeichniss alle ESL CFGs, diese können nachträglich geladen werden.

<code>steamCMD</code> Installationspfad von SteamCMD (Wird benötigt um den CSGO Server herunterzuladen) Standartwert: <code>/opt/steamcmd</code>

<code>server_inst_dir</code> Installationspfad vom CSGO Server der Ordner wird im installationsprozess erstellt, ein evtl. vorhandener Ordner wird überschrieben ! Standartwert: <code>/opt/server</code>

<code>install_user_name</code> Es wird ein User erstellt um mit diesem den Server über <code>steamCMD</code> herunterzuladen und um diesen später zu starten. Hier kann ein bestehender Benutzer angegeben werden (bitte nicht root ._. ) diser wird auch nicht verändert. Es sollte aber ein User vom Script erstellt werden, dieser User wird mit folgenden Eigenschaften erstelt: Shell: <code>/usr/sbin/nologin</code> HomeDIR entspricht dem <code>steamCMD</code> Installationspfad

<code>retry</code> Diese Variable enthält die maximale wiederholungen des Server Downloads, ist diese Zahl erreicht bricht das Script ab. Sollte dies der fall sein kann unter <code>/tmp/tmp.(dieser teil wird generiert)/log</code> nach einem fehler gesucht werden.

<code>metamod</code>/<code>sourcemod</code> Diese Links können durch andere Releases ausgetauscht werden, zu achten ist aber auch die Dateiendung es werden nur <code>tar.gz</code> Dateien entpackt !

<code>esl_cfg</code> Diese tar Datei einthält die CFG Daten, hier kann ein anderes Archiv angegeben werden, der Inhalt wird nach <code>csgo/cfg</code> entpackt. Zu beachten, das Archiv muss im tar Format sein und darf keine Ordnerstruktur enthalten.

<code>LSB</code> wird verwendet um die Aktuell verwendete Distro zu erfassen, auf Ubuntu und Debian Systemen gibt dieser Befehl den Distro namen zurück.

## Unterstützte Betriebssysteme

Momentan wird Ubuntu und Debian unterstützt.
Vorraussetzungen an andere Distros: <code>apt</code>, <code>apt-get</code> und <code>dpkg</code> erfüllt deine Distro diese Vorgaben, kannst du in Zeile 31 <code>"Ubuntu"</code> oder <code>"Debian"</code> mit deinem Output des <code>LSB</code> Befehls austauschen. 
