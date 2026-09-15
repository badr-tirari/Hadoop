import sys
for line in sys.stdin:
    for word in line.strip().split():
        print(word.lower() + "\t1")
