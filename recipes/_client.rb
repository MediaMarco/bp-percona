# Encoding: UTF-8
# Cookbook Name::       bp-percona
# Description::         Simple Percona installation for Debian in the world of Bigpoint
# Recipe::              _client
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

include_recipe 'bp-percona::_prerequisites'

case node['bp-percona']['version']
when '5.5'
  packages =  %w{percona-server-client-5.5 libmysqlclient18-dev ruby-mysql}
when '5.6'
  packages =  %w{percona-server-client-5.6 libmysqlclient18-dev ruby-mysql}
else
  Chef::Application.fatal!("Version #{node['percona']['version']} is not supported!", 1)
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

package 'libmysqlclient18.1' do
  action :remove
end
