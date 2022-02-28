*** Settings ***

Library    Collections
Library    RequestsLibrary

Suite Setup    Create Session  clients_session  ${base_url}    verify=False    disable_warnings=1    
Suite Teardown    Delete All Sessions
*** Variables ***
${base_url}=    https://api-alias-preprod.itn.intraorange/validation/admin-private/v1



*** Test Cases ***
verify that user can get all clients
    ${response}=    Get Request    clients_session        /clients    
    ${content}=    Convert To String    ${response.content}    
    Status Should Be    200    ${response}
    Should Contain    ${content}    id
    Should Contain    ${content}    name
    Should Contain    ${content}    creationDate    
    Should Contain    ${content}    numbersSearchAllowed    

verify that user can get a specific client with his id
    ${client-id}=    Set Variable    47cb094f-fafc-4917-a496-c8fcf9ad1dd4
    ${response}=    Get Request    clients_session        /clients/${client-id}
    ${content}=    Convert To String    ${response.content} 
    Status Should Be    200    ${response}
    Should Contain    ${content}    client111 
   
verify that user can get a specific 100 client by default
    Log    i want to count the results     

    
verify that user can get less than 100 clients
    ${params}    Create Dictionary    limit=20
    ${response}=    Get Request    clients_session    /clients    ${params}
    Status Should Be    200    ${response}    

verify that user cannot get more than 100 client
    ${params}    Create Dictionary    limit=120
    ${response}=    Get Request    clients_session    /clients    ${params}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    #Should Contain    ${content}    "code": 28
    #Should Contain    ${content}    "message": "INVALID_QUERY_PARAM_VALUE"  

verify that user can make offset for the geted clients
    ${params}    Create Dictionary    offset=5000
    ${response}=    Get Request    clients_session    /clients    ${params}
    Status Should Be    200    ${response}        

verify that user cannot get clients with invalid limit param format
    ${params}    Create Dictionary    limit=m
    ${response}=    Get Request    clients_session    /clients    ${params}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    #Should Contain    ${content}    "code": 28
    #Should Contain    ${content}    "message": "INVALID_QUERY_PARAM_VALUE"
                   
verify that user cannot get clients with invalid offset param format
    ${params}    Create Dictionary    offset=m
    ${response}=    Get Request    clients_session    /clients    ${params}
    ${content}=    Convert To String    ${response.content}
    #Should Contain    ${content}    "code": 28
    #Should Contain    ${content}    "message": "INVALID_QUERY_PARAM_VALUE"    
           
verify that user cannot get clients with wrong endpoint
    ${response}=    Get Request    clients_session    /client
    ${content}=    Convert To String    ${response.content}
    Status Should Be    404    ${response}
    #Should Contain    ${content}    "code": 60    
    #Should Contain    ${content}    "message": "NOT_FOUND"    

verify that user cannot get a specific client with wrong id
    ${client-id}=    Set Variable    1
    ${response}=    Get Request    clients_session        /clients/${client-id} 
    ${content}=    Convert To String    ${response.content}
    Status Should Be    404    ${response}
    #Should Contain    ${content}    "code": 60
    #Should Contain    ${content}    "message": "NOT_FOUND"    

verify that user cannot get a specific client with the name
    ${response}=    Get Request    clients_session        /clients/client111 
    Status Should Be    404    ${response}
    ${content}=    Convert To String    ${response.content}
    #Should Contain    ${content}    "code": 60
    #Should Contain    ${.content}    "message": "NOT_FOUND"  
        
verify that user can create a client with valid body successfully
    ${body}=    Create Dictionary    name=mohamed000    numbersSearchAllowed=true    creationDate=null
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    201    ${response}
    Should Contain    ${content}    id
    Should Contain    ${content}    name
    Should Contain    ${content}    creationDate
    Should Contain    ${content}    numbersSearchAllowed
    

verify that user can get with id the client which he created
    Log    i want to access the id of the client from the response    
    

verify that the created client is exist when get all clients
        Log    i want to access the id of the client from the response

verify that user can create a client without numbersSearchAllowed
    ${body}=    Create Dictionary    name=mohamed001    creationDate=null
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    201    ${response}
    Should Contain    ${content}    id
    Should Contain    ${content}    name
    Should Contain    ${content}    creationDate
    Should Contain    ${content}    numbersSearchAllowed
     
verify that user can create a client without creationDate
    ${body}=    Create Dictionary    name=mohamed002    numbersSearchAllowed=true
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    201    ${response}
    Should Contain    ${content}    id
    Should Contain    ${content}    name
    Should Contain    ${content}    creationDate
    Should Contain    ${content}    numbersSearchAllowed    

verify that user cannot create a client with wrong numbersSearchAllowed format
    ${body}=    Create Dictionary    name=mohamed003    creationDate=null    numbersSearchAllowed=t
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    #Should Contain    ${content}    "code": 22
    #Should Contain    ${content}    "message": "INVALID_BODY"


verify that user cannot create a client without name
     ${body}=    Create Dictionary        numbersSearchAllowed=true    creationDate=null
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    #Should Contain    ${content}    "code": 23
    #Should Contain    ${content}    "message": "MISSING_BODY_FIELD"
    
verify that user cannot create a client with blank name
    ${body}=    Create Dictionary    name=    numbersSearchAllowed=true    creationDate=null
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    #Should Contain    ${content}    "code": 23
    #Should Contain    ${content}    "message": "MISSING_BODY_FIELD"


verify that user cannot create a client without body
    ${body}=    Create Dictionary
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    #Should Contain    ${content}    "code": 21
    #Should Contain    ${content}    "message": "MISSING_BODY"   

verify that user cannot create a client with an existing id
    Log    an automatic id generated!!!    
    

verify that user cannot create a client with an existing name 
    ${body}=    Create Dictionary    name=client111    numbersSearchAllowed=true    creationDate=null
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    409    ${response}
    #Should Contain    ${content}    "code": 1111
    #Should Contain    ${content}    "message": "NAME_ALREADY_EXISTS"

verify that user cannot create a client with name length more than 50 characters
    ${invalid-name}=    Set Variable    asdfghjklaasdfghjklaasdfghjklaasdfghjklaasdfghjklaq
    ${body}=    Create Dictionary    name=${invalid-name}    numbersSearchAllowed=true    creationDate=null
    ${response}=    Post Request    clients_session    /clients    ${body}
    ${content}=    Convert To String    ${response.content}
    Status Should Be    400    ${response}
    #Should Contain    ${content}    "code": 24
    #Should Contain    ${content}    "message": "INVALID_BODY_FIELD"


    


    


    


    
        


