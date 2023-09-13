# This Puppet Manifest installs and configures Nginx server
package { 'nginx':
  ensure => 'installed',
}

# Configure the Nginx server block
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ =404;
        add_header Content-Type text/html;
        echo 'Hello World!';
    }
    
    location /redirect_me {
        return 301 http://example.com;
    }
}
  ",
  require => Package['nginx'],
}

# Create the Hello World HTML file
file { '/var/www/html/index.html':
  ensure  => file,
  content => 'Hello World!',
  require => Package['nginx'],
}

# Create a symbolic link to enable the site
file { '/etc/nginx/sites-enabled/default':
  ensure => link,
  target => '/etc/nginx/sites-available/default',
  notify => Service['nginx'],
}

# Ensure Nginx is running and enabled at boot
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => [File['/etc/nginx/sites-enabled/default'], File['/var/www/html/index.html']],
}
