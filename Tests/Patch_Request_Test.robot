*** Settings ***

Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    FakerLibrary

Suite Setup    Create Session  clients_session  ${base_url}    verify=False    disable_warnings=1    
Suite Teardown    Delete All Sessions

*** Variables ***
${base_url}=    https://api-alias-preprod.itn.intraorange/validation/admin-private/v1
${endpoint}=    clients

*** Test Cases ***
verify that user can update data for any client
    ${name}=    First Name
    ${random_Boolean}=    Boolean    
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${Post_response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${Post_response}
    ${id}=    Set Variable    ${Post_response.json()["id"]}
    ${name}=    Last Name
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=${random_Boolean}
    ${Patch_response}=    Patch Request    clients_session    ${endpoint}/${id}    data=${body}    headers=${headers}
    Status Should Be    201    ${Patch_response}
    ${res.name}=    Get Value From Json    ${Patch_response.json()}    $.name
    Should Be Equal    ${res.name}[0]    ${name}
    ${res.numberSearchAllowed}=    Get Value From Json    ${Patch_response.json()}    $.numbersSearchAllowed
    Should Be Equal As Strings    ${res.numberSearchAllowed}[0]    ${random_Boolean}
    ${patch_res_id}=    Set Variable    ${Patch_response.json()["id"]}
    Should Be Equal    ${patch_res_id}    ${id}        
    

verify that user can update name only for any client
    ${name}=    First Name    
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${Post_response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${Post_response}
    ${id}=    Set Variable    ${Post_response.json()["id"]}
    ${name}=    Last Name
    ${body}=    Create Dictionary    name=${name}
    ${Patch_response}=    Patch Request    clients_session    ${endpoint}/${id}    data=${body}    headers=${headers}
    Status Should Be    201    ${Patch_response}
    ${res.name}=    Get Value From Json    ${Patch_response.json()}    $.name
    Should Be Equal    ${res.name}[0]    ${name}
    ${res.numberSearchAllowed}=    Get Value From Json    ${Patch_response.json()}    $.numbersSearchAllowed
    Should Be Equal As Strings    ${res.numberSearchAllowed}[0]    True
    ${patch_res_id}=    Set Variable    ${Patch_response.json()["id"]}
    Should Be Equal    ${patch_res_id}    ${id}   
    

verify that user can update numbersSearchAllowed only for any client
    ${name}=    First Name
    ${random_Boolean}=    Boolean    
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${Post_response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${Post_response}
    ${id}=    Set Variable    ${Post_response.json()["id"]}
    ${body}=    Create Dictionary    numbersSearchAllowed=${random_Boolean}
    ${Patch_response}=    Patch Request    clients_session    ${endpoint}/${id}    data=${body}    headers=${headers}
    Status Should Be    201    ${Patch_response}
    ${res.name}=    Get Value From Json    ${Patch_response.json()}    $.name
    Should Be Equal    ${res.name}[0]    ${name}
    ${res.numberSearchAllowed}=    Get Value From Json    ${Patch_response.json()}    $.numbersSearchAllowed
    Should Be Equal As Strings    ${res.numberSearchAllowed}[0]    ${random_Boolean}
    ${patch_res_id}=    Set Variable    ${Patch_response.json()["id"]}
    Should Be Equal    ${patch_res_id}    ${id}   
    

verify that user cannot update the id for any client
    ${name}=    First Name
    ${fake_id}=    id    
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${Post_response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${Post_response}
    ${id}=    Set Variable    ${Post_response.json()["id"]}
    ${name}=    Last Name
    ${body}=    Create Dictionary    id=074347b5-67a4-4190-a560-c66c0cdb0fa4    name=${name}
    ${Patch_response}=    Patch Request    clients_session    ${endpoint}/${id}    data=${body}    headers=${headers}
    Status Should Be    201    ${Patch_response}
    ${res.id}=    Get Value From Json    ${Patch_response.json()}    $.id
    Should Be Equal    ${res.id}[0]    ${id}
    Should Not Be Equal    ${res.id}    ${body}["id"]        
    

verify that user cannot update the creationdate for any client
    

verify that user cannot update a non exist client
    

verify that user cannot update the name with an exist name
    

verify that user cannot update the data without body
    

verify that user cannot update data by name
    

