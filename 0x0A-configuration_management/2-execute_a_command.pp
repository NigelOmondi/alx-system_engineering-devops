# A manifest that kills a process named killmenow
exec { 'killmenow':
  command => 'pkill -f killmenow',
  path    => '/bin/',
  onlyif  => 'pgrep -f killmenow',
}
