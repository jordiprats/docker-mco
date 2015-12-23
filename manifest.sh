#!/bin/bash

cat <<EOF >/tmp/manifest.pp
class { 'mcollective':
  password => '${EYP_ACTIVEMQ_ADMIN_PASSWORD-Y2F0YWx1bnlhbGxpdXJlCg}',
  psk => '${EYP_MCOLLECTIVE_PSK-UgbmV3IG1haWwgaW4gL3Zhci9z}',
  hostname => 'activemq',
  agent=>true,
  client=>false,
}
EOF

touch /etc/puppet/hiera.yaml
sed '/^templatedir/d' -i /etc/puppet/puppet.conf

puppet apply --modulepath=/usr/local/src/puppetmodules/ /tmp/manifest.pp
