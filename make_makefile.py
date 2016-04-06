def get_max_iter(size, np):
    return 2

    if size < 20:
        return 1000000
    elif size < 100:
        return 100000
    elif size < 1000:
        return 10000
    else:
        return 500

with open("input/sizes.txt") as f:
    sizes = [int(sz) for sz in f.readlines()]


nps = [np for np in sizes if np < 500]

def get_nps(size):
    return [np for np in nps if np <= size and (np==size or np%2==0)] 

print "SR=sr"
print "SRFLAGS=--random --timeout 1000000 -a --record-sizes --gen-type 8 --type 4"

print "all: summary/counts.txt summary/sizes.txt summary/all.txt"

print "summary/counts.txt: {}".format(" ".join("output/{}-{}.txt".format(size, np) for size in sizes for np in get_nps(size)))
for size in sizes:
    for np in get_nps(size):
            print "\tcat output/{}-{}.txt | awk -v nagents={} -v np={} '/sol_count/ {{print nagents, np, $$2, $$3}}' >> summary/counts.txt".format(size, np, size, np)

print "summary/sizes.txt: {}".format(" ".join("output/{}-{}.txt".format(size, np) for size in sizes for np in get_nps(size)))
for size in sizes:
    for np in get_nps(size):
            print "\tcat output/{}-{}.txt | awk -v nagents={} -v np={} '/sol_size/ {{print nagents, np, $$2, $$3}}' >> summary/sizes.txt".format(size, np, size, np)

print "summary/all.txt: {}".format(" ".join("output/{}-{}.txt".format(size, np) for size in sizes for np in get_nps(size)))

for size in sizes:
    for np in get_nps(size):
        print "\ttail -q -n 1 output/{}-{}.txt >> summary/all.txt".format(size, np)

for size in sizes:
    for np in get_nps(size):
            print "output/{}-{}.txt:".format(size, np)
            print "\t$(SR) $(SRFLAGS) -n {} --np {} --maxiter {} --seed $$(python -c 'import random;print random.randint(1,1000000000)') > output/{}-{}.txt".format(
                    size, np, get_max_iter(size, np), size, np)
