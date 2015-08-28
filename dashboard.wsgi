import sys

sys.path.insert(0,'/vagrant')

from dashboard_conf import DASHBOARD_BASE_URL, DASHBOARD_DATABASE_URL, WORKFLOW_URL

from oii.ifcb2.dashboard.app import app as application

application.config.update(
  DASHBOARD_BASE_URL=DASHBOARD_BASE_URL,
  DATABASE_URL=DASHBOARD_DATABASE_URL,
  WORKFLOW_URL=WORKFLOW_URL
)
