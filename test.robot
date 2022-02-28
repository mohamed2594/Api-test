*** Settings ***

Library    Collections
Library    RequestsLibrary

Suite Setup    Create Session  client_session  ${base_url}    verify=False    disable_warnings=1    
Suite Teardown    Delete All Sessions
*** Variables ***
${base_url}=    https://api-alias-preprod.itn.intraorange/validation/admin-private/v1
  


*** Test Cases ***
verify that user cannot create a client without body
    ${body}=    Create Dictionary
    ${response}=    Post Request    client_session    /clients    ${body}
    Status Should Be    400    ${response}
    Log To Console    message    
    #Should Contain    Convert To String    ${response.content}    "code": 21
    #Should Contain    Convert To String    ${response.content}    "message": "MISSING_BODY"