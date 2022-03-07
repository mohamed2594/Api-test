*** Settings ***
Resource    ../Resources/common.robot

Suite Setup    Create Session  clients_session  ${base_url}    verify=False    disable_warnings=1     
Suite Teardown    Delete All Sessions


 
*** Test Cases ***
verify that user can get clients
    ${response}=    Get clients    clients_session    /clients
    Assert Status_Code    200    ${response}
    Assert Schema    clients.schema.json    ${response.json()}    
        
    
verify that user can get a specific client with his id
    ${Post_response}=    Create a client    clients_session    /clients
    Assert Status_Code    201    ${Post_Response}  
    ${res.id}=    Get Value From Json    ${Post_response.json()}    $.id
    ${Get_Response}=    Get one client    clients_session    /clients    ${res.id}[0]
    Assert Status_Code    200    ${Get_Response}
    # ${client-name}=    Get Value From Json    ${Get_response.json()}    $.name
    # Should Be Equal    ${client-name}[0]    ${name}    
 
   
verify that user can get a 100 client by default
    ${response}=    Get clients    clients_session    /clients
    Assert Status_Code    200    ${response}
    Assert Schema    clients.schema.json    ${response.json()}
    Assert Results Number    100    ${response.json()}    ${response.headers}  

verify that user can get less than 100 clients
    ${response}=    Get number of clients    clients_session    /clients    20
    Assert Status_Code    200    ${response}
    Assert Schema    clients.schema.json    ${response.json()}
    Assert Results Number    20    ${response.json()}    ${response.headers}

verify that user cannot get more than 100 client
    # ${params}    Create Dictionary    limit=120
    # ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    # Status Should Be    400    ${response}
    # ${code}=    Get Value From Json    ${response.json()}    $.code
    # ${message}=    Get Value From Json    ${response.json()}    $.message
    # Should Be Equal As Integers    ${code}[0]    28
    # Should Be Equal    ${message}[0]    INVALID_QUERY_PARAM_VALUE    
    ${response}=    Get number of clients    clients_session    /clients    20
    Assert Status_Code    200    ${response}
    Assert Schema    clients.schema.json    ${response.json()}
    Assert Results Number    20    ${response.json()}    ${response.headers}
  
verify that user can make offset for the geted clients
    ${response}=    Get Request    clients_session    ${endpoint}
    Status Should Be    200    ${response} 
    ${total_clients}=    Get From Dictionary    ${response.headers}    x-total-count
     # Log To Console    ${total clients}    
    ${offset}=    Evaluate    ${total_clients}-20
    # Log To Console    ${offset}    
    ${params}    Create Dictionary    offset=${offset}
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    Status Should Be    200    ${response}        
    ${result_length}=    Get From Dictionary    ${response.headers}    x-result-count
    Should Be Equal As Integers    ${result_length}    20  
    ${values}=    Get Value From Json    ${response.json()}    $..id
    ${length}=    Get Length    ${values}
    Should Be Equal As Integers    ${length}    20  
     
       

verify that user cannot get clients with invalid limit param format
    ${params}    Create Dictionary    limit=m
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    Status Should Be    400    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal As Integers    ${code}[0]    28
    Should Be Equal    ${message}[0]    INVALID_QUERY_PARAM_VALUE    
                   
verify that user cannot get clients with invalid offset param format
    ${params}    Create Dictionary    offset=m
    ${response}=    Get Request    clients_session    ${endpoint}    params=${params}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal As Integers    ${code}[0]    28
    Should Be Equal    ${message}[0]    INVALID_QUERY_PARAM_VALUE 
           
verify that user cannot get clients with wrong endpoint
    ${response}=    Get Request    clients_session    /client
    Status Should Be    404    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal As Integers    ${code}[0]    60
    Should Be Equal    ${message}[0]    NOT_FOUND 
  
verify that user cannot get a specific client with wrong id
    ${client-id}=    Set Variable    1
    ${response}=    Get Request    clients_session        ${endpoint}/${client-id} 
    Status Should Be    404    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal As Integers    ${code}[0]    60
    Should Be Equal    ${message}[0]    NOT_FOUND 

verify that user cannot get a specific client with the name
    ${response}=    Get Request    clients_session        ${endpoint}/client111 
    Status Should Be    404    ${response}
    ${code}=    Get Value From Json    ${response.json()}    $.code
    ${message}=    Get Value From Json    ${response.json()}    $.message
    Should Be Equal As Integers    ${code}[0]    60
    Should Be Equal    ${message}[0]    NOT_FOUND 