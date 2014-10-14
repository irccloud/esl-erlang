include_recipe 'apt'

if node['erlang'] == 17
  apt_repository "esl" do
    uri "http://packages.erlang-solutions.com/ubuntu"
    distribution node['lsb']['codename']
    components ["contrib"]
    key "http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc"
  end

  apt_preference "erlang-nox" do
    pin "version 1:17.3"
    pin_priority "999"
  end

  package "erlang-nox" do
    version "1:17.3"
    action :install
  end

  return
end

package "equivs"

# This is a nasty hack, but debian packaging for erlang is insane.
script "install_fake_erlang" do
    not_if "dpkg -s erlang-nox"
    interpreter "bash"
    code <<-EOF
cd /tmp
echo "Section: misc
Priority: optional
Standards-Version: 3.6.2

Package: erlang-nox
Version: 1:99
Maintainer: RJ <rj@metabrew.com>
Provides: erlang-nox
Description: fake erlang package
 to pretend erlang-nox is installed for apts sake" > erlang-nox

equivs-build erlang-nox
dpkg -i ./erlang-nox*.deb
rm ./erlang-nox*.deb
EOF
    end

apt_repository "esl" do
    uri "http://binaries.erlang-solutions.com/debian"
    distribution node['lsb']['codename']
    components ["contrib"]
    key "http://binaries.erlang-solutions.com/debian/erlang_solutions.asc"
end

apt_preference "esl-erlang" do
   pin "version #{node['esl-erlang'][:version]}"
   pin_priority "700"
end

package "esl-erlang" do
    version node['esl-erlang'][:version]
    action :install
end

