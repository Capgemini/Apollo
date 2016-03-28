## Logging

The ELK stack (Elasticsearch, Logstash and Kibana) is used as the central logging solution.
These are deployed through [Marathon](https://github.com/mesosphere/marathon).

On each host we have a [Logstash-forwarder](https://github.com/elastic/logstash-forwarder) container which is configured to watch for logs in '/var/lib/docker/<container id>/<container id>-json.log'. We have also configured it to watch files in '/var/log/syslog' and '/var/log/consul'. When a new container starts up we have [docker-gen](https://github.com/jwilder/docker-gen) container which will re-generate our logstash-forwarder config file from docker container meta-data.

To run this with your own certificate and private key set these to variables

export APOLLO_lumberjack_ssl_key_file
export APOLLO_lumberjack_ssl_certificate_file

The whole ELK stack can be disabled in the group_vars/all -> elk_enabled: false

### Salesforce Logging
We have also added the capability to enable salesforce integration in roles/logstash/defaults/main.yml. By enabling logstash_salesforce: yes, salesforce data will be imported into logstash and stored in elasticsearch. You can then create some nice visualisations in Kibana based on this data. To enable this you will need to enable these variables:

export APOLLO_salesforce_client_id
export APOLLO_salesforce_client_secret
export APOLLO_salesforce_username
export APOLLO_salesforce_password
export APOLLO_salesforce_security_token

# ELB Logging
We have enabled the capability for the ELB to log to s3 bucket and then be sucked into logstash. We need to set these to variables for this to work.

export TF_VAR_s3_bucket_name
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
