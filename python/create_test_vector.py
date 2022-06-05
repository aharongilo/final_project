string1 = "key"
string2 = "plain"
string3 = "cipher"

with open ("C:\\Users\\aharo\\Desktop\\anubis128-test-vectors.txt","r") as read_file:
    with open ("C:\\Users\\aharo\\Desktop\\anubis_test_vector.txt","w") as write_file:
        lines = read_file.readlines()
        for i in range(len(lines)):
            if string1 in lines[i]:
                line_string11 = ""
                line_string22 = ""
                line_string33 = ""
                line_string1 = lines[i]
                index1 = line_string1.find("=")
                line_string2 = lines[i+1]
                index2 = line_string2.find("=")
                line_string3 = lines[i+2]
                index3 = line_string3.find("=")
                for j in range(len(line_string1) - index1 - 3, 0, -2):
                    line_string11 = line_string11 + line_string1[index1+1:len(line_string1)-1][j - 1] + line_string1[index1+1:len(line_string1)-1][j]
                    line_string22 = line_string22 + line_string2[index2 + 1:len(line_string2)-1][j - 1] + line_string2[index2 + 1:len(line_string2)-1][j]
                    line_string33 = line_string33 + line_string3[index3 + 1:len(line_string3)-1][j - 1] + line_string3[index3 + 1:len(line_string3)-1][j]
                write_string = f"{line_string11} {line_string22} {line_string33}\n"
                write_file.write(write_string)

# a ="12 34 56 78 9987654"
# b = ""
# for i in range(len(a)-1,0,-2):
#     b= b + a[i-1] + a[i]
# print(b)