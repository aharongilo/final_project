####  test vector for tau (transpose)   ####
def make_matrix(a):
     b = []
     for i in range(2):
         print("a matrix is:")
         print(a,len(a))
         for j in range(0,len(a)-1,2):
             if j%2 == 0:
                 print(j)
                 b = b + [f"{a[j]}{a[j+1]}"]
         a = [a[len(a)-1]] + a[:len(a)-1]
     return b

def transpose(matrix):
    t = []
    t.append(matrix[0])
    t.append(matrix[4])
    t.append(matrix[8])
    t.append(matrix[12])
    t.append(matrix[1])
    t.append(matrix[5])
    t.append(matrix[9])
    t.append(matrix[13])
    t.append(matrix[2])
    t.append(matrix[6])
    t.append(matrix[10])
    t.append(matrix[14])
    t.append(matrix[3])
    t.append(matrix[7])
    t.append(matrix[11])
    t.append(matrix[15])
    return t

if __name__=="main":
    lst = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
    with open("C:\\Users\\aharo\\Desktop\\tau_test_vetor.txt","w") as file:
        for i in range(16):
            mat = make_matrix(lst)
            lst = lst[1:] + [lst[0]]
            file.write(f"{''.join(mat)} {''.join(transpose(mat))}\n")