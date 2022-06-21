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
(7. round constant - using for sigma in key evolution module)

from this 6 function we build the round and key schdule of the project.
the key schedule itself is build form 2 sub modules: key evolution and key selection.

mathematical background:
the anubis algorithm refer the plain text and cipher text as matrices. each element in the matrix is belong to galois field 2^8.
the immediate implication is the mathemtic operation are different from the regular ones:
1. adding will be represented by bitwise xor
2. multiplication will be represented by polynoms multiplication with primitive polynom: x^8 + x^4 + x^3 + x^2 + 1

the size of the matrices in the algorithm is:
plain text: 4x4
key: Nx4 (4<=N<=10) (to keep it simple, we decided to go with 4x4 key in our project)
cipher: 4x4

therefor, we will treat our inputs and output (plain text, key and cipher), which represent as 128 bits vector in verilog, as 4x4 matrices, when the MSB byte is the bottom right parameter in the matrix, and the LSB is the upper left parameter in the matrix.

algorithm flow:
the algorithm is build from 12 rounds. each round get a unique key produced by key schedule module.
key shcedule:
key schedule build from 2 modules: key evolution and key selection.
in the first round, the input is the key inputted to the algorithm. it been threw the key evolution and it's output go to key selection and back as an input to itself in the next round. the output of the key selection is the round key for the current round.

key evolution module is using the functions: gamma -> pi -> theta -> sigma(with round constants) in this order, when the output of the left is the input of the right.
key selection module is using the functions: gamma -> omega -> tau in this order, when the output of the left is the input of the right.

the round module is using the functions: gamma -> tau -> theta -> sigma(with round key) in this order, when the output of the left is the input of the right.
