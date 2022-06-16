# final_project
this is my final B.sc project, implement Anubis algorithm on FPGA

anubis algorithm:
the anubis algorithm build from 6 basic functions:
1. gamma - the sbox of the algorithm
2. tau - matrix transpose
3. theta - diffusion layer
4. pi - permutation
5. omega - key extraction
6. sigma - bitwise xor

from this 6 function we build the round and key schdule of the project.
the key schedule itself is build form 2 sub modules: key evolution and key selection.

mathematical background:
the anubis algorithm refer the plain text and cipher text as matrices. each element in the matrix is belong to galois field 2^8.
the immediate implication is the mathemtic operation are different from the regular ones:
1. adding will be represented by bitwise xor
2. multiplication will be represented by polynoms multiplication with primitive polynom: x^8 + x^4 + x^3 + x^2 + 1

