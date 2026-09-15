# EX06 III (HappyBase) : memes operations que biblio.hb, via Python.
import happybase

c = happybase.Connection('127.0.0.1', 9090)   # autoconnect=True -> pas de .open()
name = 'bibliotheque_py'
if name.encode() not in c.tables():
    c.create_table(name, {'auteur': dict(), 'livre': dict()})   # 1. table 2 familles
t = c.table(name)

# 2. insertion
t.put(b'vhugo', {b'auteur:nom': 'Hugo'.encode(), b'auteur:prenom': 'Victor'.encode(),
                 b'livre:titre': 'La légende des siècles'.encode(),
                 b'livre:categ': 'Poèmes'.encode(), b'livre:date': b'1855'})
t.put(b'jverne', {b'auteur:nom': 'Verne'.encode(), b'auteur:prenom': 'Jules'.encode(),
                  b'livre:titre': 'Face au drapeau'.encode(),
                  b'livre:categ': 'Roman'.encode(), b'livre:date': b'1896'})

def show(label):
    print("--- %s ---" % label)
    for k, d in t.scan():
        print(" ", k.decode(), {kk.decode(): vv.decode() for kk, vv in d.items()})

show("3. scan complet")

# 4. livres de vhugo
print("--- 4. livres de vhugo ---")
print(" ", {k.decode(): v.decode() for k, v in t.row(b'vhugo', columns=[b'livre']).items()})

# 5. date de vhugo -> 2024
t.put(b'vhugo', {b'livre:date': b'2024'})
# 6. supprimer livre:categ de vhugo
t.delete(b'vhugo', columns=[b'livre:categ'])

# 7. livres sortis apres 2000 (comparaison binaire)
print("--- 7. livres date >= 2000 ---")
for k, d in t.scan(filter="SingleColumnValueFilter('livre','date',>=,'binary:2000')"):
    print(" ", k.decode(), {kk.decode(): vv.decode() for kk, vv in d.items()})

# 8. supprimer toute la ligne jverne
t.delete(b'jverne')
show("final (jverne supprime, vhugo date=2024, categ supprimee)")
c.close()
