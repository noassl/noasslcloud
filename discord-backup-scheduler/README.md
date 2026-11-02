## Einrichten

Die Jobs laufen wöchentlich über systemd: zuerst der Exporter, danach – nur wenn der Export erfolgreich war – der Analyzer. Die Job-Container werden bei jedem Lauf frisch aus Compose erstellt und wieder entfernt.

1. `.env.example` nach `.env` kopieren und `DISCORD_TOKEN` sowie `GUILD_ID` eintragen. Die Datei mit `chmod 600 .env` schützen.
2. In `systemd/discord-analytics.service` `WorkingDirectory` auf den tatsächlichen absoluten Pfad dieses Verzeichnisses setzen.
3. Die ntfy-Benachrichtigungen für erfolgreiche und fehlgeschlagene Läufe wie in `../ntfy/README.md` beschrieben einrichten. Ist ntfy nicht konfiguriert, schlägt nur die Benachrichtigung fehl; die Jobs funktionieren weiterhin.
4. Die Units installieren und den Timer aktivieren:

   ```sh
   sudo install -m 644 systemd/discord-analytics.service systemd/discord-analytics.timer /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable --now discord-analytics.timer
   ```

5. Den Webhost wie bisher starten: `docker compose up -d webhost`. Die Jobs sind mit dem Profil `jobs` vom normalen `docker compose up -d` ausgeschlossen.

## Betrieb

- Timer prüfen: `systemctl list-timers discord-analytics.timer`
- Lauf manuell starten: `sudo systemctl start discord-analytics.service`
- Job-Logs ansehen: `sudo journalctl -u discord-analytics.service`
- Images bei Bedarf manuell bauen: `docker compose --profile jobs build exporter analyzer`

Der Service versucht vor jedem Lauf, die Images zu aktualisieren und zu bauen. Ein fehlgeschlagener Build verhindert den Lauf nicht; vorhandene Images werden dann weiterverwendet. Bei einem Jobfehler wird der Analyzer übersprungen und systemd sendet eine ntfy-Fehlermeldung; bei erfolgreichem Abschluss folgt eine Erfolgsmeldung.