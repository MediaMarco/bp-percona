# Encoding: UTF-8
# Cookbook Name::       bp-percona
# Description::         Creates a test database
# Recipe::              testdb
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)
#
# This cookbook create an db with the name 'test_app_db' and creates a user 'testuser'
# who can access it using 'testpw'
#
# Herefor it uses the data bag testapp/db (instanz: test_app_db):
#
# {
#  "id": "db",
#   "test_app_db": {
#     "dbname": "test_app_db",
#     "username": "testuser",
#     "password": "testpw"
#   }
# }
#
# To give the same name to the database as to the data bag item is a good idea, but is not
# enforced ('test_app_db' in the example).
#
# DEBUG: Can be tested with:
# mysql -u testuser -ptestpw test_app_db -e "SELECT 1;"

include_recipe 'database::default'

mysql_connection_info = { :host => 'localhost',
                          :username => 'root',
                          :password => get_root_password }

db = Chef::EncryptedDataBagItem.load('bp-percona-test', 'db')['test_app_db']

log "DB: #{db['db']} Username: #{db['username']} Password: #{db['password']}"

mysql_database db['db']  do
  connection mysql_connection_info
  action :create
end

mysql_database_user db['username'] do
  connection mysql_connection_info
  password db['password']
  action :create
end

mysql_database_user db['username'] do
  connection mysql_connection_info
  password db['password']
  database_name db['db']
  host 'localhost'
  privileges %w(select insert update delete)
  action :grant
end

log "************ Testing (two ones should appear):\n" \
    "#{`mysql -u testuser -ptestpw test_app_db -e \"SELECT 1;\"`}\n"
