*** Settings ***

Library    Process
Library    SeleniumLibrary
Library  RequestsLibrary
Suite Setup    Setup Http Server
Suite Teardown    Suite teardown Http Server

*** Variables ***

${HOMEPAGE}=    http://127.0.0.1:81
${BROWSER}=    Chrome

*** Keywords ***

Setup Http Server
    Start Process    python    functional.py
    sleep    15s

Suite teardown Http Server
    Terminate All Processes

Open the browser
    Open Browser    ${HOMEPAGE}    ${BROWSER}

Check Status Code
    [Arguments]  ${response}
    should be equal as strings  ${response.status_code}  200

Check Error Code
    [Arguments]  ${response}
    should be equal as strings  ${response.status_code}  404

Get Session Page Ok Status
    [Arguments]    ${page_name}    ${page_id}
    create session  get_star_wars  ${HOMEPAGE}  verify=True
    ${response} =  GET On Session  get_star_wars  api/${page_name}/${page_id}/
    Check Status Code  ${response}
    [return]    ${response}

Get Session Page NOk Status
    [Arguments]    ${page_name}    ${page_id}
    create session  get_star_wars  ${HOMEPAGE}  verify=True
    ${response} =  GET On Session  get_star_wars  api/${page_name}/${page_id}/    expected_status=404
    Check Error Code  ${response}
    [return]    ${response}

Get Session page
    [Arguments]    ${pageIds_OK_test}    ${pageIds_NOK_test}    ${page}
     FOR  ${id}  IN   @{pageIds_OK_test}
         ${response}=    Get Session Page Ok Status    ${page}    ${id}
         Log to console  ${response.json()}
     END
     sleep    2s
     FOR  ${id}  IN   @{pageIds_NOK_test}
         ${response}=    Get Session Page NOk Status    ${page}    ${id}
         Log to console  ${response.json()}
     END
     sleep    2s

*** Test Cases ***

Open the browser Test
    Open the browser
    sleep    2s

Get Session People page
    ${page}=    Set Variable    people
    ${pageIds_OK_test}=    Create List    1  47  100
    ${pageIds_NOK_test}=    Create List    0  101
    Get Session page    ${pageIds_OK_test}    ${pageIds_NOK_test}    ${page}

Get Session Planets page
    ${page}=    Set Variable    planets
    ${pageIds_OK_test}=    Create List    1  63  100
    ${pageIds_NOK_test}=    Create List    0  101
    Get Session page    ${pageIds_OK_test}    ${pageIds_NOK_test}    ${page}

Get Session Starships page
    ${page}=    Set Variable    starships
    ${pageIds_OK_test}=    Create List    1  32  100
    ${pageIds_NOK_test}=    Create List    0  101
    Get Session page    ${pageIds_OK_test}    ${pageIds_NOK_test}    ${page}
