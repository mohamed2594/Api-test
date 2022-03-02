*** Settings ***

Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    FakerLibrary
Suite Setup    Create Session  clients_session  ${base_url}    verify=False    disable_warnings=1     
Suite Teardown    Delete All Sessions
*** Variables ***
${base_url}=    https://api-alias-preprod.itn.intraorange/validation/admin-private/v1
${endpoint}=    /clients

*** Keywords ***
Get all
    ${response}=    Get Request    clients_session        ${endpoint}    


*** Test Cases ***
verify that user can get all clients
    ${response}=    Get Request    clients_session        ${endpoint}        
    Status Should Be    200    ${response}
        
verify that user can get a specific client with his id
    ${name}=    First Name
    ${body}=    Create Dictionary    name=${name}    numbersSearchAllowed=true    creationDate=null
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    clients_session    /clients    data=${body}    headers=${headers}    
    ${res.id}=    Get Value From Json    ${response.json()}    $.id
    ${response}=    Get Request    clients_session        ${endpoint}/${res.id}[0] 
    Status Should Be    200    ${response}
    ${client-name}=    Get Value From Json    ${response.json()}    $.name
    Should Be Equal    ${client-name}[0]    ${name}    
 
   
verify that user can get a specific 100 client by default
    ${response}=    Get Request    clients_session        ${endpoint}    
    Status Should Be    200    ${response}   
    ${values}=    Get Value From Json    ${response.json()}    $..id
    ${length}=    Get Length    ${values}
    Should Be Equal As Integers    ${length}    100    
       
verify that user can get less than 100 clients
    ${params}    Create Dictionary    limit=20
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    Status Should Be    200    ${response}    
    ${values}=    Get Value From Json    ${response.json()}    $..id
    ${length}=    Get Length    ${values}
    Should Be Equal As Integers    ${length}    20

verify that user cannot get more than 100 client
    ${params}    Create Dictionary    limit=120
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    28
    Should Be Equal    ${message}[0]    INVALID_QUERY_PARAM_VALUE    
  
verify that user can make offset for the geted clients
    ${params}    Create Dictionary    offset=5000
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    Status Should Be    200    ${response}        

verify that user cannot get clients with invalid limit param format
    ${params}    Create Dictionary    limit=m
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    28
    Should Be Equal    ${message}[0]    INVALID_QUERY_PARAM_VALUE    
                   
verify that user cannot get clients with invalid offset param format
    ${params}    Create Dictionary    offset=m
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    28
    Should Be Equal    ${message}[0]    INVALID_QUERY_PARAM_VALUE 
           
verify that user cannot get clients with wrong endpoint
    ${response}=    Get Request    clients_session    /client
    Status Should Be    404    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    60
    Should Be Equal    ${message}[0]    NOT_FOUND 
  
verify that user cannot get a specific client with wrong id
    ${client-id}=    Set Variable    1
    ${response}=    Get Request    clients_session        ${endpoint}/${client-id} 
    Status Should Be    404    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    60
    Should Be Equal    ${message}[0]    NOT_FOUND 

verify that user cannot get a specific client with the name
    ${response}=    Get Request    clients_session        ${endpoint}/client111 
    Status Should Be    404    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal    ${code}[0]    60
    Should Be Equal    ${message}[0]    NOT_FOUND 