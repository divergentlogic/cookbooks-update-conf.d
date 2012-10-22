#
# Author:: Ceaser Larry <clarry@divergentlogic.com>
# Cookbook Name:: default
# Recipe:: default
#
# Copyright 2012, Divergent Logic, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "git"
include_recipe "build-essential"

git "#{Chef::Config[:file_cache_path]}/update-conf.d" do
  action :checkout
  repository "git://github.com/Atha/update-conf.d.git"
  branch "master"
end

execute "build_update-conf.d" do
  command "make build"
  cwd "#{Chef::Config[:file_cache_path]}/update-conf.d"
  not_if "test -f #{Chef::Config[:file_cache_path]}/update-conf.d/00fstab"
end

execute "install_update_conf.d" do
  command "make install"
  cwd "#{Chef::Config[:file_cache_path]}/update-conf.d"
  not_if "test -f /usr/local/sbin/update-conf.d"
end

node["update-conf.d"]["managed_files"].each do |conf|
  execute "update_conf.d-#{conf}" do
    action :nothing
    command "/usr/local/sbin/update-conf.d #{conf}"
  end

  directory "/etc/#{conf}.d" do
    owner "root"
    group "root"
    mode "755"
  end

  execute "copy_original_#{conf}" do
    command "/bin/cp /etc/#{conf} /etc/#{conf}.d/00original && echo #{conf} >> /etc/update-conf.d.conf"
    not_if "test -f /etc/#{conf}.d/00original"
    notifies :run, "execute[update_conf.d-#{conf}]"
  end
end

template "/etc/update-conf.d.conf" do
  source "update-conf.d.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end
