all: sri/generated.mk morph-a/generated.mk morph-b/generated.mk
	make -j4 -f sri/generated.mk
	#make -j4 -f morph-a/generated.mk
	#make -j4 -f morph-b/generated.mk

sri/generated.mk: make_makefile_sri.py sri/input/sizes.txt
	python make_makefile_sri.py > sri/generated.mk

sri/input/sizes.txt: make_sizes.py
	python make_sizes.py > sri/input/sizes.txt

morph-a/generated.mk: make_makefile_morph.py morph-a/input/sizes.txt
	python make_makefile_morph.py morph-a 6 > morph-a/generated.mk

morph-a/input/sizes.txt:
	python make_sizes_morph.py > morph-a/input/sizes.txt

morph-b/generated.mk: make_makefile_morph.py morph-b/input/sizes.txt
	python make_makefile_morph.py morph-b 7 > morph-b/generated.mk

morph-b/input/sizes.txt: make_sizes_morph.py
	python make_sizes_morph.py > morph-b/input/sizes.txt

clean:
	rm */output/*.txt */summary/*.txt */generated.mk */input/sizes.txt
