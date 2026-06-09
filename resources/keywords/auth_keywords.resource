*** Settings ***
Resource    api_keywords.resource
Resource    ../variables/common_variables.resource


*** Keywords ***
Obter Token De Autenticação
    [Documentation]    Autentica com credenciais válidas e retorna o token gerado.
    [Arguments]    ${username}=${ADMIN_USER}    ${password}=${ADMIN_PASS}
    Criar Sessão API
    ${payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    RETURN    ${response}

Token Deve Ser Gerado Com Sucesso
    [Documentation]    Valida que o token foi retornado corretamente na resposta.
    [Arguments]    ${response}
    Status Deve Ser    ${response}    200
    Response Body Deve Conter Chave    ${response}    token
    ${token}=    Get From Dictionary    ${response.json()}    token
    Should Not Be Empty    ${token}    msg=Token retornado está vazio
    RETURN    ${token}

Autenticação Com Credenciais Inválidas Deve Falhar
    [Documentation]    Valida comportamento da API para credenciais incorretas.
    [Arguments]    ${response}
    Status Deve Ser    ${response}    200
    ${json}=    Set Variable    ${response.json()}
    # A API retorna 200 com body {"reason": "Bad credentials"} para auth inválida
    ${has_reason}=    Run Keyword And Return Status
    ...    Dictionary Should Contain Key    ${json}    reason
    IF    ${has_reason}
        ${reason}=    Get From Dictionary    ${json}    reason
        Should Be Equal As Strings    ${reason}    Bad credentials
        ...    msg=Mensagem de erro inesperada: ${reason}
    ELSE
        ${has_token}=    Run Keyword And Return Status
        ...    Dictionary Should Contain Key    ${json}    token
        Should Not Be True    ${has_token}
        ...    msg=Token não deveria ser retornado para credenciais inválidas
    END
