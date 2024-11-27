# homelab
My homelab configuration

This repository will contain the docker compose yaml files that power my homelab, which is made up of 34 actively running containers as of the writing of this message. Obviously the env files and config files are private, but this should serve as a public record of my lab.

I am self hosting all of these services in my laptop, although admittedly I don't use them very much (except immich and vaultwarden, those two are amazing). This was more a project to learn all about docker, home networking, and seeing how far I could push my poor little laptop.

Network Topology:
 - Firewall: BKHD 1U Server
   - Ports: 6x GBE, 4x SFP+
   - CPU: Intel Atom 16 Core C3958
   - RAM: 16GB DDR4 SODIMM
   - Storage: 128GB NVMe SSD
   - OS: OPNsense
 - Switch: TP-Link TL-SG105
   - Ports: 5x GBE
   - VLANs: 1
 - Access Point: Ubiquiti U6-Pro
   - Networks: Main, Guest, IOT

I will update this list if I decide to host more or less services, and will make some sort of periodic updates about the network configuration.
