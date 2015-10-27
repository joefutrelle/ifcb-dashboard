"""tag ts/user tracking, comment user tracking

Revision ID: 2fee7866c60e
Revises: 16bb7a50388b
Create Date: 2015-10-14 16:52:26.906264

"""

# revision identifiers, used by Alembic.
revision = '2fee7866c60e'
down_revision = '16bb7a50388b'

from alembic import op
import sqlalchemy as sa


def upgrade(engine_name):
    eval("upgrade_%s" % engine_name)()


def downgrade(engine_name):
    eval("downgrade_%s" % engine_name)()





def upgrade_dashboard():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('bin_comments', sa.Column('user_email', sa.String(), nullable=True))
    op.drop_column('bin_comments', 'user_name')
    op.create_index('ix_bin_comments_user_email', 'bin_comments', ['user_email'], unique=False)
    op.add_column('bin_tags', sa.Column('ts', sa.DateTime(timezone=True), nullable=True))
    op.add_column('bin_tags', sa.Column('user_email', sa.String(), nullable=True))
    ### end Alembic commands ###


def downgrade_dashboard():
    ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('bin_tags', 'user_email')
    op.drop_column('bin_tags', 'ts')
    op.drop_index('ix_bin_comments_user_email', 'bin_comments')
    op.add_column('bin_comments', sa.Column('user_name', sa.VARCHAR(), nullable=True))
    op.drop_column('bin_comments', 'user_email')
    ### end Alembic commands ###

