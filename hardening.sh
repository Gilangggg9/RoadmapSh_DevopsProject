#!/bin/bash 
#membuat script hardening secara otomatis di ubuntu server
#Script mencakup:
#Update Dependecy - Update system 
#- Setup Network (IP: 172.31.137.90, IP Gateway: 172.31.137.1, Nameserver: 103.84.10.201 ) 
#- Secure Network (IP Spoofing protection, Block SYN attacks, Disable IPv6, Hide kernel pointers, Enable panic on OOM) 
#- Secure SSHD (disable tunneled clear text passwords, Do not allow empty passwords, log all activity, change SSH default port) 
#- configure firewall (allow only http, https, ssh) 
#- free disk space

# ============================================ 
# Automation Hardening  
# ============================================ 
echo "[*] Start  hardening" 
# ----------------------------- 
# 1. Update system 
# ----------------------------- 
echo "[*] Update system packages" 
apt-get update -y && apt-get upgrade -y 
# ----------------------------- 
# 2. Setup Network static IP 
# ----------------------------- 
echo "[*] Configure static IP" 
cat > /etc/netplan/01-netcfg.yaml <<EOF 
network: 
version: 2 
ethernets: 
ens33: 
dhcp4: no 
addresses: [172.31.137.90/24] 
gateway4: 172.31.137.1 
nameservers: 
addresses: [103.84.10.201] 
EOF 
netplan apply 
# ----------------------------- 
# 3. Secure Network Settings 
# ----------------------------- 
echo "[*] Apply network security..." 
cat >> /etc/sysctl.conf <<EOF 
# Disable IP Spoofing 
net.ipv4.conf.all.rp_filter=1 
net.ipv4.conf.default.rp_filter=1 
# Block SYN Flood Attack 
net.ipv4.tcp_syncookies=1 
# Disable IPv6 
net.ipv6.conf.all.disable_ipv6=1 
net.ipv6.conf.default.disable_ipv6=1 
net.ipv6.conf.lo.disable_ipv6=1 
# Hide Kernel Pointers 
kernel.kptr_restrict=2 
# Enable panic on OOM 
vm.panic_on_oom=1 
kernel.panic=10 
EOF 
sysctl -p 
# ----------------------------- 
# 4. Secure SSHD 
# ----------------------------- 
echo "[*] Secure SSH configuration" 
SSHD_FILE="/etc/ssh/sshd_config" 
# Disable clear text passwords 
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' $SSHD_FILE 
# Disallow empty passwords 
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' $SSHD_FILE 
# Change SSH port (misal: 2211) 
sed -i 's/#Port 22/Port 2211/' $SSHD_FILE 
# Enable logging 
echo "LogLevel VERBOSE" >> $SSHD_FILE 
systemctl restart sshd 
# ----------------------------- 
# 5. Configure Firewall (ufw) 
# ----------------------------- 
echo "[*] Configure firewall " 
ufw --force reset 
ufw default deny incoming 
ufw default allow outgoing 
ufw allow 80/tcp    # HTTP 
ufw allow 443/tcp   # HTTPS 
ufw allow 2211/tcp  # SSH (custom port) 
ufw --force enable 
# ----------------------------- 
# 6. clean up 
# ----------------------------- 
echo "[*] Cleaning up" 
apt-get autoremove -y 
apt-get clean 
echo "[*] Hardening complete!" 
