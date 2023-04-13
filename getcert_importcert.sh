# Obtain CA cert on master
openssl s_client -connect $HARBOR_HOST:443 < /dev/null 2> /dev/null | \
  openssl x509 | \
  sed -ne '/BEGIN CERT/,/END CERT/p' > ~/harbor.crt

# Add the harbor CA certificate to the system trust store
sudo cp harbor.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

# Restart docker and containerd
sudo systemctl restart docker
sudo systemctl restart containerd

# Add the above steps for worker1 and worker2 node

for node in "$WORKER1_HOST" "$WORKER2_HOST"
do
  sshpass -pH3pt10 scp ~/harbor.crt automation@$node:harbor.crt
  sshpass -pH3pt10 ssh -t -oStrictHostKeyChecking=no automation@$node "sudo cp harbor.crt /usr/local/share/ca-certificates/; sudo update-ca-certificates; sudo systemctl restart docker; sudo systemctl restart containerd"
done
