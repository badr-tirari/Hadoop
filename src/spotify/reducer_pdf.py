import sys
import matplotlib
matplotlib.use('Agg')                 # backend sans affichage (conteneur sans X)
import matplotlib.pyplot as plt

# Exercice 5 : recoit la sortie deja agregee (annee\ttotal), la reagrege par
# securite, imprime la sortie standard triee, et exporte un PDF (camembert + barres).
out = sys.argv[1] if len(sys.argv) > 1 else 'streams_par_annee.pdf'
agg = {}
for line in sys.stdin:
    parts = line.rstrip('\n').split('\t', 1)
    if len(parts) < 2:
        continue
    try:
        year, val = int(parts[0]), int(parts[1])
    except ValueError:
        continue
    agg[year] = agg.get(year, 0) + val

years = sorted(agg)
for y in years:
    print("%s\t%s" % (y, agg[y]))      # sortie standard agregee

pairs = sorted(agg.items(), key=lambda kv: kv[1], reverse=True)
top = pairs[:10]
autres = sum(v for _, v in pairs[10:])
labels = [str(y) for y, _ in top] + (['Autres'] if autres else [])
sizes = [v for _, v in top] + ([autres] if autres else [])

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))
ax1.pie(sizes, labels=labels, autopct='%1.1f%%', startangle=90)
ax1.set_title('Streams par annee (top 10 + autres)')
ax2.bar([str(y) for y in years], [agg[y] for y in years])
ax2.set_title('Total streams par annee de sortie')
ax2.tick_params(axis='x', rotation=90, labelsize=6)
plt.tight_layout()
plt.savefig(out)
print("PDF ecrit : %s" % out, file=sys.stderr)
