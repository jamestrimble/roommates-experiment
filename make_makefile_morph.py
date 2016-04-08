import sys

if len(sys.argv) != 3:
    print "python {} <dir-name> <gen-type>".format(sys.argv[0])
    sys.exit(1)

base_dir = sys.argv[1]
gen_type = sys.argv[2]

def get_max_iter(size, p):
    return 1000

with open("{}/input/sizes.txt".format(base_dir)) as f:
    sizes = [int(sz) for sz in f.readlines()]

ps = range(1001)
max_p = max(ps)

print "SR=sr"
print "SRFLAGS=--random --timeout 1000000 -a --record-sizes --gen-type {} --type 4".format(gen_type)

print "all: {0}/summary/counts.txt {0}/summary/sizes.txt {0}/summary/all.txt".format(base_dir)

output_files = " ".join("{}/output/{}-{}.txt".format(base_dir, size, p) for size in sizes for p in ps)

for measure in ["count", "size"]:
    print "{}/summary/{}s.txt: {}".format(base_dir, measure, output_files)
    for size in sizes:
        for p in ps:
                print "\tcat {0}/output/{1}-{2}.txt | awk -v nagents={1} -v p={2} '/sol_{3}/ {{print nagents, p, $$2, $$3}}' >> {0}/summary/{3}s.txt".format(
                        base_dir, size, p, measure)

print "{}/summary/all.txt: {}".format(base_dir, output_files)

for size in sizes:
    for p in ps:
        print "\ttail -q -n 1 {}/output/{}-{}.txt >> {}/summary/all.txt".format(base_dir, size, p, base_dir)

random_gen_script = "import random;print random.randint(1,1000000000)"
for size in sizes:
    for p in ps:
            print "{}/output/{}-{}.txt:".format(base_dir, size, p)
            print "\t$(SR) $(SRFLAGS) -n {0} --p {1} --maxiter {2} --seed $$(python -c '{4}') > {3}/output/{0}-{5}.txt".format(
                    size, p/float(max_p), get_max_iter(size, p), base_dir, random_gen_script, p)
