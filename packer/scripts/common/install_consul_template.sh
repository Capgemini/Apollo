# install consul template
wget https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_VERSION}/consul-template_${CONSUL_VERSION}_linux_amd64.tar.gz
tar xzf consul-template_${CONSUL_VERSION}_linux_amd64.tar.gz
sudo mv consul-template_${CONSUL_VERSION}_linux_amd64/consul-template /usr/bin
sudo rmdir consul-template_${CONSUL_VERSION}_linux_amd64

# consul template upstart for haproxy
sudo cp /tmp/upstart/consul_template.conf /etc/init/consul_template.conf