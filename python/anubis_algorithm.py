"""
matrix = list of 16 number in hexadecimal, where each number represent one byte
"""


def Gmult(num1: int, num2: int, pri_polynomial: int, power: bool = False) -> int:
    """ multiplication over Galois field
    this function receive 2 number to multiply, and the relevant primitive polynomial for the Galois field, and do the
    multiplication
    Args:
        num1(int): first number to multiply
        num2(int): second number to multiply
        pri_polynomial(int): relevant polynomial for the Galois field
        power(bool): for future implementation- expand the function abilities to do exponent calculation as well
    Return:
        int(): the multiplication result
        """
    if power:  # exponent option - future implementation
        base = num1
        power_by = num2
        temp = 0
        for _ in range(power_by - 1):
            temp = 0
            for counter, bit in enumerate(bin(num1)[2:]):
                if bit == '1':
                    temp = temp ^ (base << len(bin(num1)[2:]) - (counter + 1))
            base = temp
        if len(bin(temp)) < len(bin(pri_polynomial)):
            return temp
        elif len(bin(temp)) == len(bin(pri_polynomial)):
            return (temp - 2 ** (len(bin(temp)) - 1)) ^ (pri_polynomial - 2 ** (len(bin(pri_polynomial)) - 1))
        else:
            while len(bin(temp)) >= len(bin(pri_polynomial)):
                temp = temp ^ (pri_polynomial << (len(bin(temp)) - len(bin(pri_polynomial))))
    else:
        temp = 0
        # multiple:
        for counter, bit in enumerate(bin(num2)[2:]):  # checking the bits in num2, one by one
            if bit == '1':  # if this bit value is 1
                # do a shift left (equal to multiply by 2 in Galois field)
                temp = temp ^ (num1 << len(bin(num2)[2:]) - (counter + 1))
        # modulo:
        if len(bin(temp)) < len(bin(pri_polynomial)):  # if the highest degree in the multiplication. result is less
            # then in the primitive polynomial
            return temp
        elif len(bin(temp)) == len(bin(pri_polynomial)):  # if they equal
            return (temp - 2 ** (len(bin(temp)) - 1)) ^ (
                    pri_polynomial - 2 ** (len(bin(pri_polynomial)) - 1))  # the left after
            # divide the multiplication result in the primitive
        else:
            while len(bin(temp)) >= len(bin(pri_polynomial)):
                # find  the left after divide the multiplication result in the primitive until the left highest degree
                # is less then the highest degree in the primitive
                temp = temp ^ (pri_polynomial << (len(bin(temp)) - len(bin(pri_polynomial))))
    return temp


class AnubisAlgorithm:
    def __init__(self):
        self.constant_list = []
        self.round_constant()
        self.sbox = [0xa7, 0xd3, 0xe6, 0x71, 0xd0, 0xac, 0x4d, 0x79,
                     0x3a, 0xc9, 0x91, 0xfc, 0x1e, 0x47, 0x54, 0xbd,
                     0x8c, 0xa5, 0x7a, 0xfb, 0x63, 0xb8, 0xdd, 0xd4,
                     0xe5, 0xb3, 0xc5, 0xbe, 0xa9, 0x88, 0x0c, 0xa2,
                     0x39, 0xdf, 0x29, 0xda, 0x2b, 0xa8, 0xcb, 0x4c,
                     0x4b, 0x22, 0xaa, 0x24, 0x41, 0x70, 0xa6, 0xf9,
                     0x5a, 0xe2, 0xb0, 0x36, 0x7d, 0xe4, 0x33, 0xff,
                     0x60, 0x20, 0x08, 0x8b, 0x5e, 0xab, 0x7f, 0x78,
                     0x7c, 0x2c, 0x57, 0xd2, 0xdc, 0x6d, 0x7e, 0x0d,
                     0x53, 0x94, 0xc3, 0x28, 0x27, 0x06, 0x5f, 0xad,
                     0x67, 0x5c, 0x55, 0x48, 0x0e, 0x52, 0xea, 0x42,
                     0x5b, 0x5d, 0x30, 0x58, 0x51, 0x59, 0x3c, 0x4e,
                     0x38, 0x8a, 0x72, 0x14, 0xe7, 0xc6, 0xde, 0x50,
                     0x8e, 0x92, 0xd1, 0x77, 0x93, 0x45, 0x9a, 0xce,
                     0x2d, 0x03, 0x62, 0xb6, 0xb9, 0xbf, 0x96, 0x6b,
                     0x3f, 0x07, 0x12, 0xae, 0x40, 0x34, 0x46, 0x3e,
                     0xdb, 0xcf, 0xec, 0xcc, 0xc1, 0xa1, 0xc0, 0xd6,
                     0x1d, 0xf4, 0x61, 0x3b, 0x10, 0xd8, 0x68, 0xa0,
                     0xb1, 0x0a, 0x69, 0x6c, 0x49, 0xfa, 0x76, 0xc4,
                     0x9e, 0x9b, 0x6e, 0x99, 0xc2, 0xb7, 0x98, 0xbc,
                     0x8f, 0x85, 0x1f, 0xb4, 0xf8, 0x11, 0x2e, 0x00,
                     0x25, 0x1c, 0x2a, 0x3d, 0x05, 0x4f, 0x7b, 0xb2,
                     0x32, 0x90, 0xaf, 0x19, 0xa3, 0xf7, 0x73, 0x9d,
                     0x15, 0x74, 0xee, 0xca, 0x9f, 0x0f, 0x1b, 0x75,
                     0x86, 0x84, 0x9c, 0x4a, 0x97, 0x1a, 0x65, 0xf6,
                     0xed, 0x09, 0xbb, 0x26, 0x83, 0xeb, 0x6f, 0x81,
                     0x04, 0x6a, 0x43, 0x01, 0x17, 0xe1, 0x87, 0xf5,
                     0x8d, 0xe3, 0x23, 0x80, 0x44, 0x16, 0x66, 0x21,
                     0xfe, 0xd5, 0x31, 0xd9, 0x35, 0x18, 0x02, 0x64,
                     0xf2, 0xf1, 0x56, 0xcd, 0x82, 0xc8, 0xba, 0xf0,
                     0xef, 0xe9, 0xe8, 0xfd, 0x89, 0xd7, 0xc7, 0xb5,
                     0xa4, 0x2f, 0x95, 0x13, 0x0b, 0xf3, 0xe0, 0x37]  # list of strings

    def round_constant(self):
        """ round constant of the algorithm"""
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
        self.constant_list = [round_con1, round_con2, round_con3, round_con4, round_con5, round_con6, round_con7,
                              round_con8, round_con9, round_con10, round_con11, round_con12]

    def gamma(self, vector: list) -> list:
        """ gamma function of the Anubis algorithm
        Args:
            vector(list): raw data to perform the mathematical operation on
        Return:
            list(): the data after the mathematical operation
            """
        result = []
        for data_byte in vector:
            result.append(hex(self.sbox[int(data_byte, 16)]).replace("0x", '').zfill(2))
        return result

    @staticmethod
    def tau(matrix: list) -> list:
        """
        tau function (matrix transpose) in ANUBIS algorithm
        Args:
            matrix(list): 4x4 matrix
        Return:
             list(): the transpose matrix of the input
        """
        transpose = [matrix[0], matrix[4], matrix[8], matrix[12], matrix[1], matrix[5], matrix[9], matrix[13],
                     matrix[2], matrix[6], matrix[10], matrix[14], matrix[3], matrix[7], matrix[11], matrix[15]]
        return transpose

    @staticmethod
    def pi(matrix: list) -> list:
        """
        pi function(permutation) in ANUBIS algorithm
        Args:
            matrix(list): matrix of 16 parameters
        Return:
             list(): permuted matrix by the ANUBIS permutation
        """
        t = [matrix[0], matrix[13], matrix[10], matrix[7], matrix[4], matrix[1], matrix[14], matrix[11], matrix[8],
             matrix[5], matrix[2], matrix[15], matrix[12], matrix[9], matrix[6], matrix[3]]
        return t

    @staticmethod
    def omega(matrix: list) -> list:
        """
        omega function (key extract) test vector
        Args:
            matrix(list): matrix of 16 parameters
        Return:
             list(): 4x4 matrix of extracted key
        """
        primitive = 285
        result_matrix = [(int(matrix[0], 16) ^ int(matrix[4], 16) ^ int(matrix[8], 16) ^ int(matrix[12], 16)),
                         (int(matrix[1], 16) ^ int(matrix[5], 16) ^ int(matrix[9], 16) ^ int(matrix[13], 16)),
                         (int(matrix[2], 16) ^ int(matrix[6], 16) ^ int(matrix[10], 16) ^ int(matrix[14], 16)),
                         (int(matrix[3], 16) ^ int(matrix[7], 16) ^ int(matrix[11], 16) ^ int(matrix[15], 16)),
                         (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16), 2, primitive) ^ Gmult(int(matrix[8], 16), 4, primitive) ^ Gmult(int(matrix[12], 16), 8, primitive)),
                         (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16), 2, primitive) ^ Gmult(int(matrix[9], 16), 4, primitive) ^ Gmult(int(matrix[13], 16), 8, primitive)),
                         (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16), 2, primitive) ^ Gmult(int(matrix[10], 16), 4, primitive) ^ Gmult(int(matrix[14], 16), 8, primitive)),
                         (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16), 2, primitive) ^ Gmult(int(matrix[11], 16), 4, primitive) ^ Gmult(int(matrix[15], 16), 8, primitive)),
                         (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16), 6, primitive) ^ Gmult(int(matrix[8], 16), 20, primitive) ^ Gmult(int(matrix[12], 16), 120, primitive)),
                         (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16), 6, primitive) ^ Gmult(int(matrix[9], 16), 20, primitive) ^ Gmult(int(matrix[13], 16), 120, primitive)),
                         (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16), 6, primitive) ^ Gmult(int(matrix[10], 16), 20, primitive) ^ Gmult(int(matrix[14], 16), 120, primitive)),
                         (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16), 6, primitive) ^ Gmult(int(matrix[11], 16), 20, primitive) ^ Gmult(int(matrix[15], 16), 120, primitive)),
                         (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16), 8, primitive) ^ Gmult(int(matrix[8], 16), 64, primitive) ^ Gmult(int(matrix[12], 16), 58, primitive)),
                         (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16), 8, primitive) ^ Gmult(int(matrix[9], 16), 64, primitive) ^ Gmult(int(matrix[13], 16), 58, primitive)),
                         (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16), 8, primitive) ^ Gmult(int(matrix[10], 16), 64, primitive) ^ Gmult(int(matrix[14], 16), 58, primitive)),
                         (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16), 8, primitive) ^ Gmult(int(matrix[11], 16), 64, primitive) ^ Gmult(int(matrix[15], 16), 58, primitive))]
        for number in range(len(result_matrix)):  # change the int to (string of) hexadecimal numbers
            result_matrix[number] = hex(result_matrix[number])[2:].zfill(2)
        return result_matrix

    @staticmethod
    def theta(matrix: list) -> list:
        """
        theta function(diffusion) test vector
        Args:
            matrix(list): matrix of 16 parameters
        Return:
            list(): diffused matrix in ANUBIS method
        """
        primitive = 285
        defused_matrix = [(int(matrix[0], 16) ^ Gmult((int(matrix[1], 16) ^ int(matrix[3], 16)), 2, primitive) ^ Gmult((int(matrix[2], 16) ^ int(matrix[3], 16)), 4, primitive)),
                          (int(matrix[1], 16) ^ Gmult((int(matrix[0], 16) ^ int(matrix[2], 16)), 2, primitive) ^ Gmult((int(matrix[2], 16) ^ int(matrix[3], 16)), 4, primitive)),
                          (int(matrix[2], 16) ^ Gmult((int(matrix[1], 16) ^ int(matrix[3], 16)), 2, primitive) ^ Gmult((int(matrix[0], 16) ^ int(matrix[1], 16)), 4, primitive)),
                          (int(matrix[3], 16) ^ Gmult((int(matrix[0], 16) ^ int(matrix[2], 16)), 2, primitive) ^ Gmult((int(matrix[0], 16) ^ int(matrix[1], 16)), 4, primitive)),
                          (int(matrix[4], 16) ^ Gmult((int(matrix[5], 16) ^ int(matrix[7], 16)), 2, primitive) ^ Gmult((int(matrix[6], 16) ^ int(matrix[7], 16)), 4, primitive)),
                          (int(matrix[5], 16) ^ Gmult((int(matrix[4], 16) ^ int(matrix[6], 16)), 2, primitive) ^ Gmult((int(matrix[6], 16) ^ int(matrix[7], 16)), 4, primitive)),
                          (int(matrix[6], 16) ^ Gmult((int(matrix[5], 16) ^ int(matrix[7], 16)), 2, primitive) ^ Gmult((int(matrix[4], 16) ^ int(matrix[5], 16)), 4, primitive)),
                          (int(matrix[7], 16) ^ Gmult((int(matrix[4], 16) ^ int(matrix[6], 16)), 2, primitive) ^ Gmult((int(matrix[4], 16) ^ int(matrix[5], 16)), 4, primitive)),
                          (int(matrix[8], 16) ^ Gmult((int(matrix[9], 16) ^ int(matrix[11], 16)), 2, primitive) ^ Gmult((int(matrix[10], 16) ^ int(matrix[11], 16)), 4, primitive)),
                          (int(matrix[9], 16) ^ Gmult((int(matrix[8], 16) ^ int(matrix[10], 16)), 2, primitive) ^ Gmult((int(matrix[10], 16) ^ int(matrix[11], 16)), 4, primitive)),
                          (int(matrix[10], 16) ^ Gmult((int(matrix[9], 16) ^ int(matrix[11], 16)), 2, primitive) ^ Gmult((int(matrix[8], 16) ^ int(matrix[9], 16)), 4, primitive)),
                          (int(matrix[11], 16) ^ Gmult((int(matrix[8], 16) ^ int(matrix[10], 16)), 2, primitive) ^ Gmult((int(matrix[8], 16) ^ int(matrix[9], 16)), 4, primitive)),
                          (int(matrix[12], 16) ^ Gmult((int(matrix[13], 16) ^ int(matrix[15], 16)), 2, primitive) ^ Gmult((int(matrix[14], 16) ^ int(matrix[15], 16)), 4, primitive)),
                          (int(matrix[13], 16) ^ Gmult((int(matrix[12], 16) ^ int(matrix[14], 16)), 2, primitive) ^ Gmult((int(matrix[14], 16) ^ int(matrix[15], 16)), 4, primitive)),
                          (int(matrix[14], 16) ^ Gmult((int(matrix[13], 16) ^ int(matrix[15], 16)), 2, primitive) ^ Gmult((int(matrix[12], 16) ^ int(matrix[13], 16)), 4, primitive)),
                          (int(matrix[15], 16) ^ Gmult((int(matrix[12], 16) ^ int(matrix[14], 16)), 2, primitive) ^ Gmult((int(matrix[12], 16) ^ int(matrix[13], 16)), 4, primitive))]
        for number in range(len(defused_matrix)):  # change the int to (string of) hexadecimal numbers
            defused_matrix[number] = hex(defused_matrix[number]).replace("0x", '').zfill(2)
        return defused_matrix

    @staticmethod
    def sigma(num1: list, num2: list) -> list:
        """ sigma function in the Anubis algorithm
         Args:
             num1(list): first matrix to xor
             num2(list): second matrix to xor
         Return:
             list(): matrix after xor
             """
        result = []
        if len(num1) != len(num2):
            assert False, "please enter 2 numbers in the same length"
        else:
            for index in range(len(num1)):
                xored_param = int(num1[index], 16) ^ int(num2[index], 16)
                result.append(hex(xored_param).replace("0x", '').zfill(2))
        return result

    def key_evolution(self, raw_key: list, round_constant: list) -> list:
        """
        first part of the key schedule
        the function order in this part is gamma >> pi >> theta >> sigma
        Args:
            raw_key(list): key for encryption
            round_constant(list): for algorithm purpose
        Return:
            list(): round key for every round
        """
        key_list = self.gamma(raw_key)
        after_pi = self.pi(key_list)
        after_theta = self.theta(after_pi)
        evaluated_key = self.sigma(after_theta, round_constant)
        return evaluated_key

    def key_selection(self, evaluated_key: list) -> list:
        """
        the second part of the key schedule
        the function order in this part is gamma >> omega >> tau
        Args:
            evaluated_key(list): the results of the key evolution
        Return:
            list(): the key schedule for the round
        """
        key_list = self.gamma(evaluated_key)
        after_omega = self.omega(key_list)
        round_key = self.tau(after_omega)
        return round_key

    def round_function(self, plain_text: list, round_key: list, round_number: int) -> list:
        """ round of the ANUBIS algorithm
        the function order in Anubis round is gamma >> tau >> theta >> sigma
        Args:
            plain_text(list): text to crypt,
            round_key(list): the key to encrypt with for this round
            round_number(int): which number of round is it
        Return:
             list(): cipher text of this round of encrypting
        """
        text_list = self.gamma(plain_text)
        after_tau = self.tau(text_list)
        after_theta = self.theta(after_tau) if round_number != 12 else after_tau
        cipher = self.sigma(after_theta, round_key)
        return cipher

    def anubis_function(self, cipher_key: list, plain_text: list, encrypt=True) -> list:
        """ doing the encryption/decryption itself
        Args:
            cipher_key(list): key to encrypt/decrypt with
            plain_text(list): data to encrypt/decrypt
            encrypt(bool): is this encryption or decryption
        Return:
            list(): the encrypted/decrypted data
            """
        evaluated_key = [cipher_key]
        selected_key = [self.key_selection(cipher_key)]
        rounds_out = []
        key2use = cipher_key
        for key_e_round in range(12):
            evaluated_key.append(self.key_evolution(key2use, self.constant_list[key_e_round]))
            key2use = evaluated_key[len(evaluated_key) - 1]
        for key_s_round in range(12):
            selected_key.append(self.key_selection(evaluated_key[key_s_round + 1]))
        if encrypt:
            plain2use = self.sigma(self.key_selection(cipher_key), plain_text)
        else:
            plain2use = self.sigma(plain_text, selected_key[12])
        for cipher_round in range(12):
            if encrypt:
                rounds_out.append(self.round_function(plain2use, selected_key[cipher_round + 1], cipher_round + 1))
            elif round == 11:
                rounds_out.append(self.round_function(plain2use, selected_key[0], cipher_round + 1))
            else:
                rounds_out.append(
                    self.round_function(plain2use, self.theta(selected_key[11 - cipher_round]), cipher_round + 1))
            plain2use = rounds_out[len(rounds_out) - 1]
        cipher = rounds_out[11]
        return cipher


def main():
    plain = ["00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    key = ["00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    # plain2 = ["D7", "4C", "1B", "10", "C7", "D8", "91", "F4", "B4", "59", "1B", "2C", "DB", "93", "99", "10"]
    # plain1 = ["11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11"]
    # key1 = ["11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11", "11"]
    # expected_zeros = ["62", "5F", "0F", "66", "3B", "F0", "0F", "2D", "67", "B1", "E8", "B0", "4F", "67", "A4", "84"]
    anubis = AnubisAlgorithm()
    print(anubis.anubis_function(key, plain))


if __name__ == "__main__":
    main()
