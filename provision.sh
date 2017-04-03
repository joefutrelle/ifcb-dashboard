sudo apt-get update

# utilities
sudo apt-get install -y aptitude git curl python-pip python-dev cifs-utils smbclient libffi-dev dialog

# apache, flask, wsgi
sudo apt-get install -y apache2 python-flask libapache2-mod-wsgi
sudo apt-get install -y python-flask python-flask-login
sudo pip install flask-user flask-restless flask-wtf mimerender bcrypt

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
# restart postgres
sudo service postgresql restart

# configure apache and dashboard
sudo -s <<EOF
echo "Listen 9270" >> /etc/apache2/ports.conf
echo "Listen 8888" >> /etc/apache2/ports.conf
EOF

cd /home/vagrant/ifcb-dashboard
cp dashbaord_conf.py.example dashboard_conf.py

sudo cp dashboard_site.conf workflow_site.conf /etc/apache2/sites-available
sudo a2ensite dashboard_site
sudo a2ensite workflow_site
sudo service apache2 restart

# configure dashboard workers
sudo cp /home/vagrant/ifcb-dashboard/dashboard_workers.conf /etc/supervisor/conf.d
sudo service supervisor restart

