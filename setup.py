# References 
# http://code.djangoproject.com/browser/django/trunk/setup.py 
#!/usr/bin/env python
__version__ = '1.0.0'
import os


def fullsplit(path, result=None):
    """
    Split a pathname into components (the opposite of os.path.join) in a
    platform-neutral way.
    """
    if result is None:
        result = []
    head, tail = os.path.split(path)
    if head == '':
        return [tail] + result
    if head == path:
        return result
    return fullsplit(head, [tail] + result)

def read(filename):
    return open(os.path.join(os.path.dirname(__file__), filename)).read()

packages, data_files = [], []
root_dir = os.path.dirname(__file__)
if root_dir != '':
    os.chdir(root_dir)
stats_dir = 'statsagent'

for dirpath, dirnames, filenames in os.walk(stats_dir):
    # Ignore dirnames that start with '.'
    for i, dirname in enumerate(dirnames):
        if dirname.startswith('.'): del dirnames[i]
    if '__init__.py' in filenames:
        packages.append('.'.join(fullsplit(dirpath)))
    elif filenames:
        data_files.append([dirpath, [os.path.join(dirpath, f) for f in filenames]])


sdict = {
    'name' : 'statsagent',
    'version' : __version__,
    'long_description' : 'process memory and cpu usage monitoring agent',
    'author' : 'thekonqueror',
    'author_email' : 'thekonqueror@gmail.com',
    'packages' : packages,
	'data_files' : data_files,
	'install_requires': 
	[
        'requests'
    ],
   }

try:
	from setuptools import setup
except ImportError:
	from distutils.core import setup

setup(**sdict)