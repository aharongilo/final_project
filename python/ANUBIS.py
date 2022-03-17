import make_sbox
import anubis_functions

def round_function(plain_text: list,round_key: int)-> str:
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

    ## theta ##

    #R# sigma ##

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

if __name__=="main":
    pass