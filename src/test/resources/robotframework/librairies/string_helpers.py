def strip_string(string, mode='both', characters=None):
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
    
    
def replace_string(string, search_for, replace_with, count=-1):
    """Replaces ``search_for`` in the given ``string`` with ``replace_with``.

    ``search_for`` is used as a literal string. See `Replace String
    Using Regexp` if more powerful pattern matching is needed.
    If you need to just remove a string see `Remove String`.

    If the optional argument ``count`` is given, only that many
    occurrences from left are replaced. Negative ``count`` means
    that all occurrences are replaced (default behaviour) and zero
    means that nothing is done.

    A modified version of the string is returned and the original
    string is not altered.

    Examples:
    | ${str} =        | Replace String | Hello, world!  | world | tellus   |
    | Should Be Equal | ${str}         | Hello, tellus! |       |          |
    | ${str} =        | Replace String | Hello, world!  | l     | ${EMPTY} | count=1 |
    | Should Be Equal | ${str}         | Helo, world!   |       |          |
    """
    try:
        icount= int(count)
    except ValueError:
        raise ValueError("Cannot convert 'count' argument  to an integer.")
    return string.replace(search_for, replace_with, icount)
