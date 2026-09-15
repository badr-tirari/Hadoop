import sys
# Somme des valeurs par cle (Exercices 1 & 3). Meme structure que le reducer WordCount.
current, total = None, 0
for line in sys.stdin:
    parts = line.rstrip('\n').split('\t', 1)
    if len(parts) < 2:
        continue
    key = parts[0]
    try:
        val = int(parts[1])
    except ValueError:
        continue
    if key == current:
        total += val
    else:
        if current is not None:
            print("%s\t%s" % (current, total))
        current, total = key, val
if current is not None:
    print("%s\t%s" % (current, total))
