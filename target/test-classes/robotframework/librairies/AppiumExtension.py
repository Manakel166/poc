from robot.libraries.BuiltIn import BuiltIn

def find_elements(locator,first_only=True,required=True):
    appiumlib = BuiltIn().get_library_instance('AppiumLibrary')
    return appiumlib.get_elements(locator,first_only,required)
    
    
def get_attribute_of_the_nth_element(locator,attribute,index):
        """Get element attribute of the nth element using given attribute: name, value,...
        Index starts at 1
        Examples:
        | Get Element Attribute | locator | name | 1
        | Get Element Attribute | locator | value | 2
        """
        appiumlib = BuiltIn().get_library_instance('AppiumLibrary')
        elements = appiumlib._element_find(locator, False, True)
        ele_len = len(elements)
        if ele_len == 0:
            raise AssertionError("Element '%s' could not be found" % locator)
        try:
            attr_val = elements[index-1].get_attribute(attribute)
            appiumlib._info("Element n='%s' '%s' attribute '%s' value '%s' " % (index,locator, attribute, attr_val))
            return attr_val
        except:
            raise AssertionError("Attribute '%s' is not valid for element '%s'" % (attribute, locator))
    
    
def count_elements(locator,first_only=False,required=False):
    appiumlib = BuiltIn().get_library_instance('AppiumLibrary')
    found_elements=appiumlib.get_elements(locator,first_only,required)
    return len(found_elements)

    