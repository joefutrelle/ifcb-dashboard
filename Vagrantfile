Vagrant.configure("2") do |config|
  config.vm.box = "velocity42/xenial64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory="2048"
  end
  config.vm.network :forwarded_port, host: 8888, guest: 8888
  config.vm.provision :shell, inline: <<-SHELL
sudo apt-get update

# utilities
sudo apt-get install -y aptitude git curl python-pip python-dev cifs-utils smbclient libffi-dev dialog

# apache, flask, wsgi
sudo apt-get install -y apache2 python-flask libapache2-mod-wsgi
sudo apt-get install -y python-flask python-flask-login
sudo pip install "flask-user<0.7" flask-restless flask-wtf mimerender bcrypt

# various python incl numpy/scipy
sudo apt-get install -y python-requests python-lxml python-imaging
sudo apt-get install -y python-numpy python-scipy python-skimage python-sklearn python-pandas
sudo pip install jdcal

# rabbit / celery / supervisor
sudo apt-get install -y rabbitmq-server python-celery python-celery-common supervisor
sudo apt-get remove -y python-librabbitmq

# remove python 3 so that celery can run our code
sudo apt-get remove -y python3

# postgres 9.5
sudo apt-get install -y postgresql-9.5 postgresql-contrib-9.5 python-psycopg2 python-sqlalchemy
sudo apt-get install -y alembic
sudo -u postgres createuser ifcb
sudo -u postgres createdb -O ifcb ifcb
sudo -u postgres createdb -O ifcb workflow
sudo -u postgres psql -c "ALTER USER ifcb WITH ENCRYPTED PASSWORD 'ifcb';"
sudo sed -i /etc/postgresql/9.5/main/postgresql.conf -e "s/^#listen_addresses.*/listen_addresses = '*'/"
sudo echo "host ifcb ifcb 10.0.2.2/16 md5" >> /etc/postgresql/9.5/main/pg_hba.conf
sudo echo "host workflow ifcb 10.0.2.2/16 md5" >> /etc/postgresql/9.5/main/pg_hba.conf
# restart postgres
sudo service postgresql restart

# fix python requests
sudo apt-get install -y libssl-dev
sudo python -m easy_install --upgrade pyOpenSSL

# configure apache and dashboard
sudo -s <<EOF
echo "Listen 9270" >> /etc/apache2/ports.conf
echo "Listen 8888" >> /etc/apache2/ports.conf
EOF
cd /vagrant
cp dashboard_conf.py.example dashboard_conf.py
sudo cp dashboard_site.conf workflow_site.conf /etc/apache2/sites-available
sudo a2ensite dashboard_site
sudo a2ensite workflow_site
sudo service apache2 restart

# configure dashboard workers
sudo cp /vagrant/dashboard_workers.conf /etc/supervisor/conf.d
sudo service supervisor restart

SHELL
config.vm.provision :shell, :inline => "sudo supervisorctl restart all", run: "always"
config.vm.provision :shell, :inline => "if [ $(fgrep -c /vagrant/bin /home/vagrant/.bashrc) -eq 0 ]; then echo 'export PATH=$PATH:/vagrant/bin' >> /home/vagrant/.bashrc; fi", run: "always"
end

