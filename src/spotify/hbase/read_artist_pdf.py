# EX04 Ex7 : relit streams_artist depuis HBase et produit un PDF (top 15 artistes).
import sys, happybase
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

out = sys.argv[1] if len(sys.argv) > 1 else 'streams_artist.pdf'
conn = happybase.Connection('127.0.0.1', 9090)
t = conn.table('streams_artist')
data = {}
for k, v in t.scan():
    tot = v.get(b'cf:total')
    if tot:
        try:
            data[k.decode()] = int(tot)
        except ValueError:
            pass
conn.close()

top = sorted(data.items(), key=lambda kv: kv[1], reverse=True)[:15]
labels = [a for a, _ in top][::-1]
vals = [v for _, v in top][::-1]

fig, ax = plt.subplots(figsize=(12, 7))
ax.barh(labels, vals)
ax.set_title('Top 15 artistes par streams (lu depuis HBase streams_artist)')
ax.set_xlabel('streams')
plt.tight_layout()
plt.savefig(out)
print("PDF %s | %d artistes lus depuis HBase" % (out, len(data)), file=sys.stderr)
