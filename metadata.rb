name             'bp-percona'
maintainer       'Bigpoint GmbH'
maintainer_email 't.winkler@bigpoint.net'
license          'All rights reserved'
description      'A relational database server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.20'

depends          'apt', '>= 2.3.10'
depends          'yum', '>= 3.2.2'
depends          'mysql-chef_gem', '~> 0.0'
depends          'database', '~> 2.3'
depends          'mysql', '< 5.4'

supports         'debian', '>= 7.0'
supports         'centos', '>= 6.5'
