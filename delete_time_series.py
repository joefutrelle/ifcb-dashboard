import sys

from oii.ifcb2.session import session
from oii.ifcb2.orm import TimeSeries, Bin

if len(sys.argv) < 2:
   print 'no time series label specified'
   sys.exit(-1)
else:
   LABEL = sys.argv[1]

# clean up dashboard database
ts = session.query(TimeSeries).filter(TimeSeries.label==LABEL).first()
if ts is not None:
    session.delete(ts)

for b in session.query(Bin).filter(Bin.ts_label==LABEL):
    session.delete(b)

session.commit()

# now clean up workflow database
from dashboard_conf import DASHBOARD_BASE_URL, WORKFLOW_DATABASE_URL
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session

from oii.workflow import orm as worm

dbengine = create_engine(WORKFLOW_DATABASE_URL)
worm.Base.metadata.create_all(dbengine)
session = scoped_session(sessionmaker(bind=dbengine))()

for p in session.query(worm.Product).filter(worm.Product.pid.like(DASHBOARD_BASE_URL+LABEL+'/%')):
    session.delete(p)

session.commit()
