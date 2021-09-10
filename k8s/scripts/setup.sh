curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce -y
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
EOF
apt-get update
gpg --keyserver keyserver.ubuntu.com --recv-keys 836F4BEB
gpg --export --armor  836F4BEB | sudo apt-key add -
apt-get update
apt-get install kubeadm=1.21.0-00 kubectl=1.21.0-00 kubelet=1.21.0-00 -y