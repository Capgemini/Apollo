## Simple nodejs REST API service

This example contains a simple nodejs REST service that is self-contained and
has a single endpoint exposed. The endpoint returns a simple JSON response that
just returns the version of itself.

For example the v1 container (1.0.0) will return "1.0.0" as its version, whereas
the v2 container (2.0.0) will return "2.0.0" as its version. This container is
mostly used to demonstrate some basic concepts of the Apollo platform.

These examples includes -

* A nodejs container containing a simple rest service with a single endpoint
at /

### Start the service

```
curl -X POST -HContent-Type:application/json -d @nodejs-rest-api-v1.json $MARATHON_IP:8080/v2/apps
```

The service will be accessible through the HAProxy container (on port 80) at ```nodejs-rest-api.example.com``` by default. It is recommended that you set up your own DNS servers / hostname and override the ```haproxy_domain``` in [../roles/haproxy/defaults/main.yml](../roles/haproxy/defaults/main.yml).

### Removing the app

You can remove the application straight from the command line by running -

```
curl -XDELETE http://$MARATHON_IP:8080/v2/apps/nodejs-rest-api
```
