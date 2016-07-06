def strip_string(self, string, mode='both', characters=None):
    """Remove leading and/or trailing whitespaces from the given string.

    ``mode`` is either ``left`` to remove leading characters, ``right`` to
    remove trailing characters, ``both`` (default) to remove the
    characters from both sides of the string or ``none`` to return the
    unmodified string.

    If the optional ``characters`` is given, it must be a string and the
    characters in the string will be stripped in the string. Please note,
    that this is not a substring to be removed but a list of characters,
    see the example below.

    Examples:
    | ${stripped}=  | Strip String | ${SPACE}Hello${SPACE} | |
    | Should Be Equal | ${stripped} | Hello | |
    | ${stripped}=  | Strip String | ${SPACE}Hello${SPACE} | mode=left |
    | Should Be Equal | ${stripped} | Hello${SPACE} | |
    | ${stripped}=  | Strip String | aabaHelloeee | characters=abe |
    | Should Be Equal | ${stripped} | Hello | |

    New in Robot Framework 3.0.
    """
    try:
        method = {'BOTH': string.strip,
                  'LEFT': string.lstrip,
                  'RIGHT': string.rstrip,
                  'NONE': lambda characters: string}[mode.upper()]
    except KeyError:
        raise ValueError("Invalid mode '%s'." % mode)
    return method(characters)