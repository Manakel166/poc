def xpath_by_id(id):
    xpath_template="not_defined"
    if ":id/" in id:
        xpath_template="//*[@resource-id='ID']"
    else:
        xpath_template="//*[ends-with(@resource-id,'ID']"
    new_xpath=xpath_template.replace("ID",id)
    return new_xpath

    
    
