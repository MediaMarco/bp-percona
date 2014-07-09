# Encoding: UTF-8
# Cookbook Name::       bp-percona
# Description::         Simple Percona installation for Debian in the world of Bigpoint
# Recipe::              _client
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

include_recipe 'bp-percona::_prerequisites'

case node['platform_family']
when 'debian'
  case node['bp-percona']['version']
  when '5.5'
    package 'percona-server-client-5.5' do
      action :install
    end
  when '5.6'
    package 'percona-server-client-5.6' do
      action :install
    end
  else
    Chef::Application.fatal!("Version #{node['percona']['version']} is not supported!", 1)
  end
  
  if node['lsb']['codename'] == 'wheezy'
    package 'libmysqlclient18.1' do
      action :remove
    end
  end

  package 'ruby-mysql' do
    action :install
  end

when 'rhel'
  %w(mysql mysql-devel mysql-libs).each do |pkg|
    package pkg do
      action :remove
      #not_if "rpm -qa | grep #{file_name}"
    end
  end
  case node['bp-percona']['version']
  when '5.5'
    package 'Percona-Server-client-55' do
      action :install
    end
  when '5.6'
    package 'Percona-Server-client-56' do
      action :install
    end
  else
    Chef::Application.fatal!("Version #{node['percona']['version']} is not supported!", 1)
  end
end
