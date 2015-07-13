Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory="2048"
  end
  config.vm.network :forwarded_port, host: 80, guest: 80
  config.vm.network :forwarded_port, host: 8888, guest: 8888
  config.vm.network :forwarded_port, host: 5433, guest: 5432
  config.vm.provision :shell, inline: <<-SHELL
sudo apt-get update

# utilities
sudo apt-get install -y aptitude emacs24-nox git curl python-pip python-dev

# apache, flask, wsgi
sudo apt-get install -y apache2 python-flask libapache2-mod-wsgi
sudo apt-get install -y python-flask python-flask-login
sudo pip install flask-user flask-restless

# various python incl numpy/scipy
sudo apt-get install -y python-lxml python-imaging
sudo apt-get install -y python-numpy python-scipy python-skimage python-sklearn

# rabbit / celery
sudo apt-get install -y rabbitmq-server python-celery
sudo apt-get remove -y python-librabbitmq

# postgres 9.3
sudo apt-get install -y postgresql-9.3 postgresql-contrib-9.3 python-psycopg2 python-sqlalchemy
sudo -u postgres createuser ifcb
sudo -u postgres createdb -O ifcb ifcb
sudo -u postgres createdb -O ifcb workflow
sudo -u postgres psql -c "ALTER USER ifcb WITH ENCRYPTED PASSWORD 'ifcb';"
sudo sed -i /etc/postgresql/9.3/main/postgresql.conf -e "s/^#listen_addresses.*/listen_addresses = '*'/"
sudo echo "host ifcb ifcb 10.0.2.2/16 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
sudo echo "host workflow ifcb 10.0.2.2/16 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
# restart postgres
sudo service postgresql restart

# configure apache and dashboard
sudo -s <<EOF
echo "Listen 9270" >> /etc/apache2/ports.conf
echo "Listen 8888" >> /etc/apache2/ports.conf
EOF
cd /vagrant
sudo cp dashboard_site.conf workflow_site.conf /etc/apache2/sites-available
sudo a2ensite dashboard_site
sudo a2ensite workflow_site
sudo service apache2 restart

SHELL
end

