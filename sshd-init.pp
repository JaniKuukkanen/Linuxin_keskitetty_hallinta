class sshd {

        package { 'openssh-server':

                ensure => "installed",

        }

        service { 'ssh':

                ensure => 'running',
                enable => true,

        }

        file { '/etc/ssh/sshd_config':
                
                content => template("/etc/puppet/modules/sshd/templates/sshd_config"),
                notify => Service["ssh"],

        }

}
