*** Settings ***
Documentation     Testes de autenticação básica da API Restful-Booker.
...               Valida geração de token, rejeição de credenciais inválidas
...               e comportamento com dados ausentes.
Resource          ../../../../resources/main.robot
Suite Setup       Criar Sessão API
Suite Teardown    Delete All Sessions
Test Teardown     Test Teardown Padrão


*** Test Cases ***
Autenticação com credenciais válidas deve retornar token
    [Documentation]    Valida que POST /auth com credenciais corretas retorna token válido.
    [Tags]    smoke    regression    critical    autenticacao
    O endpoint de autenticação está disponível
    Realizo POST em /auth com usuário admin e senha password123
    O status da resposta deve ser 200
    O corpo da resposta deve conter o campo token
    O token retornado não deve estar vazio

Autenticação com senha incorreta deve retornar mensagem de erro
    [Documentation]    Valida que credenciais inválidas não geram token de acesso.
    [Tags]    regression    high    autenticacao    campos-invalidos
    O endpoint de autenticação está disponível
    Realizo POST em /auth com usuário admin e senha errada
    A resposta deve indicar falha na autenticação

Autenticação com usuário inexistente deve retornar mensagem de erro
    [Documentation]    Valida que usuário não cadastrado não obtém token.
    [Tags]    regression    high    autenticacao    campos-invalidos
    O endpoint de autenticação está disponível
    Realizo POST em /auth com usuário inexistente e senha qualquer
    A resposta deve indicar falha na autenticação

Autenticação sem informar senha deve retornar mensagem de erro
    [Documentation]    Valida comportamento ao omitir o campo password no body.
    [Tags]    regression    medium    autenticacao    campos-obrigatorios
    O endpoint de autenticação está disponível
    Realizo POST em /auth apenas com o campo username
    A resposta deve indicar falha na autenticação

Autenticação sem informar usuário deve retornar mensagem de erro
    [Documentation]    Valida comportamento ao omitir o campo username no body.
    [Tags]    regression    medium    autenticacao    campos-obrigatorios
    O endpoint de autenticação está disponível
    Realizo POST em /auth apenas com o campo password
    A resposta deve indicar falha na autenticação

Autenticação com body vazio deve retornar mensagem de erro
    [Documentation]    Valida comportamento da API ao receber body sem campos.
    [Tags]    regression    medium    autenticacao    campos-obrigatorios
    O endpoint de autenticação está disponível
    Realizo POST em /auth com body vazio
    A resposta deve indicar falha na autenticação


*** Keywords ***
O endpoint de autenticação está disponível
    Log    Sessão já criada no Suite Setup

Realizo POST em /auth com usuário admin e senha password123
    ${payload}=    Create Dictionary    username=${ADMIN_USER}    password=${ADMIN_PASS}
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Realizo POST em /auth com usuário admin e senha errada
    ${payload}=    Create Dictionary    username=${ADMIN_USER}    password=senhaerrada
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Realizo POST em /auth com usuário inexistente e senha qualquer
    ${payload}=    Create Dictionary    username=usuario_nao_existe    password=qualquer
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Realizo POST em /auth apenas com o campo username
    ${payload}=    Create Dictionary    username=${ADMIN_USER}
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Realizo POST em /auth apenas com o campo password
    ${payload}=    Create Dictionary    password=${ADMIN_PASS}
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Realizo POST em /auth com body vazio
    ${payload}=    Create Dictionary
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

O status da resposta deve ser 200
    Status Deve Ser    ${RESPONSE}    200

O corpo da resposta deve conter o campo token
    Response Body Deve Conter Chave    ${RESPONSE}    token

O token retornado não deve estar vazio
    ${token}=    Get From Dictionary    ${RESPONSE.json()}    token
    Should Not Be Empty    ${token}    msg=Token retornado está vazio

A resposta deve indicar falha na autenticação
    Autenticação Com Credenciais Inválidas Deve Falhar    ${RESPONSE}
