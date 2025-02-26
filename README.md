# homelab
My homelab configuration

This repository will contain the docker compose yaml files that power my homelab, which is made up of 36 actively running containers as of the writing of this message. Obviously the env files and config files are private, but this should serve as a public record of my lab.

I am self hosting all of these services, although admittedly I don't use them very much (except immich and vaultwarden, those two are amazing). This was more a project to learn all about docker, home networking.

Network Hardware Topology:
 - Firewall: BKHD 1U Server
   - Ports: 6x GBE, 4x SFP+
   - CPU: Intel Atom 16 Core C3958
   - RAM: 16GB DDR4 SODIMM
   - Storage: 128GB NVMe SSD
 - Switch: Netgear GS308EP
   - An upgrade from my previous TP-Link switch. The old switch would occassionally stop sending data and wouldneed to be power cycled.
   - Ports: 8x GBE
 - Access Point: Ubiquiti U6-Pro
   - Networks: Main, Guest, IOT
 - Server: Minisforum Elitemini AI370
   - My old laptop finally died, this is it's replacement.
   - CPU: Ryzen AI 9 HX 370
   - RAM: 32GB DDR5-7500 (soldered)
   - Storage: 2 x 4TB Samsung 990 Pro SSDs (Raid 1)
   - OS: Arch Linux
   - Containers running: 36

Network Software Topology:
 - Firewall: OPNsense
   - The heart of my network setup.
   - Services: DHCP, DNS, VPN (Wireguard), NAT, Port Forwarding, etc.
   - Many Vlans:
     - AT&T VLAN: Required for the WAN my AT&T Fiber connection.
     - Home VLAN: My main network, where all my devices are.
     - Wireguard VLAN: VPN clients have access to WAN and Home VLAN, determined on a case by case basis.
     - Guest VLAN: For guests, isolated from the main network.
     - IOT VLAN: For IOT devices, isolated from the main network.
     - Management VLAN: For managing the network devices using their dedicated OOB ports.
 - Switch: Unmanaged
   - Just a dumb switch, no configuration needed.
 - VPN: Wireguard
   - I have a VPN server running on the firewall, which I use to access my network remotely.
   - I have a VPN client running on my personal devices to access my network remotely. This gives me access to my services from anywhere in the world provided my server is working.
 - Important containers:
   - Portainer: For managing the docker containers.
   - Watchtower: For updating the docker containers.
   - Nginx Proxy Manager: to manage SSL, reverse proxy services, and domain name management.
   - Homearr: For a configurable dashboard.
   - Immich: For syncing and storing my photos with my family.
   - Vaultwarden: For managing my passwords. I built my own password manager but truthfully this one is more fully featured and integrates with my personal devices better.
   - Nextcloud: For managing my files. A great alternative to Onedrive or Google Drive.
   - Plex: For managing my media. I don't use this much, but it's nice when I want to watch home movies on the big screen.
   - Unifi Network Application: For managng my Ubiquity devices.
   - Portfolio: A self made docker container that hosts my personal website.

I will update this list if I decide to host more or less services, and will make some sort of periodic updates about the network configuration.
