*** Settings ***
Library           ExtendedSelenium2Library
Library           ../../30_LIBRAIRIES/ExtendedSelenium2Extension.py
Library           Collections
Library           String
Resource          crome.pages.txt
Resource          ../../30_LIBRAIRIES/web_table_helpers.txt

*** Variables ***
${url_rct_chrome}    https://habilerct.airfrance.fr/siteminderagent/habile.fcc?TYPE=33554433&REALMOID=06-46a18ee6-8edb-1036-92c1-847505340cb3&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=agttech_default_apache_hab-tomcat8_qvirnweblx03&TARGET=-SM-http%3a%2f%2fsurcoufj--mig--rct%2eairfrance%2efr%2fcromeFront%2f#
${grid_server}    http://10.70.147.63:4441/wd/hub

*** Test Cases ***
S1 - User Story My Contracts/Firm List Display
    Open Crome with Test user on Browser:    IE
    I have the 6 required Columns displayed
    I can click on Master Ref or Corporate Name to access the Contract Card
    I have Sort Options on all Columns but Corporate Environment
    I can click on Corporate Environment link to access the existing Coporate Environment
    I can click on Create Corporate Environment button when it does not exist
    I can sort the Contracts by Contract Ref
    [Teardown]    Close Browser

Let's check Pernod
    Open Crome with Test user on Browser:    Chrome
    On<CromeHome>, Choose MonContract/Firm
    On<CromeContracts>, Click a Company Name:    PERNOD RICARD
    On <CromeContractCard>, Displayed Contract should be:    PERNOD    I WANT A LOT OF BOTTLES    SURE I DO!

*** Keywords ***
I can click on Master Ref or Corporate Name to access the Contract Card
    [Tags]    Acceptance1
    Comment    On<CromeHome>, Choose MonContract/Firm
    On<CromeContracts>, Click a Contract MasterRef:    FR01006
    On <CromeContractCard>, Displayed Contract should be:    FR01006    BlueBiz    Validé
    Capture Page Screenshot
    From <CromeContractCard>, Navigate to <CromeContracts>
    On<CromeContracts>, Click a Company Name:    SUNCOM
    On <CromeContractCard>, Displayed Contract should be:    FR01006    BlueBiz    Validé
    Capture Page Screenshot
    From <CromeContractCard>, Navigate to <CromeContracts>

I can click on Corporate Environment link to access the existing Coporate Environment
    [Tags]    Acceptance3
    On <CromeContracts>, Click a Corporate Environment Link:    SUNCOM
    I'm on <CromeCorporateEnvironment>
    On <CromeCorporateEnvironment>, Displayed Environment should be    env_name=SUNCOM    env_contract_ref=FR01006    env_company_name=SUNCOM
    Capture Page Screenshot
    From <CromeCorporateEnvironment>, Navigate to <CromeContracts>

I can click on Create Corporate Environment button when it does not exist
    [Tags]    Acceptance3
    I'm on <CromeContracts>
    On <CromeContracts>, Click to Create an Environment for Contract:    ACTIA
    I'm on <CromeCreateCorporateEnvironment>
    Capture Page Screenshot
    From <CromeCreateCorporateEnvironment>, Navigate to <CromeContracts>

I can sort the Contracts by Contract Ref
    [Tags]    Acceptance4
    Capture Page Screenshot
    On <CromeContracts>, Sort by Ascending:    Contract reference
    ${final_ACTIA_position}=    Get Row from Column Value:    xpath=//md-card//table    Contract reference    ACTIA    //th//span[@class='header-label']
    ${final_FR010106_position}=    Get Row from Column Value:    xpath=//md-card//table    Contract reference    FR01006    //th//span[@class='header-label']
    Should Be True    ${final_ACTIA_position}<${final_FR010106_position}
    Capture Page Screenshot

I have Sort Options on all Columns but Corporate Environment
    [Tags]    Acceptance2
    I'm on <CromeContracts>
    On <CromeContracts>, Check that SortOptions is available for Column:    Company
    On <CromeContracts>, Check that SortOptions is available for Column:    Contract reference
    On <CromeContracts>, Check that SortOptions is available for Column:    Contract type
    On <CromeContracts>, Check that SortOptions is available for Column:    Valide à partir du
    On <CromeContracts>, Check that SortOptions is available for Column:    Valide jusqu
    On <CromeContracts>, Check that SortOptions is NOT AVAILABLE for Column:    Corporate environnement
    Capture Page Screenshot

I have the 6 required Columns displayed
    On<CromeHome>, Choose MonContract/Firm
    On <CromeContracts>, Check that Column is displayed:    Contract reference
    On <CromeContracts>, Check that Column is displayed:    Company
    On <CromeContracts>, Check that Column is displayed:    Contract type
    On <CromeContracts>, Check that Column is displayed:    Valide à partir du
    On <CromeContracts>, Check that Column is displayed:    Valide jusqu
    On <CromeContracts>, Check that Column is displayed:    Corporate environment
