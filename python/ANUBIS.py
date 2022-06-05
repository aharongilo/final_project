import make_sbox
from anubis_functions import anubis_functions as anubis_functions

def turnToHex(matrix):
    result = []
    for i in matrix:
        t = hex(i)
        result.append(t)
    return result

def round_function(plain_text: list,round_key: list, round_number: int)-> str:
    """
    round of the ANUBIS algorithm
    :param round_number:
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
    key_matrix = anubis_functions.make_matrix(round_key)
    for r in range(16):
        xored_param = int(key_matrix[r],16)^int(after_theta[r],16)
        cipher.append(hex(xored_param))
    #print([hex(i) for i in text_list])
    #print([hex(k) for k in after_tau])
    # print(turnToHex(text_list))
    # print(turnToHex(after_tau))
    #print(after_theta)
    return cipher if round_number < 12 else after_theta

def key_evolution(key: list,round_constant: list)-> list:
    """
    first part of the key schedule
    :param key: key for encryption
    :param round_constant: for algorithm purpose
    :return: round key for every round
    """
    ## gamma ##
    key_list = []
    for i in key:
        temp = make_sbox.gamma(i)
        key_list.append(temp)
    ## pi ##
    after_pi = anubis_functions.permutation(key_list)
    ## theta ##
    temp1 = turnToHex(after_pi)
    after_theta = anubis_functions.diffusion(temp1)
    ## sigma ##
    evolutioned_key = []
    for r in range(16):
        xored_param = int(round_constant[r], 16) ^ int(after_theta[r], 16)
        evolutioned_key.append(hex(xored_param))
    #print(key_list)
    #print(after_pi)
    #print(after_theta)
    return evolutioned_key

def key_selection(evolutioned_key: list)->list:
    """
    the second part of the key schedule
    :param evolutioned_key: the results of the key evolution
    :return: the key schedule for the round
    """
    ## gamma ##
    key_list = []
    # for i in evolutioned_key:
    #     temp = make_sbox.gamma(i)
    #     key_list.append(temp)
    print(key_list)
    ## omega ##
    #temp1 = turnToHex(key_list)
    after_omega = anubis_functions.key_extract(turnToHex(key_list))
    print(after_omega)
    ## tau ##
    round_key = anubis_functions.transpose(after_omega)
    print(round_key)
    return round_key

# b = ["0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33"]
# k = ["0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33","0x00","0x11","0x22","0x33"]
# a = round_function(b,k)
# print(a)
lst = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
round_con1 = ["a7", "d3", "e6", "71", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con2 = ["d0", "ac", "4d", "79", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con3 = ["3a", "c9", "91", "fc", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con4 = ["1e", "47", "54", "bd", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con5 = ["8c", "a5", "7a", "fb", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con6 = ["63", "b8", "dd", "d4", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con7 = ["e5", "b3", "c5", "be", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con8 = ["a9", "88", "0c", "a2", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con9 = ["39", "df", "29", "da", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con10 = ["2b", "a8", "cb", "4c", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con11 = ["4b", "22", "aa", "24", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
round_con12 = ["41", "70", "a6", "f9", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
constant_list = [round_con1,round_con2,round_con3,round_con4,round_con5,round_con6,round_con7,round_con8,round_con9,round_con10,round_con11,round_con12]
with open("C:\\Users\\aharo\\Desktop\\key_selection_test_vector.txt", "w") as file:
    """ for round test vector """
    # for i in range(16):
    #     text = []
    #     double_list = lst + lst
    #     for j in range(0,len(double_list),2):
    #         text.append(f"{double_list[j]}{double_list[j+1]}")
    #     lst = lst[1:] + [lst[0]]
    #     key = lst + lst
    #     a = round_function(text,key)
    #     b = []
    #     for j,param in enumerate(a):
    #          b.append(param.replace("0x",'').zfill(2))
    #     print(f"{''.join(text)} {''.join(key)} {''.join(b)}\n")
    #     file.write(f"{''.join(text)} {''.join(key)} {''.join(b)}\n")
    """ for key evolution test vector """
    # for i in range(16):
    #     text = []
    #     double_list = lst + lst
    #     for j in range(0,len(double_list),2):
    #         text.append(f"{double_list[j]}{double_list[j+1]}")
    #     lst = lst[1:] + [lst[0]]
    #     if (i<12):
    #         a = key_evolution(text,constant_list[i])
    #     else:
    #         a = key_evolution(text, constant_list[11])
    #     b = []
    #     for j,param in enumerate(a):
    #          b.append(param.replace("0x",'').zfill(2))
    #     if(i<12):
    #         file.write(f"{''.join(text)} {''.join(constant_list[i])} {''.join(b)}\n")
    #         print(f"{''.join(text)} {''.join(constant_list[i])} {''.join(b)}\n")
    #     else:
    #         file.write(f"{''.join(text)} {''.join(constant_list[11])} {''.join(b)}\n")
    #         print(f"{''.join(text)} {''.join(constant_list[11])} {''.join(b)}\n")
    """ for key selection test vector """
    for i in range(16):
        text = []
        double_list = lst + lst
        for j in range(0,len(double_list),2):
            text.append(f"{double_list[j]}{double_list[j+1]}")
        lst = lst[1:] + [lst[0]]
        a = key_selection(text)
        b = []
        for j, param in enumerate(a):
            b.append(param.replace("0x", '').zfill(2))
        file.write(f"{''.join(text)} {''.join(b)}\n")
