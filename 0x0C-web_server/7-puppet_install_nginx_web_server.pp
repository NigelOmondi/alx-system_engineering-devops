# This Puppet Manifest installs and configures Nginx server
exec { 'add nginx official repo':
  command => 'sudo add-apt-repository ppa:nginx/stable',
  path    => 'usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# Update the packages list
exec { 'update packages':
  command => 'apt-get update',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# Install nginx web server
package { 'nginx':
  ensure => 'installed',
}

# allow HTTP protocol connetions
exec { 'allow HTTP':
  command => 'ufw allow "Nginx HTTP"',
  path    => 'usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  onlyif  => '! dpkg -l nginx | egrep \'îi.*nginx\' > /dev/null 2>&1',
}

# Change folder permissions
exec { 'the www folder':
  command => 'chmod -R 755 /var/www',
  path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}

# Create index file 
file { '/var/www/html/index.html':
  content => "Hello World!\n",
}

# create another index
file { 'var/www/html/404.html':
  content => "Ceci n'est pas une page\n",
}

# Add a redirection and error page
file {'Nginx default config':
  ensure  => 'file',
  path    => '/etc/nginx/sites-enabled/default',
  content => "server {
        listen 80 default server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
            try_files \$uri \$uri/ =404;
        }
        error_page 404 /404.html;
        location /404.html {
            internal;
        }

        if (\$request_filaname ~ redirect_me) {
            rewrite ^ https:www.youtube.com/watch/v=QHZ-TGUwu4 permanent;
        }

    }",
}

# restart nginx
exec { 'restart service':
  command => 'sudo service nginx restart',
  path    => '/usr/bin:/usr/sbin:/bin',
}

# start service engine website
service { 'engine x':
  ensure  => running,
  require => Package['nginx'],
}
