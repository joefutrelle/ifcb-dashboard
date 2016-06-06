import sys

from oii.utils import gen_id

from oii.ifcb2.session import dbengine, session
from oii.ifcb2.orm import User, Role

from oii.ifcb2.dashboard.flasksetup import user_manager

if __name__=='__main__':
    try:
        password = sys.argv[1]
    except IndexError:
        password = gen_id()[:8]
    user = session.query(User).filter_by(email='admin@whoi.edu').first()
    if user is not None:
        session.delete(user)
        session.commit()
    username = 'admin@whoi.edu'
    u = User(
        first_name='Admin',
        last_name='User',
        email=username,
        username=username,
        password=user_manager.hash_password(password),
        is_enabled=True
    )
    r = session.query(Role).filter_by(name='Admin').first()
    u.roles.append(r)
    session.add(u)
    session.commit()
    print "%s|%s" % (username, password)

