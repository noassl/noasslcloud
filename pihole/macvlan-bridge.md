# Problem

Docker host konn über macvlan Netzwerk in container ned pingen -> nuc söm konn pihole ned ois DNS hernemma

# Lösung

Eigenes Interface mid statischer route am host mochn de nur fia de oane container-IP in traffic über besagtes Interface leitet

## Quelle

https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/

## Commands übersetzt fia nmcli

### Interface erstellen

> Aufpassen: `dev` muass s physische Interface vom nuc sein

```bash
sudo nmcli connection add type macvlan ifname pihole-shim dev enp3s0 mode bridge
```

### IP konfigurieren

```bash
sudo nmcli connection modify macvlan-pihole-shim ipv6.method "disabled"
sudo nmcli connection modify macvlan-pihole-shim ipv4.addresses 192.168.0.2
sudo nmcli connection modify macvlan-pihole-shim ipv4.method "manual"
```

### Route konfigurieren

> Aufpassen: Erster Teil von da Route is Container IP (siehe docker-compose), zweiter Teil IP vom neichn Interface

```bash
sudo nmcli con mod macvlan-pihole-shim +ipv4.routes "192.168.0.1/32 192.168.0.2"
```

### Route überprüfen

```bash
sudo nmcli con up macvlan-pihole-shim
sudo ip -4 route
```
