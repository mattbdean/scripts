#!/usr/bin/env python3

# TODO Sample output
# TODO Assume that an exit code of 0 applies to all scripts

import os.path
import glob
import json
from pprint import pprint

def printarg(file, arg):
	file.write(' ')
	file.write('<' if arg['required'] else '[')
	if (arg['positional']):
		file.write(arg['name'])
	else:
		file.write(' | '.join(arg['option_names']))
	file.write('>' if arg['required'] else ']')

def header(file, str):
	file.write('####' + str + '\n\n')

def main():
	out = open('../README.md', 'wt', encoding='UTF-8')

	out.write('My bash scripts\n')
	out.write('===============\n\n')
	out.write('A few scripts that I use. Nothing (too) special.\n')

	for f in sorted(glob.glob('*.json')):
		print('Reading {}'.format(f))

		json_data = open(f)
		data = json.load(json_data)
		json_data.close()

		# Script header
		filename = os.path.splitext(f)[0]
		root = data['requires_root']
		out.write('##[`{}`](https://github.com/thatJavaNerd/scripts/blob/master/{})\n'.format(filename, filename))
		out.write('\n')

		# Run-as-root warning
		if root:
			out.write('>Warning: This script requires to be run as root\n\n')

		# Purpose
		out.write(data['purpose'].replace('\\n', '\n') + '\n\n')

		# Usage
		args = data['args']
		header(out, 'Usage')
		out.write('`{} {}'.format('#' if root else '$', filename))
		for arg in args:
			printarg(out, arg)
		out.write('`\n\n')

		# Arguments table
		if len(args) != 0:
			header(out, 'Arguments')
			out.write('Name | Description\n')
			out.write('---- | -----------\n')
			for arg in args:
				out.write('`{}` | {}\n'.format(arg['name'], arg['description']))
			out.write('\n')

		# Examples
		header(out, 'Examples')
		out.write('```shell\n')
		for ex in data['examples']:
			out.write('# {}\n'.format(ex['purpose']))
			if root:
				# Simulate superuser prompt
				out.write('hostname# ')
			else:
				# Simulate non-root bash prompt
				out.write('user@hostname:~$ ')
			out.write('{} {}\n'.format(filename, ex['args']))
		out.write('```\n')

		# Exit codes
		header(out, 'Exit codes')
		out.write('Code | Description\n')
		out.write('---- | -----------\n')
		for code, desc in sorted(data['exit_codes'].items()):
			out.write('`{}` | {}\n'.format(code, desc))
		out.write('\n')

		# Dependencies
		deps = data['dependencies']
		if len(deps) != 0:
			header(out, 'Dependencies')
			for dep in deps:
				out.write('- [`{}`]({})\n'.format(dep['name'], dep['url'])) 

		out.write('\n')

if __name__ == "__main__":
	main()
