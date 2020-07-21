# Buoy

**Docker service for proxying development web traffic to Docker-based web services**

Buoy is a Docker service that allows for multiple Docker-based web services to share the standard web ports (port 80 and 443), utilizing subdomains to decide which service to route traffic.

## Installation

Installation of Buoy is fairly straightforward:

```bash
git clone git@github.com:lightster/buoy.git
cd buoy
make install
```

You will also need to use dnsmasq or something similar to set DNS to point `b.com` and all subdomains to `127.0.0.1`.  If you are not currently using a DNS service in your development environment, [lightster/dnsmasq-mgmt](https://github.com/lightster/dnsmasq-mgmt) is a quick way to install and configure dnsmasq.

## Configuring your web services

You will need to configure each service you want accessible via a Buoy subdomain.  Each web service's docker-compose.yml needs to:
 - Connect to the `buoy` Docker network
 - Set an alias that corresponds to the subdomain used for the service
 - Expose port 80 and/or 443 in the container

For example, if you want to be able to access your `user` service from `user.b.com`, you would want to setup your service's docker-compose.yml to include:

```yaml
version: "3"
services:
  web:
    ports:
      # you only need to include whichever port(s) your service listens on
      - "80"
      - "443"
    networks:
      # be sure to include the network your service normally uses so containers
      # within your service can talk to each other
      default:
      # connect to the buoy network
      buoy:
        aliases:
          # change this to whatever subdomain(s) you want the service accessible from
          - "user"

# declare the buoy network and map it to the network defined by buoy
networks:
  buoy:
    external:
      name: buoy
```

## Configuring Buoy

There are a few customizations you can make to Buoy.

### Changing the base domain

By default, the base domain is `b.com`.  You can change this to something else, such as `m.com`.  To do so:
 1. Point DNS for `m.com` and all subdomains to `127.0.0.1`
 2. Create an `.env` file in the `buoy` root directory and save the following to it:
    ```bash
    DOMAIN=m.com
    ```
 3. Restart buoy with a new self-signed SSL cert for the new domain by running:
    ```bash
    make reinstall
    ```

### Setting destination service ports

Some web services expose ports other than port 80 and/or 443.  You can tell Buoy to connect to a specific port of your service by creating a `subdomain-port.local.map` file in the `buoy` root directory and mapping subdomains to ports like so:
```nginx
"user"     "8080";
"jekyll"   "4000";
"rabbitmq" "15672";
```

You will need to restart buoy after making subdomain-port mapping changes:
```bash
docker-compose restart buoy
```

The service will be accessed from a web browser through the implicit port 80 or 443, for HTTP and HTTPS respectively, but Buoy will now know to connect to your service on the port you identified in the subdomain-port map file.

### Setting destination service address

Some web services are ran outside of Docker.  In those cases, you can explicitly map a Buoy subdomain to a destination address by creating a `subdomain-addr.local.map` file in the `buoy` root directory and mapping subdomains to ports like so:
```nginx
"host"     172.17.0.1;
```

You will need to restart buoy after making subdomain-addr mapping changes:
```bash
docker-compose restart buoy
```
