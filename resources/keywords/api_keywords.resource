*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     BuiltIn
Resource    ../variables/common_variables.resource


*** Keywords ***
Criar Sessão API
    [Documentation]    Cria sessão HTTP reutilizável com headers padrão JSON.
    [Arguments]    ${alias}=default
    Create Session    ${alias}    ${BASE_URL}    headers=${HEADERS_JSON}    verify=True

Criar Sessão Com Token
    [Documentation]    Cria sessão HTTP com cookie de autenticação.
    [Arguments]    ${token}    ${alias}=auth
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${token}
    Create Session    ${alias}    ${BASE_URL}    headers=${headers}    verify=True

Fazer POST
    [Documentation]    Executa requisição POST e retorna o response.
    [Arguments]    ${endpoint}    ${payload}    ${alias}=default    ${expected_status}=200
    ${response}=    POST On Session    ${alias}    ${endpoint}    json=${payload}
    ...    expected_status=any
    RETURN    ${response}

Fazer GET
    [Documentation]    Executa requisição GET e retorna o response.
    [Arguments]    ${endpoint}    ${alias}=default    ${params}=${None}
    ${response}=    GET On Session    ${alias}    ${endpoint}
    ...    params=${params}    expected_status=any
    RETURN    ${response}

Fazer PUT
    [Documentation]    Executa requisição PUT e retorna o response.
    [Arguments]    ${endpoint}    ${payload}    ${alias}=auth
    ${response}=    PUT On Session    ${alias}    ${endpoint}    json=${payload}
    ...    expected_status=any
    RETURN    ${response}

Fazer PATCH
    [Documentation]    Executa requisição PATCH e retorna o response.
    [Arguments]    ${endpoint}    ${payload}    ${alias}=auth
    ${response}=    PATCH On Session    ${alias}    ${endpoint}    json=${payload}
    ...    expected_status=any
    RETURN    ${response}

Fazer DELETE
    [Documentation]    Executa requisição DELETE e retorna o response.
    [Arguments]    ${endpoint}    ${alias}=auth
    ${response}=    DELETE On Session    ${alias}    ${endpoint}    expected_status=any
    RETURN    ${response}

Status Deve Ser
    [Documentation]    Valida o HTTP status code do response.
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}
    ...    msg=Status esperado: ${expected_status} | Recebido: ${response.status_code}

Response Body Deve Conter Chave
    [Documentation]    Valida que o corpo JSON da resposta contém determinada chave.
    [Arguments]    ${response}    ${key}
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    ${key}
    ...    msg=Chave '${key}' não encontrada na resposta

Response Body Deve Ter Valor
    [Documentation]    Valida que uma chave do JSON tem o valor esperado.
    [Arguments]    ${response}    ${key}    ${expected_value}
    ${json}=    Set Variable    ${response.json()}
    ${actual}=    Get From Dictionary    ${json}    ${key}
    Should Be Equal As Strings    ${actual}    ${expected_value}
    ...    msg=Chave '${key}': esperado '${expected_value}' | obtido '${actual}'

Content Type Deve Ser JSON
    [Documentation]    Valida que o Content-Type da resposta é JSON.
    [Arguments]    ${response}
    Should Contain    ${response.headers['Content-Type']}    application/json
    ...    msg=Content-Type não é JSON: ${response.headers['Content-Type']}
