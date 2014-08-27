# Encoding: UTF-8
# Percona version
default['bp-percona']['version'] = '5.6'
default['bp-percona']['with_xtradb_backup'] = true

# Encrypted data bag containing 'root', 'debian' and 'replication' passwords
default['bp-percona']['credidentials'] = nil

default['bp-percona']['my_cnf'] = '/etc/mysql/my.cnf'

# yum
arch = node["kernel"]["machine"] == 'x86_64' ? 'x86_64' : 'i386'
pversion = node["platform_version"].to_i

default['bp-percona']['yum']['description'] = 'Percona Packages'
default['bp-percona']['yum']['baseurl'] = "http://repo.percona.com/centos/#{pversion}/os/#{arch}/"
default['bp-percona']['yum']['gpgkey'] = 'http://www.percona.com/downloads/RPM-GPG-KEY-percona'
default['bp-percona']['yum']['gpgcheck'] = true
default['bp-percona']['yum']['sslverify'] = true

# [mysql]

# CLIENT #
default['bp-percona']['port'] = 3306
default['bp-percona']['default-character-set'] = 'utf8'

# [mysqld]

# GENERAL #
default['bp-percona']['user'] = 'mysql'
default['bp-percona']['bind-address'] = '127.0.0.1'
default['bp-percona']['default-storage-engine'] = 'InnoDB'
# /etc/init.d/mysql relates to this, which is provided by the package
default['bp-percona']['socket'] = '/var/run/mysqld/mysqld.sock' if platform? 'debian'
default['bp-percona']['socket'] = '/var/lib/mysql/mysql.sock' if platform_family? 'rhel'
default['bp-percona']['pid-file'] = '/var/lib/mysql/mysql.pid'
default['bp-percona']['character-set-server'] = 'utf8'
default['bp-percona']['collation-server'] = 'utf8_unicode_ci'
default['bp-percona']['explicit-defaults-for-timestamp'] = 1
default['bp-percona']['innodb-file-format'] = 'barracuda'
default['bp-percona']['init-connect'] = 'SET NAMES utf8'

# MyISAM #
default['bp-percona']['key-buffer-size'] = '32M'
default['bp-percona']['myisam-recover-options'] = 'FORCE,BACKUP'

# SAFETY #
default['bp-percona']['max-allowed-packet'] = '16M'
default['bp-percona']['max-connect-errors'] = 1000000

# DATA STORAGE #
default['bp-percona']['datadir'] = '/var/lib/mysql/'

# BINARY LOGGING #
default['bp-percona']['log-bin'] = nil #'/var/lib/mysql/mysql-bin'
default['bp-percona']['expire-logs-days'] = 2
default['bp-percona']['sync-binlog'] = 1
default['bp-percona']['max-binlog-size'] = '100M'
default['bp-percona']['binlog-format'] = nil

# CACHES AND LIMITS #
default['bp-percona']['tmp-table-size'] = '32M'
default['bp-percona']['max-heap-table-size'] = '32M'
default['bp-percona']['query-cache-type'] = 0
default['bp-percona']['query-cache-size'] = 0
default['bp-percona']['max-connections'] = 500
default['bp-percona']['thread-cache-size'] = 50
default['bp-percona']['open-files-limit'] = 65535
default['bp-percona']['table-definition-cache'] = 1024
default['bp-percona']['table-open-cache'] = 2048

# INNODB #
default['bp-percona']['innodb-flush-method'] = 'O_DIRECT'
default['bp-percona']['innodb-log-files-in-group'] = 2
default['bp-percona']['innodb-flush-log-at-trx-commit'] = 1
default['bp-percona']['innodb-file-per-table'] = 1

# ADDITIONAL
default['bp-percona']['innodb-io-capacity'] = 500
default['bp-percona']['skip-name-resolve'] = true

# LOGGING #
default['bp-percona']['log-error'] = '/var/lib/mysql/mysql-error.log'
default['bp-percona']['log-queries-not-using-indexes'] = 'off'
default['bp-percona']['slow-query-log'] = 1
default['bp-percona']['slow-query-log-file'] = '/var/lib/mysql/mysql-slow.log'
# SSL
default['bp-persona']['ssl'] = false
default['bp-percona']['ssl-ca'] = '/etc/mysql/cacert.pem'
default['bp-percona']['ssl-cert'] = '/etc/mysql/server-cert.pem'
default['bp-percona']['ssl-key'] = '/etc/mysql/server-key.pem'

Chef::Application.fatal!('Can not determine available memory', 1) unless node['memory']['total'].end_with?('kB')
total_memory = node['memory']['total'][0, node['memory']['total'].length - 2].to_i

default['bp-percona']['innodb-buffer-pool-size'] = total_memory > 1048576 ? "#{total_memory / 1228}M" : nil

default['bp-percona']['innodb-log-file-size'] = total_memory < 41943040 ? '256M' : '512M'

