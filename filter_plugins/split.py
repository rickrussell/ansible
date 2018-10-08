from jinja2.utils import soft_unicode

'''
USAGE:
 - debug:
     msg: "{{ vpc_cidr_block | split('.') | slice(2) | first | reverse | join('.') }}.in-addr.arpa."
'''

class FilterModule(object):
    def filters(self):
        return {
            'split': split_string,
        }

def split_string(string, separator=' '):
    try:
        return string.split(separator)
    except Exception, e:
        raise errors.AnsibleFilterError('split plugin error: %s, provided string: "%s"' % str(e),str(string) )
