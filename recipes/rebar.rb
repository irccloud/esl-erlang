script "make_and_install_rebar" do
    not_if "test -f /usr/bin/rebar"
    interpreter "bash"
    code <<-EOF
    cd /tmp
    git clone https://github.com/basho/rebar.git
    cd rebar
    ./bootstrap
    cp ./rebar /usr/bin/rebar
    chmod g+rx,o+rx /usr/bin/rebar
    cd ..
    rm -rf /tmp/rebar
EOF
end
