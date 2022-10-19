import random
import string

print(''.join(random.choices(string.ascii_lowercase, k=8)))