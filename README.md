# homelab
My homelab configuration

This repository Is depreciated, the hardware information is still correct but I no longer use docker compose. My homelab software is now located here:

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
