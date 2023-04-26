#Step 3 - Install Minikube dependencies
sudo apt install -y curl wget apt-transport-https
#Step 4 - Download Minikube Binary
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube version
#Step 5 - Install Kubectl utility
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version -o yaml
#Step 6 - Start minikube
minikube start --driver=docker