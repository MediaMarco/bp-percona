# Encoding: UTF-8
# Cookbook Name::       bp-percona
# Description::         Simple Percona installation for Debian in the world of Bigpoint
# Recipe::              _server
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

include_recipe 'bp-percona::_client'

case node['platform_family']
when 'debian'
  case node['bp-percona']['version']
  when '5.5'
    packages =  %w(percona-server-server-5.5)
  when '5.6'
    packages =  %w(percona-server-server-5.6)
  else
    Chef::Application.fatal!("Version #{node['percona']['version']} is not supported!", 1)
  end
when 'rhel'
  case node['bp-percona']['version']
  when '5.5'
    packages =  %w(Percona-Server-server-55)
  when '5.6'
    packages =  %w(Percona-Server-server-56)
  else
    Chef::Application.fatal!("Version #{node['percona']['version']} is not supported!", 1)
  end
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

package 'percona-xtrabackup' do
  action :install
  only_if { node['bp-percona']['with_xtradb_backup'] }
end

file '/etc/my.cnf' do
  action :delete
  only_if { node['bp-percona']['my_cnf'] != '/etc/my.cnf' && File.exist?('/etc/my.cnf') }
end

fail 'node[\'bp-percona\'][\'credidentials\'] is not defined' if node['bp-percona']['credidentials'].nil?

db_cred = Chef::EncryptedDataBagItem.load(node['bp-percona']['credidentials'][0], \
                                          node['bp-percona']['credidentials'][1]) \
                                         [node['bp-percona']['credidentials'][2]]

template '/etc/mysql/debian.cnf' do
  source 'debian.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables('debianpw' => db_cred['debian'])
  only_if { platform? 'debian' }
end

service 'mysql' do
  supports :status => true, :start => true, :stop => true, :reload => true, :restart => true
  subscribes :reload, "template[#{node['bp-percona']['my_cnf']}]", :delayed
  action :start
  not_if { File.exist?(node['bp-percona']['no_restart_file']) }
end

# Init DB
execute 'set_password' do
  command "mysqladmin -u root password #{db_cred['root']}"
  notifies :run, 'execute[cleanup]', :immediately
  not_if { `mysqladmin ping -u root -p#{db_cred['root']} 2>/dev/null`.include? 'mysqld is alive' }
end

execute 'cleanup' do
  command %{echo \"
        DROP DATABASE IF EXISTS test;
        UPDATE user SET password=PASSWORD('#{db_cred['debian']}') WHERE user='debian-sys-maint';
        DELETE FROM user WHERE password='';
        DELETE FROM db WHERE Db LIKE 'test%';
        FLUSH PRIVILEGES;\" | mysql -u root -p#{db_cred['root']} mysql}
  action :nothing
end
