*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    FakerLibrary
Suite Setup    Create Session    mysession    ${base url}    verify=False    disable_warnings=1
Suite Teardown    Delete All Sessions    

*** Variables ***
${base url}    https://6213974e89fad53b1ffa2093.mockapi.io
${endpoint}    /Students
         

*** Test Cases ***
verify that user can get all students
    ${response}=    Get Request    mysession        ${endpoint}        
    Status Should Be    200    ${response}
        
verify that user can get a specific Student with his id
    ${Student-id}=    Set Variable    1
    ${response}=    Get Request    mysession        ${endpoint}/${Student-id} 
    Status Should Be    200    ${response}
    ${Student-name}=    Get Value From Json    ${response.json()}    $.Name
    Should Be Equal    ${Student-name}[0]    Natalia 
    
verify that user can get a specific 100 client by default
    ${response}=    Get Request    mysession        /Students    
    Status Should Be    200    ${response}   
    ${values}=    Get Value From Json    ${response.json()}    $.[]
    ${length}=    Get Length    ${values}
    Should Be Equal As Integers    ${length}    40    


post
    
    ${name}=    First Name
    ${Get response}=    Get Request    mysession        /Students    
    Status Should Be    200    ${Get response}   
    ${res.ids}=    Get Value From Json    ${Get response.json()}    $..id
    ${body}=    Create Dictionary    Name=${name}    Country=Egypt    SchoolName=hassan    mobile=01234567899    
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${post response}=    Post Request    mysession    ${endpoint}    data=${body}    headers=${headers}    
    Status Should Be    201    ${post response}  
    ${res.id}=    Get Value From Json    ${post response.json()}    $.id
    Should Not Contain    ${res.ids}    ${res.id}   
        
    ${Get response}=    Get Request    clients_session        /clients
    Status Should Be    ${Get response}    200    
    ${All clients ids}=    Get Value From Json    ${Get response.json()}    $..id
    ${name}=    First Name    
    ${body}=    Create Dictionary    name=${name}    creationDate=null    numbersSearchAllowed=true
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${Post response}=    Post Request    clients_session    /clients    data=${body}    headers=${headers}
    Status Should Be    ${Post response}    201    
    ${client id}=    Get Value From Json    ${Post response.json()}    $.id
    Should Not Contain    ${All clients ids}    ${client id} 
     


try faker
    ${name}=    First Name
    Log To Console    ${name}    
    
verify that user can get with id the client which he created
    ${name}=    First Name
    ${body}=    Create Dictionary    Name=${name}    Country=Egypt    SchoolName=hassan    mobile=01234567899
    ${headers}=    Create Dictionary    Content-Type=application/json    
    ${response}=    Post Request    mysession    ${endpoint}    data=${body}    headers=${headers}    
    ${response}=    Post Request    mysession    ${endpoint}    data=${body}    headers=${headers}    
    # Status Should Be    201    ${response}
    # ${res.name}=    Get Value From Json    ${response.json()}    $.id
    # ${Student-id}=    Set Variable    1
    # ${response}=    Get Request    mysession        ${endpoint} 
    # Status Should Be    200    ${response}
    # ${res.ids}=    Get Value From Json    ${response.json()}    $..id
    # Should Contain    ${res.ids}    ${res.name}[0]        
    
