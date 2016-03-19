all: generated.mk
	make -j4 -f generated.mk

generated.mk: make_makefile.py input/sizes.txt
	python make_makefile.py > generated.mk

input/sizes.txt:
	python make_sizes.py > input/sizes.txt

clean:
	rm output/*.txt summary/*.txt generated.mk input/sizes.txt
