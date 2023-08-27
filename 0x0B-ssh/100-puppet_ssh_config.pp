# Define the SSH configuration path

file { '/home/nigel/.ssh/config':
  ensure => 'file',
  mode   => '0600',
}
# Add SSH client configuration lines
file_line { 'Turn off passwd auth':
  ensure => present,
  path   => '/home/nigel/.ssh/config',
  line   => 'PasswordAuthentication no',
}

file_line { 'Declare the identity file':
  ensure => present,
  path   => '/home/nigel/.ssh/config',
  line   => 'IdentityFile ~/.ssh/school',
}

# Notify user about the changes
notify { 'SSH configuration updated':
  message => 'Your SSH client configuration has been updated.',
}
