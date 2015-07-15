# == Class: continuent_vagrant::hosts See README.md for documentation.
#
# Copyright (C) 2014 Continuent, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.  You may obtain
# a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

class continuent_vagrant::hosts {
	if $ec2_instance_id == "" {
	  if $platform == 'virtualbox'  or $platform == '' {
	    if $vagrant_hosts_domain != '' {
	      $additional_domain = $vagrant_hosts_domain
	    } else {
	      $additional_domain = "$domain"
	    }
	    if $additional_domain == '' {
	      host { "db1": ip => "192.168.11.101", }
  			host { "db2": ip => "192.168.11.102", }
  			host { "db3": ip => "192.168.11.103", }
  			host { "db4": ip => "192.168.11.104", }
  			host { "db5": ip => "192.168.11.105", }
  			host { "db6": ip => "192.168.11.106", }
  			host { "db7": ip => "192.168.11.107", }
  			host { "db8": ip => "192.168.11.108", }
	    } else {
	      host { "db1.${additional_domain}": ip => "192.168.11.101", host_aliases => "db1"}
  			host { "db2.${additional_domain}": ip => "192.168.11.102", host_aliases => "db2"}
  			host { "db3.${additional_domain}": ip => "192.168.11.103", host_aliases => "db3"}
  			host { "db4.${additional_domain}": ip => "192.168.11.104", host_aliases => "db4"}
  			host { "db5.${additional_domain}": ip => "192.168.11.105", host_aliases => "db5"}
  			host { "db6.${additional_domain}": ip => "192.168.11.106", host_aliases => "db6"}
  			host { "db7.${additional_domain}": ip => "192.168.11.107", host_aliases => "db7"}
  			host { "db8.${additional_domain}": ip => "192.168.11.108", host_aliases => "db8"}
	    }
		}
	} else {
    #Openstack hosts have the ec2 facts loaded but
    #they have AZ of nova
    if $ec2_placement_availability_zone != 'nova'
    {
      class { "ec2_hosts":
      include_short_hostname => true,
      }

      exec { "resize_root":
        command => "/sbin/resize2fs /dev/xvda1",
      }
    }
	}
}
