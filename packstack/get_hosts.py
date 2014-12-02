#!/usr/bin/python

import yaml

config = yaml.load(open('config.yaml'))

for name, value in config['address'].items():
    if name == 'compute':
        for index, _ in enumerate(value):
            print("node%d" % (index + 1))
    else:
        print(name)
