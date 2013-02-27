include_recipe 'apt'
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

package "esl-erlang" do
    version node['esl-erlang'][:version]
    action :install
end

