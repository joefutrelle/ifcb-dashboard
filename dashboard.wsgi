import sys

sys.path.insert(0,'/vagrant')

from oii.ifcb2.dashboard.app import app as application

application.config.update(
  DASHBOARD_BASE_URL='http://localhost:8888/',
  DATABASE_URL='postgresql://ifcb:ifcb@localhost/ifcb',
  WORKFLOW_URL='http://localhost:9270'
)
