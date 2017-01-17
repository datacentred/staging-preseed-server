# DataCentred Staging Preseed Server

## Description

Simple REST daemon which listens for preseed requests when installing a host
from a network boot image.  This is responsible for serving dynamic preseed
content used to install the machine, and also finish scripts to install
customisations expected to be in place.

The controlling process first creates an ephemeral host entry identifying the
templates to use for various API calls and any metadata used to render those
templates.  A host is booted into a network installer which then contacts the
preseed server which generates pressed and finish scripts on demand.  Once
complete the calling process can destroy the host entry and continue.

At present templates are served statically.  They can be found in the /views
directory.

## Building

    gem install fpm
    gem build staging-preseed-server.gemspec 
    fpm -s gem -t deb \
      --depends ruby-sinatra \
      --gem-package-name-prefix ruby \
      --deb-systemd etc/systemd/system/staging-preseed-server.service \
      --deb-default etc/default/staging-preseed-server \
      staging-preseed-server-x.y.z.gem

## API

Requests other than pressed and finish resources are expected to send and receive
JSON where data is transfered.

All requests may respond with a 500 error, typically an exception was thrown and
more information can be gained from the server logs.

### GET /hosts

Return a list of all known hosts

#### Response

Code | Meaning
-----|--------
200  | Command success

### GET /hosts/:host

Return a single host

#### Response

Code | Meaning
-----|--------
200  | Command success
404  | Host not found

Parameter | Type | Value
----------|------|------
preseed | String | Name of a preseed template to use
finish | String | Name of a finish template to use
metadata | Hash | Hash of arbitrary data for preseed/finish template generation

#### Example

    {
      "preseed": "preseed.xenial-default.erb",
      "finish": "finish.xenial-default.erb",
      "metadata": {
        "finish_url": "http://10.25.192.254:8421/hosts/ns.example.com/finish",
        "networks": {
          "ens3": {
            "address": "10.25.192.250",
            "netmask": "255.255.255.0",
            "gateway": "10.25.192.1",
            "nameserver": "10.25.192.250 10.25.192.251",
          }
        }
      }
    }

### POST /hosts/:host

Accepts an arbitrary JSON hash of parameters to be used in template generation

#### Request

Parameter | Type | Flags | Value
----------|------|-------|------
preseed | String | Required | Name of a preseed template to use
finish | String | Required | Name of a finish template to use
metadata | Hash | Optional | Hash of arbitrary data for preseed/finish template generation

#### Response

Code | Meaning
-----|--------
201  | Resource created successfully
209  | Resource already exists

### DELETE /hosts/:host

Deletes a host from the preseed server

#### Response

Code | Meaning
-----|--------
204  | Resource deleted successfully
404  | Resource not found

### GET /hosts/:host/preseed

Get a rendered preseed file

#### Response

Code | Meaning
-----|--------
200  | Command success
404  | Host not found

### GET /hosts/:host/finish

Get a rendered finish script

#### Response

Code | Meaning
-----|--------
200  | Command success
404  | Host not found
