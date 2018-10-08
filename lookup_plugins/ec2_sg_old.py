from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible.plugins.lookup import LookupBase
import boto3
import os

# Python 2/3 compatibility for `isinstance(attrs, basestring)`
try:
    basestring
except NameError:
    basestring = str

class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        ret = []

        # Load 'AWS_*' Environment Variables for boto3
        for key in variables['ansible_env']:
            if key.startswith('AWS_'):
              os.environ[key] = variables['ansible_env'][key]

        ec2 = boto3.session.Session(
            profile_name=os.getenv('AWS_PROFILE', None),
            region_name=os.getenv('AWS_REGION', None)
            ).client('ec2')

        security_groups = ec2.describe_security_groups(
            Filters=[{
                    'Name': t.split('=')[0],
                    'Values': t.split('=')[1].split(',')
                } for t in terms ]
            )['SecurityGroups']

        attrs = kwargs.pop('attrs', None)

        # Only return specific attributes of the SecurityGroup object(s)
        if attrs:
            # When requesting a single attr, return a list of strings
            if isinstance(attrs, basestring):
                ret = [sg[attrs] for sg in security_groups]
            # When requesting multiple attrs, return a list of dicts
            else:
                ret = [{ k: sg[k] for k in attrs} for sg in security_groups]
        # Or return the whole object(s) from boto
        else:
          ret = security_groups

        return ret
