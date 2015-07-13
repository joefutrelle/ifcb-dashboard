import sys

sys.path.insert(0,'/vagrant')

from oii.workflow.app import app as application

application.config.update(
  ASYNC_CONFIG_MODULE='oii.workflow.async_config',
  DATABASE_URL='postgresql://ifcb:ifcb@localhost/workflow'
)
