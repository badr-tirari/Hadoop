import sys
# Moyenne par cle (Exercices 2 & 4) : deux accumulateurs somme + compte.
# "Le combiner ne sait pas moyenner" -> ici pas de combiner, le reducer voit tout.
current, s, n = None, 0.0, 0
def emit(k, s, n):
    if n:
        print("%s\t%.2f" % (k, s / n))
for line in sys.stdin:
    parts = line.rstrip('\n').split('\t', 1)
    if len(parts) < 2:
        continue
    key = parts[0]
    try:
        val = float(parts[1])
    except ValueError:
        continue
    if key == current:
        s += val; n += 1
    else:
        emit(current, s, n) if current is not None else None
        current, s, n = key, val, 1
if current is not None:
    emit(current, s, n)
