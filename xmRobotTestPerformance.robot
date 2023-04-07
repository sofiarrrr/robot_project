*** Settings ***

Library    Process
Library    SeleniumLibrary
Library    RequestsLibrary
Library    Collections
Library    DateTime
#Suite Setup    Setup Http Server
#Suite Teardown    Suite teardown Http Server

*** Variables ***

${HOMEPAGE}=    http://127.0.0.1:81
${BROWSER}=    headlesschrome
@{RESPONSE_TIME_LIST}

*** Keywords ***

#Setup Http Server
#    Start Process    python    functional.py
#    sleep    10s

#Suite teardown Http Server
#    Terminate All Processes

Open the browser
    Open Browser    ${HOMEPAGE}    ${BROWSER}

Check Status Code
    [Arguments]  ${response}
    should be equal as strings  ${response.status_code}  200

Check Error Code
    [Arguments]  ${response}
    should be equal as strings  ${response.status_code}  404

Distance from Mean
    [Arguments]    ${RESPONSE_TIME_LIST}
    [Timeout]    1 minute
    ${mysum}=    Set Variable    0
    ${mysub}=    Set Variable    0
    #Find the mean
    @{distance_mean_LIST}=    Create List
    FOR    ${i}    IN RANGE    ${iterations}
        ${timedelta}=    Convert Time    ${RESPONSE_TIME_LIST}[${i}]    timedelta
        ${var}=    Set Variable    ${timedelta.total_seconds()}
        ${mysum}=    Evaluate   ${mysum} + ${var}
    END
    ${mean_value}=    Evaluate  ${mysum}/${iterations}
    #Find the distace from mean
    FOR    ${i}    IN RANGE    ${iterations}
        ${timedelta}=    Convert Time    ${RESPONSE_TIME_LIST}[${i}]    timedelta
        ${var}=    Set Variable    ${timedelta.total_seconds()}
        ${mysub}=    Evaluate    ${var} - ${mean_value}
        Append To List  ${distance_mean_LIST}    ${mysub}
    END
    [return]    ${distance_mean_LIST}

Mean Deviation Time
    [Arguments]    ${RESPONSE_TIME_LIST}
    ${mysum}=    Set Variable    0
    ${distance_mean_LIST}=    Distance from Mean    ${RESPONSE_TIME_LIST}
    FOR    ${i}    IN RANGE    ${iterations}
        ${mysum}=    Evaluate   ${mysum} + ${distance_mean_LIST}[${i}]
    END
    ${MEAN_DEVIATION_TIME}=    Evaluate    ${mysum}/${iterations}
    Log    ${MEAN_DEVIATION_TIME}

Standard Deviation Time
    [Arguments]    ${RESPONSE_TIME_LIST}
    ${mysum}=    Set Variable    0
    ${distance_mean_LIST}=    Distance from Mean    ${RESPONSE_TIME_LIST}
    FOR    ${i}    IN RANGE    ${iterations}
        ${mysubSQ}=    Evaluate    ${distance_mean_LIST}[${i}]**2
        ${mysum}=    Evaluate   ${mysum} + ${mysubSQ}
    END
    ${MEAN_SQ_VAL}=    Evaluate    ${mysum}/${iterations}
    ${STANDARD_DEVIATION_TIME}=    Evaluate    ${MEAN_SQ_VAL}**0.5
    Log    ${STANDARD_DEVIATION_TIME}

*** Test Cases ***

Start Http Server
    Start Process    python    functional.py
    sleep    10s

Open the Browser test
    Open the browser
    sleep    2s

Performance test
    [Timeout]    2 minutes
    create session  get_star_wars  ${HOMEPAGE}  verify=True
    ${iterations}=    Set Variable    175
    Set Global Variable    ${iterations}
    FOR    ${i}    IN RANGE    ${iterations}
         ${response}=  GET On Session  get_star_wars  api/planets/3/
         ${time}=  Set Variable    ${response.elapsed}
         Append To List  ${RESPONSE_TIME_LIST}    ${time}
         Log    ${response}
         Log    ${RESPONSE_TIME_LIST}
    END
    Set Global Variable    ${RESPONSE_TIME_LIST}
    Check Status Code  ${response}

Stop Http Server
    Terminate All Processes

Find Deviation Time Values
    Mean Deviation Time    ${RESPONSE_TIME_LIST}
    Standard Deviation Time    ${RESPONSE_TIME_LIST}
