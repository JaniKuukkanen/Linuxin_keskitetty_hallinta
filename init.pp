class apache {
				package {'apache2':
                ensure => "installed",

        }

        service {'apache2':
                enable => true,
                ensure => "running",

        }

        file {'/var/www/html/index.html':
                content => "<html><H1>Testi</H1></html>",
                notify => Service["apache2"],

        }

}
