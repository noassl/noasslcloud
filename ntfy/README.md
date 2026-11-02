## Hardening

- Web-Oberfläche deaktiviert
- SMTP-Server nur im LAN erreichbar - Port ist zwar offen, aber kein forwarding im Router
- Auth ist Pflicht

## Systemd-Benachrichtigungen

`systemd/ntfy-failure@.service` und `systemd/ntfy-success@.service` sind optionale Vorlagen für Fehler- und Erfolgsmeldungen. Die Nachrichten enthalten keine Journaldaten, sondern nennen Unit und Host; bei einem Fehler verweisen sie auf `journalctl -u <unit>`. `discord-analytics.service` verwendet sie mit `OnFailure=ntfy-failure@%n.service` und `OnSuccess=ntfy-success@%n.service`.

1. Der Beispiel-Topic `discord-analytics` ist in `server.yml` für den Benutzer `nuc` schreibbar freigegeben. Generiere für diesen Benutzer einen Zugriffstoken:

   ```sh
   docker exec ntfy ntfy token generate nuc
   ```

   Für einen anderen Benutzer oder Topic muss eine passende Schreibregel unter `auth-access` in `server.yml` ergänzt werden; bei `auth-default-access: deny-all` ist das erforderlich. Lade die geänderte ntfy-Konfiguration mit `docker compose up -d ntfy` aus dem Verzeichnis `ntfy/` neu.

2. Installiere und befülle die geschützte Umgebungsdatei:

   ```sh
   sudo install -D -m 600 systemd/ntfy-notify.env.example /etc/ntfy-notify.env
   sudoedit /etc/ntfy-notify.env
   ```

   `NTFY_URL` ist die Basis-URL ohne abschließenden Schrägstrich; `NTFY_TOPIC` ist der Topic-Name und `NTFY_TOKEN` der Zugriffstoken. Die Umgebungsdatei enthält ein Geheimnis und muss nur für root lesbar sein.

3. Installiere beide Unit-Vorlagen und lade systemd neu:

   ```sh
   sudo install -m 644 systemd/ntfy-failure@.service systemd/ntfy-success@.service /etc/systemd/system/
   sudo systemctl daemon-reload
   ```

Der Host benötigt `curl`; `journalctl` wird nur im Fehlerhinweis genannt und nicht von der Benachrichtigung ausgeführt.