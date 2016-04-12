base_dir="sri"

def get_max_iter(size, np):
    if size < 20:      return 1000000
    elif size < 100:   return 100000
    elif size < 1000:  return 20000
    elif size < 10000: return 5000
    else:              return 2000

with open("{}/input/sizes.txt".format(base_dir)) as f:
    sizes = [int(sz) for sz in f.readlines()]

nps = [np for np in sizes if np < 1000]

def get_nps(size):
    return [np for np in nps if np <= size and (np==size or np%2==0)] 

print "SR=sr"
print "SRFLAGS=--random --timeout 1000000 -a --record-sizes --gen-type 9 --type 4"

print "all: {0}/summary/counts.txt {0}/summary/sizes.txt {0}/summary/all.txt".format(base_dir)

output_files = " ".join("{}/output/{}-{}.txt".format(base_dir, size, np) for size in sizes for np in get_nps(size))

for measure in ["count", "size"]:
    print "{}/summary/{}s.txt: {}".format(base_dir, measure, output_files)
    for size in sizes:
        for np in get_nps(size):
                print "\tcat {0}/output/{1}-{2}.txt | awk -v nagents={1} -v np={2} '/sol_{3}/ {{print nagents, np, $$2, $$3}}' >> {0}/summary/{3}s.txt".format(
                        base_dir, size, np, measure)

print "{}/summary/all.txt: {}".format(base_dir, output_files)

for size in sizes:
    for np in get_nps(size):
        print "\ttail -q -n 1 {}/output/{}-{}.txt >> {}/summary/all.txt".format(base_dir, size, np, base_dir)

random_gen_script = "import random;print random.randint(1,1000000000)"
for size in sizes:
    for np in get_nps(size):
            print "{}/output/{}-{}.txt:".format(base_dir, size, np)
            print "\t$(SR) $(SRFLAGS) -n {0} --np {1} --maxiter {2} --seed $$(python -c '{4}') > {3}/output/{0}-{1}.txt".format(
                    size, np, get_max_iter(size, np), base_dir, random_gen_script)
