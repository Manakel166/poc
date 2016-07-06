*** Settings ***
Library           AppiumLibrary
Resource          af.ui.txt    # UI Identifier. may change from Platform to Platform
Resource          ../../resources/robotframework/librairies/rf_helpers.txt
Resource          klm.ui.txt
Resource          af.pages.txt
Library           ../../resources/robotframework/librairies/string_helpers.py
Library           DateTime
Library           ../../resources/robotframework/librairies/xpath_helpers.py
Library           ../../resources/robotframework/librairies/AppiumExtension.py

*** Variables ***
&{app_AF}         app=../../../../20_AUT/air_france_1.7.2_72.apk    # A dictionnary to provide the parameters of the App under Tests (like path to the apk....)
&{app_KLM}        app=../../../../20_AUT/KLM_com.afklm.mobile.android.gomobile.klm_7.4.1_12744.apk
${RunFrom}        RIDE
&{LG_G4}          platformName=ANDROID    platformVersion=5.1    deviceName=LG_G4    udid=LGH815e4eec017    platform=ANDROID
${devnet_grid_server}    http://172.21.42.155:4444/wd/hub
${dinb_demo_server}    http://10.70.148.60:4441/wd/hub

*** Test Cases ***
Access to Flight News(AF)
    [Tags]    AF
    GIVEN I am on AirFrance HomePage
    THEN I can select "Flight News" from HomePage
    [Teardown]    Close Application

TC050 - Verify that the user is able to see the default values in the search module
    [Tags]    KLM    Smoke
    Given I've started the KLM App
    When I Book A Trip
    Then the Default Search Origin is "Amsterdam"
    And the Default Search Type is "Return flight"
    And the Default Search Passenger is "1 adult in Economy Class"
    [Teardown]    Close Application

TC0XX - Verify whether the user is able to book a one way flight without login.
    [Tags]    KLM    Smoke    unfinished
    ${Search_Destination(TextView)_id}    xpath_by_id    search_destination
    Given I've started the KLM App
    And I'm not Logged In
    And I Book a Trip
    When I choose as Origin "Paris"
    And I did not choose a Destination
    Then I Cannot Search for Dates
    When I choose as Destination "Rome"
    And I choose a one way flight
    And I keep default Passenger Type
    Then I Can Search for Dates
    And I Can Choose Today as Date
    And I Can Book the First available Flight
    [Teardown]    Close Application

TC051 - Verify the message shown, when there are no entries for the given Origin and destination
    [Tags]    KLM    Smoke
    Given I've started the KLM App
    When I Book A Trip
    And I choose as Origin "Paris"
    And I choose as Destination "Oulu"
    And I choose a one way flight
    Then I see a message for No Destination
    [Teardown]    Close Application

TC058 - Verify the user able to see the lowest price according to the destination selected, when not logged in
    [Tags]    KLM
    Given I've started the KLM App
    And I'm not Logged In
    And I Book a Trip
    When I choose as Origin "Paris"
    And I choose as Destination "Rome"
    And I choose a one way flight
    And I keep default Passenger Type
    Then I can see the lowest price for my destination
    When I ask the flights available for Today
    Then All proposed flight must be pricier
    [Teardown]    Close Application

*** Keywords ***
-----------------------Business Steps AF --------------------------------

-----------------------Business Steps KLM --------------------------------

-----------------------Functional Steps/ Reusable Blocks AF cf resource----------

-----------------------Functional Steps/ Reusable Blocks KLM----------

All proposed flight must be pricier
    On <Choose a Flight> Page, Check all flights are between the 2 airports:    CDG    FCO
    On <Choose a Flight> Page, Check all flights are pricier than:    ${proposed_lowest_price}

I Book A Trip
    On <KLM HomePage>, Request to Book a Trip via Central Button

I Can Book the First available Flight
    On <Choose a Flight> Page, Check all flights are between the 2 airports:    CDG    FCO
    On <Choose a Flight> Page, Choose the first flight
    On <Choose a Flight> Page, Confirm the Selected Flight
    On <Complete Booking> Page, Confirm the Payment
    On <Pay Page>, No Error Message shall be displayed
    Get Contexts

I Can Choose Today as Date
    On <select departure date> Page, Choose Today
    On <Confirm departure date> Page, Confirm Date

I Can Search for Dates
    On <Book a trip> Page, Request Date Search

I Cannot Search for Dates
    On <Book a Trip> Page, Check that "Select travel date" is disabled

I am on AirFrance HomePage
    Open the Airfrance App
    At Launch, Refuse to Update the App
    At Launch, Skip the login Step
    At Launch, Confirm the UK Language
    Check that I’m on the AirFrance HomePage

I ask the flights available for Today
    On <Book a Trip> Page, Request Date Search
    On <select departure date> Page, Choose Today
    On <Confirm departure date> Page, Confirm Date

I can see the lowest price for my destination
    ${displayed_price}=    On <Book a trip> Page, Get the Proposed lowest price
    Set Test Variable    ${proposed_lowest_price}    ${displayed_price}
    Log    Price proposed on Book a Trip Page is : ${displayed_price}

I can select "Flight News" from HomePage
    On Homepage, Select “Flight news”
    Check that I’m on the “Flight news” Page

I choose a one way flight
    On <Book a trip> Page, Choose One-way flight
    On <Book a trip> Page, Check Search Type is:    One-way flight

I choose as Destination "Oulu"
    On <Book a Trip> Page, Request to Select Destination
    On <Destination> Page, Select Destination:    Oulu    Oulu, Finland
    On <Book a trip> Page, Check Destination is    Oulu

I choose as Destination "Rome"
    On <Book a Trip> Page, Request to Select Destination
    On <Destination> Page, Select Destination:    Rome    Fiumicino Airport, Italy
    On <Book a trip> Page, Check Destination is    Rome

I choose as Origin "Paris"
    On <Book a Trip> Page, Request to Select Origin
    On <From> Page, Select Origin:    Paris    Charles De Gaulle Airport, France

I did not choose a Destination
    On <Book a trip> Page, Check Destination is    Destination

I keep default Passenger Type
    On <Book a trip> Page, Check Search Passenger is:    1 adult in Economy Class

I see a message for No Destination
    On <Book a Trip> Page, Request Date Search
    On <select departure date> Page, Choose Today
    On <Confirm departure date> Page, Confirm Date
    On <Choose a Flight>, Check that the No Flight Found Message is displayed

I'm not Logged In
    Log    Not Implemented Yet

I'm on <Book a trip> Page
    Wait Until Page Contains Element    ${Title Book a trip(TextView)}    5s    Not on <Book Trip> Page
    Capture Page Screenshot

I'm on <Choose a Flight> Page
    Wait Until Page Contains Element    ${Title Select departure flight(TextView)}    5s    Not on Choose a Flight Page
    Capture Page Screenshot

I'm on <Complete Booking> Page
    Wait Until Page Contains Element    ${Title Complete Booking(TextView)}    5s    Not on Complete Booking Page
    Capture Page Screenshot

I'm on <Confirm departure date> Page
    Wait Until Page Contains Element    ${Title Confirm Departure Date(TextView)}    5s    Not on Confirm Departure Date Page
    Capture Page Screenshot

I'm on <Country of Residence> Page
    Wait Until Page Contains Element    ${Title Country of residence(TextView)}    15s
    Capture Page Screenshot

I'm on <Destination> Page
    Wait Until Page Contains Element    ${Title Destination(TextView)}

I'm on <From> Page
    Wait Until Page Contains Element    ${Title From(TextView)}

I'm on <KLM HomePage>
    Wait Until Page Contains Element    ${Welcome, your journey starts here.(TextView)_id}    30s    Not on <KLM HomePage>
    Capture Page Screenshot

I'm on <Pay Page>
    Wait Until Page Contains Element    ${Title Pay(TextView)}

I'm on <select departure date> Page
    Wait Until Page Contains Element    ${Title Select Departure Date(TextView)}    5s    Not on Select Departure Date Page
    Capture Page ScreenShot

I've started the KLM App
    Comment    Launch Application on Local Device    &{app_KLM}
    Log    ${RunFrom}
    Open Application    ${dinb_demo_server}    &{LG_G4}    &{app_KLM}
    On <Country of Residence> Page, Select :    France
    I'm on <KLM HomePage>

On <Book a Trip> Page, Check that "Select travel date" is disabled
    I'm on <Book a trip> Page
    Page Should Contain Element    ${Select travel dates(TextView)_id}
    Element Attribute Should Match    ${Select travel dates(TextView)_id}    enabled    false

On <Book a Trip> Page, Request Date Search
    I'm on <Book a trip> Page
    Page Should Contain Element    ${Select travel dates(TextView)_id}
    Element Attribute Should Match    ${Select travel dates(TextView)_id}    enabled    true
    Click Element    ${Select travel dates(TextView)_id}

On <Book a Trip> Page, Request to Select Destination
    I'm on <Book a trip> Page
    Click Element    ${Search_Destination(TextView)_id}

On <Book a Trip> Page, Request to Select Origin
    I'm on <Book a trip> Page
    Click Element    ${Search_Origin(TextView)_id}

On <Book a trip> Page, Check Destination is
    [Arguments]    ${arg1}
    I'm on <Book a trip> Page
    Page Should contain Element    ${Search_Destination(TextView)_id}    Search Destination is not Found!
    Element Attribute Should Match    ${Search_Destination(TextView)_id}    text    ${arg1}
    Capture Page ScreenShot

On <Book a trip> Page, Check Origin is:
    [Arguments]    ${arg1}
    I'm on <Book a trip> Page
    Page Should contain Element    ${Search_Origin(TextView)_id}    Search Origin is not Found!
    Element Attribute Should Match    ${Search_Origin(TextView)_id}    text    ${arg1}
    Capture Page ScreenShot

On <Book a trip> Page, Check Search Passenger is:
    [Arguments]    ${arg1}
    I'm on <Book a trip> Page
    Page Should contain Element    ${Search_Passenger(TextView)_id}    Search Passenger is not Found!
    Element Attribute Should Match    ${Search_Passenger(TextView)_id}    text    ${arg1}
    Capture Page ScreenShot

On <Book a trip> Page, Check Search Type is:
    [Arguments]    ${arg1}
    I'm on <Book a trip> Page
    Page Should contain Element    ${Search_Type(TextView)_id}    Search Type
    Element Attribute Should Match    ${Search_Type(TextView)_id}    text    ${arg1}
    Capture Page ScreenShot

On <Book a trip> Page, Choose One-way flight
    I'm on <Book a trip> Page
    ${is_one_way_flight}=    Run Keyword And Return Status    On <Book a trip> Page, Check Search Type is:    One-way flight
    Capture Page ScreenShot
    Run Keyword If    '${is_one_way_flight}'=='${False}'    Click Element    ${Search_Type(TextView)_id}

On <Book a trip> Page, Get the Proposed lowest price
    I'm on <Book a trip> Page
    Page Should Contain Element    ${Lowest_Price_on_Book_a_Trip_id}
    ${found_price}=    Get Element Attribute    ${Lowest_Price_on_Book_a_Trip_id}    text
    [Return]    ${found_price}

On <Choose a Flight> Page, Check all flights are between the 2 airports:
    [Arguments]    ${from_airport_code}    ${to_airport_code}
    I'm on <Choose a Flight> Page
    ${all_flight_count}=    Count Elements    ${Flight_locator}
    ${from_locator}=    Replace String    ${Origin_CDG_locator}    CDG    ${from_airport_code}
    ${from_count}=    Count Elements    ${from_locator}
    ${to_locator}=    Replace String    ${Destination_FCO_locator}    FCO    ${to_airport_code}
    ${to_count}=    Count Elements    ${to_locator}
    ${visible_flight_count}=    Count Elements    ${Flight_transfert_locator}
    Should Be Equal As Integers    ${from_count}    ${visible_flight_count}    All Visible Flights are not starting from Expected Airport ${from_airport_code}
    Should Be Equal As Integers    ${to_count}    ${visible_flight_count}    All Visible Flights are not going to \ Expected Airport ${to_airport_code}

On <Choose a Flight> Page, Check all flights are pricier than:
    [Arguments]    ${lowest_price}
    I'm on <Choose a Flight> Page
    ${visible_flight_count}=    Count Elements    ${Flight_transfert_locator}
    Log    Checking Prices of ${visible_flight_count} flights visible on the first page
    : FOR    ${index}    IN RANGE    1    ${visible_flight_count}+1
    \    Log    ${index}
    \    ${flight_price}=    Get Attribute Of The Nth Element    ${flight_price_locator}    text    ${index}

On <Choose a Flight> Page, Choose the first flight
    I'm on <Choose a Flight> Page
    Click Element    ${Flight_locator}

On <Choose a Flight> Page, Confirm the Selected Flight
    I'm on <Choose a Flight> Page
    Click Element    ${Confirm_Flight(TextView)}

On <Choose a Flight>, Check that the No Flight Found Message is displayed
    I'm on <Choose a Flight> Page
    Page Should Contain Element    ${Msg_NoAvailableFlight_id}
    Element Attribute Should Match    ${Msg_NoAvailableFlight_id}    text    Unfortunately no available flight(s) were found. Please select a different date or destination.

On <Complete Booking> Page, Confirm the Payment
    I'm on <Complete Booking> Page
    Click Element    ${Complete_Payment(TextView)}

On <Confirm departure date> Page, Confirm Date
    I'm on <Confirm departure date> Page
    Click Element    ${Confirm Departure Date(TextView)_id}

On <Country of Residence> Page, Select :
    [Arguments]    ${arg1}
    I'm on <Country of Residence> Page
    Input Text    ${Country of Residence(EditText)_id}    ${arg1}
    Wait Until Page Contains Element    ${France(TextView)}    3s
    Capture Page Screenshot
    Click Element    ${France(TextView)}

On <Destination> Page, Select Destination:
    [Arguments]    ${City}    ${Airport}
    I'm on <Destination> Page
    Input Text    ${City_Destination(EditText)_id}    ${City}
    Set Test Variable    ${AirportForCity}    xpath=//android.widget.TextView[@text='${Airport}'][@resource-id='com.afklm.mobile.android.gomobile.klm:id/second_line_text']
    Page Should Contain Element    ${AirportForCity}
    Capture Page ScreenShot
    Click Element    ${AirportForCity}

On <From> Page, Select Origin:
    [Arguments]    ${City}    ${Airport}
    I'm on <From> Page
    Input Text    ${City_Origin(EditText)_id}    ${City}
    Set Test Variable    ${AirportForCity}    xpath=//android.widget.TextView[@text='${Airport}'][@resource-id='com.afklm.mobile.android.gomobile.klm:id/second_line_text']
    Page Should Contain Element    ${AirportForCity}
    Capture Page ScreenShot
    Click Element    ${AirportForCity}

On <KLM HomePage>, Request to Book a Trip via Central Button
    I'm on <KLM HomePage>
    Click Element    ${Book a trip(LinearLayout)_id}

On <Pay Page>, Error Message Shall be Displayed
    I'm on <Pay Page>
    Wait Until Page Contains Element    ${Error_something_went_wrong(View)}    10s
    Capture Page Screenshot

On <Pay Page>, No Error Message shall be displayed
    I'm on <Pay Page>
    Run Keyword And Expect Error    *    On <Pay Page>, Error Message Shall be Displayed

On <select departure date> Page, Choose Today
    I'm on <select departure date> Page
    ${today} =    Get Current Date
    Comment    Day is displayed as number (eg 26)
    ${current_day_of_month}=    Convert Date    ${today}    result_format=%d
    ${current_day_of_month}=    Strip String    ${current_day_of_month}    mode=left    characters=0
    ${locator_for_Day}=    Replace String    ${Departure_day(TextView)}    Day    ${current_day_of_month}
    Page Should Contain Element    ${locator_for_Day}
    Comment    Month is Displayed as a Local Full Month (eg June)
    ${current_month_as_local_abrevation}=    Convert Date    ${today}    result_format=%B
    Page Should Contain Element    ${Departure_month(TextView)_id}
    Element Attribute Should Match    ${Departure_month(TextView)_id}    text    ${current_month_as_local_abrevation}
    Click Element    ${locator_for_Day}

the Default Search Origin is "Amsterdam"
    On <Book a trip> Page, Check Origin is:    Amsterdam

the Default Search Passenger is "1 adult in Economy Class"
    On <Book a trip> Page, Check Search Passenger is:    1 adult in Economy Class

the Default Search Type is "Return flight"
    On <Book a trip> Page, Check Search Type is:    Return flight
