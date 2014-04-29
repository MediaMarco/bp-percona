# Encoding: UTF-8
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

def get_root_password()
  Chef::EncryptedDataBagItem.load(node['bp-percona']['credidentials'][0], \
                                  node['bp-percona']['credidentials'][1]) \
                                 [node['bp-percona']['credidentials'][2]]['root']
end
