sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository 'deb http://security.ubuntu.com/ubuntu bionic-security main'
sudo apt update && apt-cache policy libssl1.0-dev
sudo apt-get install -y libssl1.0-dev build-essential libreadline-dev zlib1g-dev git-core curl

sudo -H -u ubuntu /bin/bash -lc "
	cd /home/ubuntu
	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
	echo 'export PATH="/home/ubuntu/.rbenv/bin:$PATH"' >> /home/ubuntu/.bashrc

	rm -rf /home/ubuntu/.rbenv/plugins/ruby-build
	mkdir -p /home/ubuntu/.rbenv/plugins
	git clone https://github.com/rbenv/ruby-build.git /home/ubuntu/.rbenv/plugins/ruby-build
"

echo 'eval "$(rbenv init - bash)"' >> /home/ubuntu/.bashrc

sudo chown ubuntu:ubuntu /home/ubuntu/.bashrc
sudo chown -R ubuntu:ubuntu /home/ubuntu/.rbenv

sudo -H -u ubuntu /bin/bash -lc "
    cd /home/ubuntu
    echo 'gem: --no-document' >> /home/ubuntu/.gemrc
"
