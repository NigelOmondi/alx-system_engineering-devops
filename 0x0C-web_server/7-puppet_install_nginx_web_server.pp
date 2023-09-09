# This Puppet Manifest installs and configures Nginx server
package { 'nginx':
  ensure => 'installed',
}

# Allow HTTP traffic
firewall { '100 allow http':
  port   => 80,
  proto  => 'tcp',
  action => 'accept',
}

# Set up a basic Nginx site
file { '/var/www/html/index.nginx-debian.html':
  ensure  => 'file',
  content => 'Hello World!',
}

# Configure Nginx server block
file { '/etc/nginx/sites-available/default':
  ensure  => 'file',
  content => template('/etc/nginx/nginx.conf'),
}

# Enable the default server block
exec { 'enable_default_site':
  command => 'ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/',
  creates => '/etc/nginx/sites-enabled/default',
  require => File['/etc/nginx/sites-available/default'],
}

# Create a 301 redirect
nginx::resource::server { 'default':
  listen_options => 'default_server',
  server_name    => '_',
  location       => {
    '/redirect_me' => {
  ensure  => 'present',
  rewrite => '^/redirect_me https://www.youtube.com/ permanent;',
    },
  },
  require        => Package['nginx'],
}

# Restart Nginx
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => [Package['nginx'], File['/etc/nginx/sites-available/default']],
}
