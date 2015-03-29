# install HAproxy
sudo apt-get install -y haproxy
sudo chmod a+w /etc/rsyslog.conf
echo '$ModLoad imudp' >> /etc/rsyslog.conf
echo '$UDPServerAddress 127.0.0.1' >> /etc/rsyslog.conf
echo '$UDPServerRun 514' >> /etc/rsyslog.conf
sudo service rsyslog restart
sup cp /ops/templates/haproxy.cfg /etc/haproxy/haproxy.cfg

# eve upstart
sudo cp /tmp/upstart/haproxy.conf /etc/init/haproxy.conf

# consul config
echo '{"service": {"name": "haproxy", "tags": ["haproxy"]}}' > /etc/consul.d/haproxy.json