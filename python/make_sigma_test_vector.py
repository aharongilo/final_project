with open("C:\\Users\\aharo\\Desktop\\sigma_test_vetor.txt","w") as file:
    #0 xor 0 = 0
    for i in range(128):
        file.write("0")
    file.write(" ")
    for i in range(128):
        file.write("0")
    file.write(" ")
    for i in range(128):
        file.write("0")
    file.write("\n")
    # 1 xor 1 = 0
    for i in range(128):
        file.write("1")
    file.write(" ")
    for i in range(128):
        file.write("1")
    file.write(" ")
    for i in range(128):
        file.write("0")
    file.write("\n")
    # 10 xor 01 = 11
    for i in range(128):
        if i%2 == 0:
            file.write("0")
        else:
            file.write("1")
    file.write(" ")
    for i in range(128):
        if i % 2 == 0:
            file.write("1")
        else:
            file.write("0")
    file.write(" ")
    for i in range(128):
        file.write("1")
    file.write("\n")
    # 01 xor 10 = 11
    for i in range(128):
        if i%2 == 0:
            file.write("1")
        else:
            file.write("0")
    file.write(" ")
    for i in range(128):
        if i % 2 == 0:
            file.write("0")
        else:
            file.write("1")
    file.write(" ")
    for i in range(128):
        file.write("1")
    file.write("\n")