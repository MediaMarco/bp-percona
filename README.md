# bp-percona

Installs and configures Percona on a Debian system

## Requirements
Chef 0.11+.

## Platform
- Debian only

Tested on:

- Debian Wheezy
- Debian Jessie
- CentOS 6.5

## mysql-chef_gem
**Do not install `mysql-chef_gem` in your cookbooks.** This
is beeing installed in `bp-percona::_prerequisites`. If you call
`mysql-chef_gem::default` yourself percona will be uninstalled due
the dependency to `mysql`.

## Usage
If you want to install the server, you need to create a data bag with the
creditials ('root', 'debian', 'replication') first.

Include `bp-percona::_server` if you want to install the full server or `bp-percona::_client` if
you only need the client libraries and tools.

In the end you should be able to create databases, user etc. using the Opscode
`database` cookbook. You find an example in recipes/testdb.rb.

## Cookbooks

* `default` - Installs a database server
* `_server` - Installs the Percona database server
* `_client` - Only installs the client utilities
* `testdb` - Uses opscode 'database' cookbook to install a test db and user. This can be used as an example.

## Resources and Providers

none

## Attributes
* `['bp-percona']['version']` - Which version to the installed ('5.5' or '5.6')
* `['bp-percona']['with_xtradb_backup']` - Install xtradb backup
* `['bp-percona']['credidentials']` - An array ([3]) pointing to the data bag
holding the 'root', 'debian' and 'replication' passwords

The rest of the attributes are named after the options in my.cnf.
See http://www.percona.com/doc/percona-server for details.

## Data bags
You need a data bag holding the 'root', 'debian' and 'replication' passwords. It's name is
defined in `node['bp-percona']['credidentials']`. In the data base are stored instances (third
item in the array).

F.ex.

```json
{
  "id": "mysql",
  "testing": {
    "root": "rootpw",
    "debian": "debianpw",
    "replication": "replicationpw"
  }
}
```

## License & Authors
- Author:: Thorsten Winkler (<twinkler@bigpoint.net>)

```text
Copyright:: 2014 Bigpoint GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
