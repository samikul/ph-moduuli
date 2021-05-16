# Based on code written by Tero Karvinen.
# Visit Tero's website terokarvinen.com

# Code modified for learning purposes

import sys
assert sys.version_info.major >= 3, "Python version too old in test.wsgi!"

sys.path.insert(0, '/home/admuser/public_wsgi/')
from helloworld import app as application