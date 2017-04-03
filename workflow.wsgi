import sys

sys.path.insert(0,'/home/vagrant/ifcb-dashboard')

from dashboard_conf import ASYNC_CONFIG_MODULE, WORKFLOW_DATABASE_URL

from oii.workflow.app import app as application

application.config.update(
  ASYNC_CONFIG_MODULE=ASYNC_CONFIG_MODULE,
  DATABASE_URL=WORKFLOW_DATABASE_URL
)
