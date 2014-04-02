# == Class: continuent_vagrant See README.md for documentation.
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

class continuent_vagrant (
  $clusterData = false,
  $installPuppetLabsMySQL = false,
) {
  stage { pre: before => Stage[main] }
  class { "continuent_vagrant::hosts": stage => pre}
  
  if $installPuppetLabsMySQL == true {
    class { "continuent_vagrant::puppetlabs_mysql" : 
      availableMastersData => $clusterData, 
      stage => pre,
    }
  }
}