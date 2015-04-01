#!/usr/bin/env python3

import argparse
from periodic.table import element
import sys
from pprint import pprint

def sci_round(num):
    return round(num, 3)

if __name__ == "__main__":
    
    # Create a dict of periodic.table.element to the amount
    elements = {}
    key = None
    for i in range(1, len(sys.argv)):
        arg = sys.argv[i]
        if key == None:
            key = element(arg)
            continue
        elements[key] = arg
        key = None

    total_mass = 0
    element_masses = {}
    for (el, count) in elements.items():
        mass = el.mass * float(count)
        element_masses[el] = mass
        total_mass += mass

    print("Total mass: ", sci_round(total_mass))

    for (el, mass) in element_masses.items():
        print(el.name + ":", sci_round((mass / total_mass) * 100), "percent", "with a mass of", sci_round(mass))
    

