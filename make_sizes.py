for i in range(1, 9):
    print i

for j in range(1, 14):
    for i in [5, 6, 7, 8]:
        if i * 2**j < 65536:
            print i * 2**j
            print i * 2**j + 1
