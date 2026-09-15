# EX04 Ex6 : lit 'annee\ttotal' agrege et l'insere dans la table HBase streams_year.
import sys, happybase
conn = happybase.Connection('127.0.0.1', 9090)
if b'streams_year' not in conn.tables():
    conn.create_table('streams_year', {'cf': dict()})
t = conn.table('streams_year')
n = 0
for line in sys.stdin:
    parts = line.rstrip('\n').split('\t', 1)
    if len(parts) < 2:
        continue
    year, total = parts
    try:
        int(total)
    except ValueError:
        continue
    t.put(year.encode(), {b'cf:total': total.encode()})
    n += 1
conn.close()
print("streams_year : %d lignes inserees" % n, file=sys.stderr)
