#!/usr/bin/python

import yaml

config = yaml.load(open('config.yaml'))

for name, value in config['address'].items():
    if name == 'compute':
        for name, _ in value.items():
            print(name)
    else:
        print(name)
