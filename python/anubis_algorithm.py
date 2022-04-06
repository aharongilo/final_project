"""
matrix = list of 16 number in hexadecimal, where each number represent one byte
"""
class MyMatrix():
    def init(self,numbers: list, size: int):
        """
        we will create a matrix form a list on strings, when each string represent a
        hexadecimal number between 0 to 256 (one byte)
        :param numbers: list of numbers to create matrix from them
        :return: matrix = list of 16 number in hexadecimal, where each number represent one byte
        """
        self.size = size
        if type(numbers) != list:
            assert False, "please enter a list to make a matrix"
        if len(numbers) != self.size:
            assert False, "please enter a list size of 16"


