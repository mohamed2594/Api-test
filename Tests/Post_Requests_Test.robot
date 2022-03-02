*** Settings ***

Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    FakerLibrary

Suite Setup    Create Session  clients_session  ${base_url}    verify=False    disable_warnings=1    
Suite Teardown    Delete All Sessions
*** Variables ***
${base_url}=    https://api-alias-preprod.itn.intraorange/validation/admin-private/v1
${endpoint}
# ${name}=    First Name


*** Test Cases ***
verify that user can create a client with valid body successfully
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${response}
    ${res.name}=    Get Value From Json    ${response.json()}    $.name
    Should Be Equal    ${res.name}[0]    ${name}        
    
verify that user can get with id the client which he created
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    ${res.id}=    Get Value From Json    ${response.json()}    $.id
    ${response}=    Get Request    clients_session        ${endpoint}/${res.id}[0] 
    Status Should Be    200    ${response}
    ${client-name}=    Get Value From Json    ${response.json()}    $.name
    Should Be Equal    ${client-name}[0]    ${name}    
    

verify that the created client is exist when get all clients
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    ${res.id}=    Get Value From Json    ${response.json()}    $.id
    ${response}=    Get Request    clients_session        ${endpoint} 
    Status Should Be    200    ${response}
    ${clients-ids}=    Get Value From Json    ${response.json()}    $..id
    Should Contain    ${clients-ids}    ${res.id}[0]    
    

verify that user can create a client without numbersSearchAllowed
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}     creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${response}
    ${res.name}=    Get Value From Json    ${response.json()}    $.name
    Should Be Equal    ${res.name}[0]    ${name}        
     
verify that user can create a client without creationDate
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${response}
    ${res.name}=    Get Value From Json    ${response.json()}    $.name
    Should Be Equal    ${res.name}[0]    ${name}        
    
verify that user cannot create a client with wrong numbersSearchAllowed format
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}    creationDate=null    numbersSearchAllowed=t
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    22    
    Should Be Equal    ${message}[0]    INVALID_BODY    

verify that user cannot create a client without name
    ${body}=    Create Dictionary    creationDate=null    numbersSearchAllowed=true
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    23    
    Should Be Equal    ${message}[0]    MISSING_BODY_FIELD  
    
verify that user cannot create a client with blank name
    ${body}=    Create Dictionary    name=    creationDate=null    numbersSearchAllowed=true
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    23    
    Should Be Equal    ${message}[0]    MISSING_BODY_FIELD  
    

verify that user cannot create a client without body
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    clients_session    ${endpoint}    headers=${headers}    
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    21    
    Should Be Equal    ${message}[0]    MISSING_BODY
    
verify that user cannot create a client with blank body
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    clients_session    ${endpoint}    data=${null}    headers=${headers}    
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    21    
    Should Be Equal    ${message}[0]    MISSING_BODY
       
verify that id is unique
    ${Get response}=    Get Request    clients_session        ${endpoint}
    Status Should Be    200    ${Get response}    
    ${All clients ids}=    Get Value From Json    ${Get response.json()}    $..id
    ${name}=    First Name        
    ${body}=    Create Dictionary    name=${name}    creationDate=null    numbersSearchAllowed=true
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${Post response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}
    Status Should Be    201    ${Post response}    
    ${client id}=    Get Value From Json    ${Post response.json()}    $.id
    Should Not Contain    ${All clients ids}    ${client id}    
    
verify that user cannot create a client with an existing name 
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${response}
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}
    Status Should Be    409    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    1111    
    Should Be Equal    ${message}[0]    NAME_ALREADY_EXISTS

verify that user cannot create a client with name length more than 50 characters
    ${invalid-name}=    Set Variable    asdfghjklaasdfghjklaasdfghjklaasdfghjklaasdfghjklaq
    ${body}=    Create Dictionary    name=${invalid-name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    ${endpoint}    data=${body}    headers=${headers}
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    24    
    Should Be Equal    ${message}[0]    INVALID_BODY_FIELD