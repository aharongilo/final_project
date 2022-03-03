results = [0xa7, 0xd3, 0xe6, 0x71, 0xd0, 0xac, 0x4d, 0x79,
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
    0xa4, 0x2f, 0x95, 0x13, 0x0b, 0xf3, 0xe0, 0x37] # list of strings

with open("C:\\Users\\aharo\\Desktop\\sbox_vecotr.txt","w") as file:
    for i in range(255):
        temp = hex(i)[2:]
        temp_r = hex(results[i])[2:] # from the string "0xaa" we take only "aa"
        file.write(f"\t\t8h'{temp}: OUT = 8h'{temp_r}\n")
