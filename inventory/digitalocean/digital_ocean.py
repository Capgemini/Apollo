#!/usr/bin/env python

'''
DigitalOcean external inventory script
======================================

Generates Ansible inventory of DigitalOcean Droplets.

In addition to the --list and --host options used by Ansible, there are options
for generating JSON of other DigitalOcean data.  This is useful when creating
droplets.  For example, --regions will return all the DigitalOcean Regions.
This information can also be easily found in the cache file, whose default
location is /tmp/ansible-digital_ocean.cache).

The --pretty (-p) option pretty-prints the output for better human readability.

----
Although the cache stores all the information received from DigitalOcean,
the cache is not used for current droplet information (in --list, --host,
--all, and --droplets).  This is so that accurate droplet information is always
found.  You can force this script to use the cache with --force-cache.

----
Configuration is read from `digital_ocean.ini`, then from environment variables,
then and command-line arguments.

Most notably, the DigitalOcean Client ID and API Key must be specified.  They
can be specified in the INI file or with the following environment variables:
    export DO_API_TOKEN='abc123'

Alternatively, they can be passed on the command-line with --client-id and
--api-key.

If you specify DigitalOcean credentials in the INI file, a handy way to
get them into your environment (e.g., to use the digital_ocean module)
is to use the output of the --env option with export:
    export $(digital_ocean.py --env)

----
The following groups are generated from --list:
 - ID    (droplet ID)
 - NAME  (droplet NAME)
 - image_ID
 - image_NAME
 - distro_NAME  (distribution NAME from image)
 - region_ID
 - region_NAME
 - size_ID
 - size_NAME
 - status_STATUS

When run against a specific host, this script returns the following variables:
 - do_created_at
 - do_distroy
 - do_id
 - do_image
 - do_image_id
 - do_ip_address
 - do_name
 - do_region
 - do_region_id
 - do_size
 - do_size_id
 - do_status

-----
```
usage: digital_ocean.py [-h] [--list] [--host HOST] [--all]
                                 [--droplets] [--regions] [--images] [--sizes]
                                 [--ssh-keys] [--domains] [--pretty]
                                 [--cache-path CACHE_PATH]
                                 [--cache-max_age CACHE_MAX_AGE]
                                 [--refresh-cache]
                                 [--api-token API_TOKEN]

Produce an Ansible Inventory file based on DigitalOcean credentials

optional arguments:
  -h, --help            show this help message and exit
  --list                List all active Droplets as Ansible inventory
                        (default: True)
  --host HOST           Get all Ansible inventory variables about a specific
                        Droplet
  --all                 List all DigitalOcean information as JSON
  --droplets            List Droplets as JSON
  --pretty, -p          Pretty-print results
  --cache-path CACHE_PATH
                        Path to the cache files (default: .)
  --cache-max_age CACHE_MAX_AGE
                        Maximum age of the cached items (default: 0)
  --refresh-cache       Force refresh of cache by making API requests to
                        DigitalOcean (default: False - use cache files)
  --api-token API_TOKEN, -a API_TOKEN
                        DigitalOcean API Token (v2 API)
```

'''

# (c) 2013, Evan Wies <evan@neomantra.net>
#
# Inspired by the EC2 inventory plugin:
# https://github.com/ansible/ansible/blob/devel/plugins/inventory/ec2.py
#
# This file is part of Ansible,
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

######################################################################

import os
import sys
import re
import argparse
from time import time
import ConfigParser

try:
    import json
except ImportError:
    import simplejson as json

try:
    from dopy.manager import DoError, DoManager
except ImportError, e:
    print "failed=True msg='`dopy` library required for this script'"
    sys.exit(1)



class DigitalOceanInventory(object):

    ###########################################################################
    # Main execution path
    ###########################################################################

    def __init__(self):
        ''' Main execution path '''

        # DigitalOceanInventory data
        self.data = {}      # All DigitalOcean data
        self.inventory = {} # Ansible Inventory
        self.index = {}     # Various indices of Droplet metadata

        # Define defaults
        self.cache_path = '.'
        self.cache_max_age = 0

        # Read settings, environment variables, and CLI arguments
        self.read_settings()
        self.read_environment()
        self.read_cli_args()

        # Verify credentials were set
        if not hasattr(self, 'api_token'):
            print '''Could not find value for DigitalOcean api_token.
This must be specified via either ini file, command line argument (--api-token),
or environment variable DO_API_TOKEN'''
            sys.exit(-1)

        # env command, show DigitalOcean credentials
        if self.args.env:
            print "DO_API_TOKEN=%s" % (self.api_token)
            sys.exit(0)

        # Manage cache
        self.cache_filename = self.cache_path + "/ansible-digital_ocean.cache"
        self.cache_refreshed = False

        if not self.args.force_cache and self.args.refresh_cache or not self.is_cache_valid():
            self.load_all_data_from_digital_ocean()
        else:
            self.load_from_cache()
            if len(self.data) == 0:
                if self.args.force_cache:
                    print '''Cache is empty and --force-cache was specified'''
                    sys.exit(-1)
                self.load_all_data_from_digital_ocean()
            else:
                # We always get fresh droplets for --list, --host, --all, and --droplets
                # unless --force-cache is specified
                if not self.args.force_cache and (
                   self.args.list or self.args.host or self.args.all or self.args.droplets):
                    self.load_droplets_from_digital_ocean()

        # Pick the json_data to print based on the CLI command
        if self.args.droplets:   json_data = { 'droplets': self.data['droplets'] }
        elif self.args.all:      json_data = self.data

        elif self.args.host:     json_data = self.load_droplet_variables_for_host()
        else:    # '--list' this is last to make it default
                                 json_data = self.inventory

        if self.args.pretty:
            print json.dumps(json_data, sort_keys=True, indent=2)
        else:
            print json.dumps(json_data)
        # That's all she wrote...


    ###########################################################################
    # Script configuration
    ###########################################################################

    def read_settings(self):
        ''' Reads the settings from the digital_ocean.ini file '''
        config = ConfigParser.SafeConfigParser()
        config.read(os.path.dirname(os.path.realpath(__file__)) + '/digital_ocean.ini')

        # Credentials
        if config.has_option('digital_ocean', 'api_token'):
            self.api_token = config.get('digital_ocean', 'api_token')

        # Cache related
        if config.has_option('digital_ocean', 'cache_path'):
            self.cache_path = config.get('digital_ocean', 'cache_path')
        if config.has_option('digital_ocean', 'cache_max_age'):
            self.cache_max_age = config.getint('digital_ocean', 'cache_max_age')


    def read_environment(self):
        ''' Reads the settings from environment variables '''
        # Setup credentials
        if os.getenv("DO_API_TOKEN"):   self.api_token = os.getenv("DO_API_TOKEN")


    def read_cli_args(self):
        ''' Command line argument processing '''
        parser = argparse.ArgumentParser(description='Produce an Ansible Inventory file based on DigitalOcean credentials')

        parser.add_argument('--list', action='store_true', help='List all active Droplets as Ansible inventory (default: True)')
        parser.add_argument('--host', action='store', help='Get all Ansible inventory variables about a specific Droplet')

        parser.add_argument('--all', action='store_true', help='List all DigitalOcean information as JSON')
        parser.add_argument('--droplets','-d', action='store_true', help='List Droplets as JSON')

        parser.add_argument('--pretty','-p', action='store_true', help='Pretty-print results')

        parser.add_argument('--cache-path', action='store', help='Path to the cache files (default: .)')
        parser.add_argument('--cache-max_age', action='store', help='Maximum age of the cached items (default: 0)')
        parser.add_argument('--force-cache', action='store_true', default=False, help='Only use data from the cache')
        parser.add_argument('--refresh-cache','-r', action='store_true', default=False, help='Force refresh of cache by making API requests to DigitalOcean (default: False - use cache files)')

        parser.add_argument('--env','-e', action='store_true', help='Display DO_API_TOKEN')
        parser.add_argument('--api-token','-a', action='store', help='DigitalOcean API Token')

        self.args = parser.parse_args()

        if self.args.api_token: self.api_token = self.args.api_token
        if self.args.cache_path: self.cache_path = self.args.cache_path
        if self.args.cache_max_age: self.cache_max_age = self.args.cache_max_age

        # Make --list default if none of the other commands are specified
        if (not self.args.droplets and not self.args.all and not self.args.host):
                self.args.list = True


    ###########################################################################
    # Data Management
    ###########################################################################

    def load_all_data_from_digital_ocean(self):
        ''' Use dopy to get all the information from DigitalOcean and save data in cache files '''
        manager = DoManager(None, self.api_token, api_version=2)

        self.data = {}
        self.data['droplets'] = manager.all_active_droplets()

        self.index = {}
        self.index['host_to_droplet'] = self.build_index(self.data['droplets'], 'ip_address', 'id', False)

        self.build_inventory()

        self.write_to_cache()


    def load_droplets_from_digital_ocean(self):
        ''' Use dopy to get droplet information from DigitalOcean and save data in cache files '''
        manager = DoManager(None, self.api_token, api_version=2)
        self.data['droplets'] = manager.all_active_droplets()
        self.index['host_to_droplet'] = self.build_index(self.data['droplets'], 'ip_address', 'id', False)
        self.build_inventory()
        self.write_to_cache()


    def build_index(self, source_seq, key_from, key_to, use_slug=True):
        dest_dict = {}
        for item in source_seq:
            name = (use_slug and item.has_key('slug')) and item['slug'] or item[key_to]
            key = item[key_from]
            dest_dict[key] = name
        return dest_dict


    def build_inventory(self):
        '''Build Ansible inventory of droplets'''
        self.inventory = {}

        # add all droplets by id and name
        for droplet in self.data['droplets']:

            networks = droplet['networks']['v4']
            for network in networks:
                if network['type'] == "public":
                    dest = network['ip_address']

            # We add this to catch master/slave groups
            if "mesos-master-" in droplet['name']:
                self.push(self.inventory, 'mesos_masters', dest)

            if "mesos-slave-" in droplet['name']:
                self.push(self.inventory, 'mesos_slaves', dest)

            if "load-balancer-" in droplet['name']:
                self.push(self.inventory, 'load_balancers', dest)

    def load_droplet_variables_for_host(self):
        '''Generate a JSON response to a --host call'''
        host = self.to_safe(str(self.args.host))

        if not host in self.index['host_to_droplet']:
            # try updating cache
            if not self.args.force_cache:
                self.load_all_data_from_digital_ocean()
            if not host in self.index['host_to_droplet']:
                # host might not exist anymore
                return {}

        droplet = None
        if self.cache_refreshed:
            for drop in self.data['droplets']:
                if drop['ip_address'] == host:
                    droplet = self.sanitize_dict(drop)
                    break
        else:
            # Cache wasn't refreshed this run, so hit DigitalOcean API
            manager = DoManager(None, self.api_token, api_version=2)
            droplet_id = self.index['host_to_droplet'][host]
            droplet = self.sanitize_dict(manager.show_droplet(droplet_id))

        if not droplet:
            return {}

        # Put all the information in a 'do_' namespace
        info = {}
        for k, v in droplet.items():
            info['do_'+k] = v

        return info



    ###########################################################################
    # Cache Management
    ###########################################################################

    def is_cache_valid(self):
        ''' Determines if the cache files have expired, or if it is still valid '''
        if os.path.isfile(self.cache_filename):
            mod_time = os.path.getmtime(self.cache_filename)
            current_time = time()
            if (mod_time + self.cache_max_age) > current_time:
                return True
        return False


    def load_from_cache(self):
        ''' Reads the data from the cache file and assigns it to member variables as Python Objects'''
        cache = open(self.cache_filename, 'r')
        json_data = cache.read()
        cache.close()
        data = json.loads(json_data)

        self.data = data['data']
        self.inventory = data['inventory']
        self.index = data['index']


    def write_to_cache(self):
        ''' Writes data in JSON format to a file '''
        data = { 'data': self.data, 'index': self.index, 'inventory': self.inventory }
        json_data = json.dumps(data, sort_keys=True, indent=2)

        cache = open(self.cache_filename, 'w')
        cache.write(json_data)
        cache.close()



    ###########################################################################
    # Utilities
    ###########################################################################

    def push(self, my_dict, key, element):
        ''' Pushed an element onto an array that may not have been defined in the dict '''
        if key in my_dict:
            my_dict[key].append(element);
        else:
            my_dict[key] = [element]


    def to_safe(self, word):
        ''' Converts 'bad' characters in a string to underscores so they can be used as Ansible groups '''
        return re.sub("[^A-Za-z0-9\-\.]", "_", word)


    def sanitize_dict(self, d):
        new_dict = {}
        for k, v in d.items():
            if v != None:
                new_dict[self.to_safe(str(k))] = self.to_safe(str(v))
        return new_dict


    def sanitize_list(self, seq):
        new_seq = []
        for d in seq:
            new_seq.append(self.sanitize_dict(d))
        return new_seq



###########################################################################
# Run the script
DigitalOceanInventory()
