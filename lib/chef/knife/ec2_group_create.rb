#
# Author:: Peter C. Norton (<pn@knewton.com>)
# Copyright:: Copyright (c) 2010-2011 Knewton
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife/ec2_base'

class Chef
  class Knife
    class Ec2GroupCreate < Knife

      include Knife::Ec2Base

      deps do
        require 'fog'
        require 'readline'
        require 'chef/json_compat'
        require 'chef/knife/bootstrap'
        Chef::Knife::Bootstrap.load_deps
      end

      banner "knife ec2 group create (options)"

      attr_accessor :initial_sleep_delay

      option :name,
      :short => "-N <name>",
      :long => "--name <name>",
      :description => "The security group to be created",
      :default => ["default"]

      option :description,
      :short => "-D <description>",
      :long => "--description <description>",
      :description => "The description of the security group XXX NOT IMPLEMENTED",
      :default => "Description not provided"

      option :ip_permissions,
      :short => "-P <permission1>,<permission2>,<permissionN>",
      :long => "--permissions <permission1>,<permission2>,<permissionN>",
      :description => "The list of permissions that will be defined for this group  XXX NOT IMPLEMENTED",
      :default => nil
      
      # Do I need an owner_id=nil?
      # TODO: add code to pattern after an existing security group.
      
      def run
        $stdout.sync = true

        secgroup_def = { :name => config[:name], :description => config[:description], :ip_permissions => nil, :owner_id => nil }
        
        
        conn = Fog::Compute.new(
            :provider => 'AWS',
            :aws_access_key_id => Chef::Config[:knife][:aws_access_key_id],
            :aws_secret_access_key => Chef::Config[:knife][:aws_secret_access_key],
            :region => locate_config_value(:region)
          )
        # conn = connection.create()
        secgroup = conn.security_groups.new(secgroup_def)
        secgroup.write()
        
        print "\n#{ui.color("Waiting for AWS\n", :magenta)}"
        
      end
    end
  end
end
