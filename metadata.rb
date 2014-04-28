name             'bp-percona'
maintainer       'Bigpoint GmbH'
maintainer_email 't.winkler@bigpoint.net'
license          'All rights reserved'
description      'A relational database server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends          'apt', '>= 2.3.10'
depends          'mysql-chef_gem', '>= 0.0.2'
depends          'database', '>= 2.1.8'
depends          'mysql', '>= 5.2.2'

supports         'debian'
