*** Settings ***
Library    RequestsLibrary




*** Test Cases ***
Get_request
    ${Response}=    GET    https://6213974e89fad53b1ffa2093.mockapi.io/Students/18
    #Log To Console    ${Response.status_code}    
    #Log To Console    ${Response.content}    
    #Log To Console    ${Response.headers}
    

   # ${staus_code}=    Convert To String    ${Response.status_code}
   # Should Be Equal    ${staus_code}    200
    Status Should Be    200        
    
    

