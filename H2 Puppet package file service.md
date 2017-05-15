
## Työympäristö

* Käyttöjärjestelmä: Windows 7 professional service pack 1 
* Suoritin: Intel Core i5-2320 3.00 GHz 
* Muisti: 8 GT 
* Näytönohjain: Nvidia GTX 760 
* VirtualBox OS: Xubuntu 14.04 LTS amd64 desktop 

## Modulin luonti

Vaihdoin VirtualBoxiin tässä kotitehtävässä, joten asensin puppetin ja loin samat hakemistot kuin edellisessä kotitehtävässä (https://janikuukkanen.wordpress.com/2017/04/04/linuxin-keskitetty-hallinta-h1-puppet-moduli/).

Luotuani hakemistot, tein taas init.pp tiedoston, jonne kirjoitin seuraavan koodin 

`class hello {

        exec { 'apt-update':
        command => '/usr/bin/apt-get update'
        }

        package { 'apache2':
        require => Exec['apt-update'],
        ensure => installed,
        }

        service { 'apache2':
        ensure => running,
        }

        file { '/var/www/home.html':
	content => "Hello world!\n",
	}
}`

Päädyin siis jatkamaan aikaisemmin toimivaksi huomaamallani modulilla, johon lisäsin service ja file osat. Service kohta käynnistää apache2 ohjelman, jos se ei ole vielä päällä ja file luo tiedoston (jos sitä ei vielä ole olemassa) ja sisältöä home.html tiedostoon. 
Seuraavaksi kokeilin toimiiko tämä moduli ja se tapahtui komennolla `sudo puppet apply --modulepath modules/ -e 'class {"hello":}'`, tällä kertaa sain vain seuraavan error viestin:

`Error: Puppet::Parser::AST::Resource failed with error ArgumentError: Could not find declared class hello at line 1 on node jani-virtualbox.pp.htv.fi
Wrapped exception:
Could not find declared class hello
Error: Puppet::Parser::AST::Resource failed with error ArgumentError: Could not find declared class hello at line 1 on node jani-virtualbox.pp.htv.fi`

Monta tuntia asiaa tutkittuani en löytänyt tälle mitään korjausta, tarkistin kirjoitusvirheet ja hakemistopolut useaan otteeseen, mutta mikään ei tuntunut auttavan.

## Lähteet

* http://terokarvinen.com/2017/aikataulu-%e2%80%93-linuxin-keskitetty-hallinta-%e2%80%93-ict4tn011-11-%e2%80%93-loppukevat-2017-p2
* http://terokarvinen.com/2013/hello-puppet-revisited-%E2%80%93-on-ubuntu-12-04-lts
* https://docs.puppet.com/puppet/latest/lang_relationships.html#packagefileservice
* https://janikuukkanen.wordpress.com/2017/04/04/linuxin-keskitetty-hallinta-h1-puppet-moduli/
* https://www.digitalocean.com/community/tutorials/getting-started-with-puppet-code-manifests-and-modules
