all: sri/generated.mk #morph-a/generated.mk morph-b/generated.mk
	make -j4 -f sri/generated.mk

sri/generated.mk: make_makefile.py sri/input/sizes.txt
	python make_makefile.py > sri/generated.mk

sri/input/sizes.txt:
	python make_sizes.py > sri/input/sizes.txt

clean:
	rm */output/*.txt */summary/*.txt */generated.mk */input/sizes.txt
