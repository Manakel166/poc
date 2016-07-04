from robot.libraries.BuiltIn import BuiltIn

def title_should_start_with(expected):
    seleniumlib = BuiltIn().get_library_instance('Selenium2Library')
    title = seleniumlib.get_title()
    if not title.startswith(expected):
        raise AssertionError("Title '%s' did not start with '%s'"
                             % (title, expected))




def click_the_nth_element(locator,index):
    """Returns the nth elements of all WebElement objects matching locator.

        See `introduction` for details about locating elements.
    """
    seleniumlib = BuiltIn().get_library_instance('Selenium2Library')
    found_elements=seleniumlib.get_webelements(locator)
    found_elements[int(index)].click()
    return found_elements[int(index)]