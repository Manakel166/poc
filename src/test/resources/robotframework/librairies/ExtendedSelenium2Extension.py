from robot.libraries.BuiltIn import BuiltIn

def title_should_start_with(expected):
    seleniumlib = BuiltIn().get_library_instance('ExtendedSelenium2Library')
    title = seleniumlib.get_title()
    if not title.startswith(expected):
        raise AssertionError("Title '%s' did not start with '%s'"
                             % (title, expected))



def get_element_count(locator):
    """Returns the number of elements of all WebElement objects matching locator.

        See `introduction` for details about locating elements.
    """
    seleniumlib = BuiltIn().get_library_instance('ExtendedSelenium2Library')
    found_elements=seleniumlib.get_webelements(locator)
    return len(found_elements)                            
                             

def click_the_nth_element(locator,index):
    """click the nth elements of all WebElement objects matching locator.

        See `introduction` for details about locating elements.
    """
    seleniumlib = BuiltIn().get_library_instance('ExtendedSelenium2Library')
    found_elements=seleniumlib.get_webelements(locator)
    found_elements[int(index)].click()
    return found_elements[int(index)]

    
def click_element_in_table_column( table_locator, col, expected, loglevel='INFO'):
        """Click the Element matching the expected content in the column passed as argument.

        The first leftmost column is column number 1. A negative column
        number can be used to get column counting from the end of the row (end: -1).
        If the table contains cells that span multiple columns, those merged cells
        count as a single column. 

        To understand how tables are identified, please take a look at
        the `introduction`.

        See `Page Should Contain Element` for explanation about
        `loglevel` argument.
        """
        seleniumlib = BuiltIn().get_library_instance('ExtendedSelenium2Library')
        element = seleniumlib._table_element_finder.find_by_col(seleniumlib._current_browser(), table_locator, col, expected)
        if element is None:
            seleniumlib.log_source(loglevel)
            raise AssertionError("Column #%s in table identified by '%s' "
                   "should have contained text '%s'."
                   % (col, table_locator, expected))
        else:
            print element
            element.find_element_by_xpath(".//a").click()

            
                   
    
