# EX04 Ex7 : lit 'artiste\ttotal' agrege et l'insere dans la table HBase streams_artist.
import sys, happybase
conn = happybase.Connection('127.0.0.1', 9090)
if b'streams_artist' not in conn.tables():
    conn.create_table('streams_artist', {'cf': dict()})
t = conn.table('streams_artist')
n = 0
for line in sys.stdin:
    parts = line.rstrip('\n').split('\t', 1)
    if len(parts) < 2:
        continue
    artist, total = parts
    try:
        int(total)
    except ValueError:
        continue
    t.put(artist.encode(), {b'cf:total': total.encode()})
    n += 1
conn.close()
print("streams_artist : %d lignes inserees" % n, file=sys.stderr)
