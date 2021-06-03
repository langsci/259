"""
Get rid of selected LaTeX features which cause problems in various respects
"""

import re

LATEXDIACRITICS = """'`^~"=.vdHuk"""


def dediacriticize(s, stripbraces=True):
    """
    Remove all LaTeX styles diacritics from the input and return the bare string
     
    LaTeX offers a variety of diacritics via {\_{x}}, where the underscore can be any of the following
    - ' : acute
    - ` :grave
    - ^ :circumflex
    - ~ :tilde
    - "  :dieresis
    - = :macron
    - . :dot above
    - v :hacek
    - d :dot_below
    - H :double acute
    - u :breve
    - k :ogonek

    The braces are optional, but commonly used. 
    
    Args: 
      s (str): the string to dediacriticize
      
    Returns:
      str: the input string stripped of LaTeX diacritics
      
    """
    tmpstring = s
    if stripbraces:
        # get rid of Latex diacritics like {\'{e}}
        tmpstring = re.sub(r"{\\[%s]{([A-Za-z])}}" % LATEXDIACRITICS, r"\1", tmpstring)
    # get rid of Latex diacritics like \'{e}
    tmpstring = re.sub(r"\\[%s]{([A-Za-z])}" % LATEXDIACRITICS, r"\1", tmpstring)
    # get rid of Latex diacritics like \'e
    result = re.sub(r"\\[%s]([A-Za-z])" % LATEXDIACRITICS, r"\1", tmpstring)
    return result
