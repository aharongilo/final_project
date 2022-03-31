"""
matrix = list of 16 number in hexadecimal, where each number represent one byte
"""
import anubis_functions

a = ['4f', '68', '4f', '68', '61', '86', '61', '86', '4f', 'c9', '4f', 'c9', 'ea', '4a', 'ea', '4a']
k = ["12","34","56","78","9a","bc","de","f0","12","34","56","78","9a","bc","de","f0"]
a1 = "4f684f68618661864fc94fc9ea4aea4a"
k1 = "123456789abcdef0123456789abcdef0"

cipher = []
for i in range(16):
    xored_param = int(k[i],16)^int(a[i],16)
    cipher.append(hex(xored_param))
result = hex(int(a1,16) ^ int(k1,16))

print(f"cipher = {cipher}")
print(f"result = {result}")