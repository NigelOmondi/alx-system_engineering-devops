# Add SSH client configuration lines
if $facts['networking']['hostname'] == 'quantum-server' {
  file_line { 'Turn off passwd auth':
    ensure => present,
    path   => '/etc/ssh/ssh_config',
    line   => 'PasswordAuthentication no',
  }

  file_line { 'Declare the identity file':
    ensure => present,
    path   => '/etc/ssh/ssh_config',
    line   => 'IdentityFile ~/.ssh/school',
  }

# Notify user about the changes
  notify { 'SSH configuration updated':
    message => 'Your SSH client configuration has been updated.',
  }
}
