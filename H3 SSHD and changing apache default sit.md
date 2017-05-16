## Työympäristö

* Käyttöjärjestelmä: Windows 7 professional service pack 1 
* Suoritin: Intel Core i5-2320 3.00 GHz 
* Muisti: 8 GT 
* Näytönohjain: Nvidia GTX 760 
* VirtualBox OS: Xubuntu 14.04 LTS amd64 desktop 

## SSHD

Alkuun loin hakemistot $ mkdir /etc/puppet/modules/sshd/templates ja sshd/manifests. Tämän jälkeen asensin openssh-server paketin (sudo apt-get install openssh-server), jotta voin kopioda sshd_config tiedoston templatea varten, jota tulen käyttämään tässä modulissa. Kun asennus on valmis kopion kyseisen config tiedoston aika semmin tehtyyn templates hakemistoon (sudo cp /etc/ssh/sshd_config /etc/puppet/modules/sshd/templates/). Tämän jälkeen muokkaan (nano /etc/puppet/modules/sshd/templates/sshd_config) kopiosta portin "port:22" porttiin "port:2222". Seuraavaksi teen init.pp tiedoston aikasemmin tehtyyn (/etc/puppet/modules/sshd/manifests) hakemistoon, jonne teen modulin (nano init.pp).

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

Moduli siis asentaa openssh-server paketin (tosin meillähän se on jo asennettuna), varmistaa että se on käynnissä ja muuttaa sshd_config tiedoston templaten mukaiseksi minkä loimme aikaisemmin, eli siis se muuttaa ssh portin 22 -> 2222. Ajettuani modulin (sudo puppet apply -e class {"sshd:"}') sain tuloksen:

"Notice: Compiled catalog for jani-virtualbox.pp.htv.fi in environment production in 0.18 seconds
Notice: /Stage[main]/Sshd/File[/etc/ssh/sshd_config]/content: content changed '{md5}cac079e87c0ae0d77eafc9b285e36348' to '{md5}8a79404d9a15f461ca3772928d5c4995'
Notice: /Stage[main]/Sshd/Service[ssh]: Triggered 'refresh' from 1 events
Notice: Finished catalog run in 0.28 seconds"

Moduli siis toimii niin kuin kuuluukin.


## Apachen oletussivun vaihtaminen

Aloitin luomalla hakemiston uudelle modulille $ mkdir /etc/puppet/modules/apache/manifests, jonne tein init.pp (nano init.pp)
tiedoston.

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

Moduli siis asentaa apache2 paketin, varmistaa että se on päällä ja muuttaa apachen default sivun (index.html). Tässä tapauksessa 
sivusto saa vain otsikon "Testi". 

Kun ajoin modulin (sudo puppet apply -e 'class {"apache:"}') sain tulokseksi seuraavan:

"Notice: Compiled catalog for jani-virtualbox.pp.htv.fi in environment production in 0.20 seconds
Notice: /Stage[main]/Apache/File[/var/www/html/index.html]/content: content changed '{md5}62d02085bca3a29460f80d88b3827da6' to '{md5}84f5c548b97d7d7d63f10e826e30f5c7'
Notice: /Stage[main]/Apache/Service[apache2]: Triggered 'refresh' from 1 events
Notice: Finished catalog run in 2.50 seconds"

Tästä voimme tulkita että moduli siis toimi niin kuin kuuluukin.
