from jinja2.utils import soft_unicode

'''
USAGE:
 - debug:
     msg: "{{ vpc.subnets | filter_subnets('Type','Public') }}"
 - debug:
     msg: "{{ vpc.subnets | filter_subnets('Type','Private') }}"
'''

class FilterModule(object):
    def filters(self):
        return {
            'filter_subnets': filter_subnets,
        }

def filter_subnets(list, tag_key, tag_value):
    subnets = []
    for item in list:
        if 'subnet' in item:
            item = item['subnet']
            tags = item['tags']
        else:
            tags = item['resource_tags']

        for key, value in tags.iteritems():
            if key == tag_key and value == tag_value:
                subnets.append(item)

    return subnets
