apt-get update &&\ 
apt-get upgrade -y &&\


apt install -y openjdk-17-jdk git software-properties-common apt-transport-https wget unzip &&\

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&\
install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/ &&\
rm microsoft.gpg &&\
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' &&\
apt-get update &&\
apt-get install -y code &&\
echo "Visual Studio Code has been installed successfully." &&\

wget https://github.com/jacamo-lang/jacamo/releases/download/v1.2/jacamo-bin-1.2.zip &&\
mkdir jacamo-1.2 &&\
unzip jacamo-bin-1.2.zip -d jacamo-1.2/ &&\
rm jacamo-bin-1.2.zip &&\
cd jacamo-1.2 &&\
echo "#added in jacamo installation" | tee -a ~/.bashrc &&\
echo "export PATH="$PATH:$(realpath bin)"" | tee -a ~/.bashrc &&\
source ~/.bashrc &&\

apt-get install -y terminator &&\\

apt-get install -y software-properties-common &&\
add-apt-repository -y universe &&\
apt-get update &&\
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release &&\
    
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&\


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" |tee /etc/apt/sources.list.d/docker.list > /dev/null &&\


apt-get update &&\

apt-get install -y docker-ce docker-ce-cli containerd.io &&\

usermod -aG docker $USER &&\

systemctl enable docker &&\
systemctl start docker &&\


docker --version &&\

echo "Docker has been installed successfully."     


