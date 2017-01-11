# DataCentred Staging Preseed Server

## Description

Simple REST daemon which listens for preseed requests when installing a host
from a network boot image.  This is responsible for serving dynamic preseed
content used to install the machine, and also finish scripts to install
customisations expected to be in place.

## Building

    apt-get -y install bundler make
    gem install fpm
    make build

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
