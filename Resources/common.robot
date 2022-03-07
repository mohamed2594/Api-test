*** Settings ***

Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    FakerLibrary
Library    JSONSchemaLibrary    schemas

# Suite Setup    Create Session  clients_session  ${base_url}    verify=False    disable_warnings=1     
# Suite Teardown    Delete All Sessions
*** Variables ***
${base_url}=    https://api-alias-preprod.itn.intraorange/validation/admin-private/v1
# ${endpoint}=    /clients

*** Keywords ***
Get clients
    [Arguments]    ${session_name}    ${endpoint}    
    ${response}=    Get Request    ${session_name}        ${endpoint}    
    [Return]    ${response}
    
Get one client
    [Arguments]    ${session_name}    ${endpoint}    ${id}    
    ${response}=    Get Request    ${session_name}        ${endpoint}/${id}
    [Return]    ${response}
    
Get number of clients
    [Arguments]    ${session_name}    ${endpoint}    ${number_of_clients}
    ${params}    Create Dictionary    limit=${number_of_clients}    
    ${response}=    Get Request    ${session_name}        ${endpoint}    params=${params}
    [Return]    ${response}
    
Create a client
    [Arguments]    ${session_name}    ${endpoint} 
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    ${session_name}    ${endpoint}    data=${body}    headers=${headers}
    [Return]    ${response}
    
Assert Status_Code
    [Arguments]    ${expected}    ${actual}    
    Status Should Be    ${expected}    ${actual}
    Log    ${actual}
    
Assert Schema
    [Arguments]    ${expected_Schema}    ${actual_Schema}         
    Validate Json    ${expected_Schema}    ${actual_Schema}
    
Assert Error Schema
    [Arguments]    ${actual_Schema}    ${expected_code}    ${expected_message}    ${actual_code}    ${actual_message}         
    Validate Json    ${actual_Schema}    
    
Assert Results Number
    [Arguments]    ${expected_number}    ${actual_JsonResponse}    ${response_headers}  
    ${result_length}=    Get From Dictionary    ${response_headers}    x-result-count
    Should Be Equal As Integers    ${result_length}    ${expected_number}        
    ${values}=    Get Value From Json    ${actual_JsonResponse}    $..id
    ${length}=    Get Length    ${values}
    Should Be Equal As Integers    ${length}    ${expected_number}
    