## Työympäristö

* Käyttöjärjestelmä: Windows 7 professional service pack 1 
* Suoritin: Intel Core i5-2320 3.00 GHz 
* Muisti: 8 GT 
* Näytönohjain: Nvidia GTX 760 
* VirtualBox OS: Xubuntu 14.04 LTS amd64 desktop 

## SSHD

## Apachen oletussivun vaihtaminen

Aloitin luomalla hakemiston uudelle modulille ($ mkdir /etc/puppet/modules/apache/manifests), jonne tein init.pp (nano init.pp)
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

Kun ajoin modulin sain tulokseksi seuraavan:

"Notice: Compiled catalog for jani-virtualbox.pp.htv.fi in environment production in 0.20 seconds
Notice: /Stage[main]/Apache/File[/var/www/html/index.html]/content: content changed '{md5}62d02085bca3a29460f80d88b3827da6' to '{md5}84f5c548b97d7d7d63f10e826e30f5c7'
Notice: /Stage[main]/Apache/Service[apache2]: Triggered 'refresh' from 1 events
Notice: Finished catalog run in 2.50 seconds"

Tästä voimme tulkita että moduli siis toimi niin kuin kuuluukin.
