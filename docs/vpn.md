# How to Configure OpenVPN Server and Generate Client Configuration

The below steps configure the VPN server and generate a client
configuration to connect with the OpenVPN client from your workstation.
This is required if you wish to access the web UI of machines running
in the private VPC (e.g. consul UI / Mesos / Marathon)

1: Initialize PKI

```
bin/ovpn-init
```

The above command will prompt you for a passphrase for the root
certificate. Choose a strong passphrase and store it some where safe.
This passphrase is required every time you generate a new client
configuration.

2: Start the VPN server

```
bin/ovpn-start
```
3: Generate client certificate

```
bin/ovpn-new-client $USER
```

Where $USER is the username you want to generate a connection config
for.

4: Download OpenVPN client configuration

```
bin/ovpn-client-config $USER
```

The above command creates a $USER-capgemini-mesos.ovpn client
configuration file in the current directory. Double-click on the file to
import the configuration to your VPN client

### Connecting to the VPN server (Mac OS X)

This assumes you have followed steps 1-4 above and have a downloaded
$USER-cagpemini-mesos.ovpn file

1. Download and install
   [Tunnelblick](https://code.google.com/p/tunnelblick/wiki/DownloadsEntry?tm=2#Tunnelblick_Stable_Release)
2. Double click the $USER-capgemini-mesos-ovpn file. This should open it
   with Tunnelblick
3. Connect to the VPN

Once connected you should be able to access the following - 

* [Mesos Master UI] (http://10.0.1.11:5050)
* [Marathon UI] (http://10.0.1.11:8080)
* [Consul Web UI] (http://10.0.1.11:8500)
