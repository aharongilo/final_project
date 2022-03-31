import make_sbox
import anubis_functions

def turnToHex(matrix):
    result = []
    for i in matrix:
        t = hex(i)
        result.append(t)
    return result

def round_function(plain_text: list,round_key: list)-> str:
    """
    round of the ANUBIS algorithm
    :param plain_text: text to crypt,
    :param round_key: the key to encrypt with for this round
    :return: cipher text of this round of encrypting
    """
    ## gamma ##
    text_list = []
    for i in plain_text:
        temp = make_sbox.gamma(i)
        text_list.append(temp)


    ## tau ##
    temp0 = 1
    after_tau = anubis_functions.transpose(text_list)
    ## theta ##
    temp1 = turnToHex(after_tau)
    after_theta =anubis_functions.diffusion(temp1)
    ## sigma ##
    cipher = []
    for r in range(16):
        xored_param = int(round_key[r],16)^int(after_theta[r],16)
        cipher.append(hex(xored_param))
    print([hex(i) for i in text_list])
    print([hex(k) for k in after_tau])
    # print(turnToHex(text_list))
    # print(turnToHex(after_tau))
    print(after_theta)
    return cipher

def key_schedule(key,round_constant):
    """
    make the keys to every round in the algorithm
    :param key: key for encryption
    :param round_constant: for algorithm purpose
    :return: round key for every round
    """
    ## gamma ##
    ## pi ##
    ## theta ##
    ## sigma ##
    ## gamma ##
    ## omega ##
    ## tau ##
    pass

# b = ["0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33"]
# k = ["0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33"]
# a = round_function(b,k)
# print(a)
lst = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
with open("C:\\Users\\aharo\\Desktop\\round_test_vector.txt", "w") as file:
    for i in range(16):
        text = []
        double_list = lst + lst
        for j in range(0,len(double_list),2):
            text.append(f"{double_list[j]}{double_list[j+1]}")
        lst = lst[1:] + [lst[0]]
        key = lst + lst
        a = round_function(text,key)
        b = []
        for j,param in enumerate(a):
             b.append(param.replace("0x",'').zfill(2))
        print(f"{''.join(text)} {''.join(key)} {''.join(b)}\n")
        file.write(f"{''.join(text)} {''.join(key)} {''.join(b)}\n")
# a = int("4f684f68618661864fc94fc9ea4aea4a",16)
# b = "123456789abcdef0123456789abcdef0"
# #c = "5d5c1910fb3abf765dfd19b170f634ba"
# c = "b76579fc1f9ce49aee9a3e20f069469a"
# d = []
# e = []
# for i in c:
#     d.append(i)
#
# for j in b:
#     e.append(j)
# print(round_function(d,e))