import sys
import logging

from oii.ifcb2.session import session
from oii.ifcb2.accession import Accession

"""
This script provides for a simple command-line interface to batch accession.
To run it, just type

python batch_acc.py {time series label}

where "{time series label}" is the short label of the time series you want
to run through accession (not the "Description", but the label that's in the
URLs)

You can run this as many times as you want and it will only add data that is
not yet in the time series, but you should not run the script while it is
already running.

This script bypasses the automated processing workflow job management, and
so is only recommended if you are not using that system. Bins added by
this script will not have product generation jobs scheduled.
"""

def doit(ts_label):
    acc = Accession(session, ts_label)
    ts = acc.get_time_series()
    if ts is None:
        raise ValueError('No time series named %s' % ts_label)
    logging.warn('Starting batch accession for %s' % ts_label)
    acc.add_all_filesets()
    logging.warn('Finished batch accession for %s' % ts_label)

if __name__=='__main__':
    try:
        ts_label = sys.argv[1]
    except:
        raise ValueError('No time series label specified')
    doit(ts_label)
