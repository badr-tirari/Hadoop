import sys
current = None
total = 0
for line in sys.stdin:
    word, count = line.strip().split("\t")
    count = int(count)
    if word == current:          # corrige: == (l'enonce avait un seul =)
        total += count
    else:
        if current:
            print(current + "\t" + str(total))
        current = word
        total = count
if current:
    print(current + "\t" + str(total))
