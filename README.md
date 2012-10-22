# Description

Installs and configures [update-conf.d](https://github.com/Atha/update-conf.d).

# Requirements

* Chef 0.10.10+.

## Platform

* Debian, Ubuntu

Tested on:

* Debian 5.0

# Attributes

* `node['update-conf.d']['managed_files']` - An array of etc files to manage. e.g. %w(fstab, profile)

# Usage

Add the recipe to your run list.

##### Using knife to add nut to the run list

	knife node run_list add [NODE] 'recipe[update-conf.d]'

### Testing the recipe using vagrant

First you'll need to install [Virtual Box](https://www.virtualbox.org/) and [Vagrant](http://vagrantup.com/)

##### Create the cookbook directory
	 [ -s cookbooks/update-conf.d ] || (mkdir cookbooks && ln -s /vagrant cookbooks/update-conf.d)

##### Start Vagrant
	vagrant up

