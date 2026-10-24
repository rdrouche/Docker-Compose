#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y -qq \
  wget curl vim nano less \
  htop procps lsof \
  net-tools iputils-ping dnsutils \
  tree file \
  sudo passwd \
  tar gzip bzip2 zip unzip \
  python3

# Installer TTYD
wget -qO /usr/local/bin/ttyd \
  https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
  || (echo "Download TTYD failed, trying apt..." && apt-get install -y -qq ttyd)
chmod +x /usr/local/bin/ttyd 2>/dev/null || true

# Créer l'utilisateur etudiant
useradd -m -s /bin/bash etudiant 2>/dev/null || true
echo 'etudiant:formation' | chpasswd
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
usermod -aG sudo etudiant

cat >> /home/etudiant/.bashrc << 'EOF'
echo ''
echo '====== Bienvenue dans le TP Linux ======'
echo ''
echo 'Utilisateur : etudiant (sudo sans mot de passe)'
echo 'Essayez : ls, pwd, man ls, sudo apt install htop'
echo '========================================'
echo ''
EOF

chown etudiant:etudiant /home/etudiant/.bashrc

exec ttyd \
  --port 7681 \
  --once \ \
  --title "RDR-IT — Linux TP" \
  --writable \
  su - etudiant
