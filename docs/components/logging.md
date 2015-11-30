## Logging

The ELK stack (Elasticsearch, Logstash and Kibana) is used as the central logging solution.
These are deployed through [Marathon](https://github.com/mesosphere/marathon).

On each host we have a [Logspout](https://github.com/gliderlabs/logspout) container which is configured with a logstash adapter. Logspout is a log router for Docker containers that runs inside Docker. It attaches to all containers on a host, then routes their logs wherever you want. It also has an extensible module system.

The whole ELK stack can be disabled in the group_vars/all -> elk_enabled: false

### Salesforce Logging
We have also added the capability to enable salesforce integration in roles/logstash/defaults/main.yml. By enabling logstash_salesforce: yes, salesforce data will be imported into logstash and stored in elasticsearch. You can then create some nice visualisations in Kibana based on this data. To enable this you will need to enable these variables:
APOLLO_salesforce_client_id
APOLLO_salesforce_client_secret
APOLLO_salesforce_username
APOLLO_salesforce_password
APOLLO_salesforce_security_token
