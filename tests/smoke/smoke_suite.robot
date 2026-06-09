*** Settings ***
Documentation     Smoke tests da API Restful-Booker.
...               Valida os fluxos mais críticos em execução rápida.
Resource          ../../resources/main.robot
Resource          ../../resources/hooks/hooks.resource
Suite Setup       Criar Sessão API
Suite Teardown    Delete All Sessions
Test Teardown     Test Teardown Padrão


*** Test Cases ***
API está respondendo — health check
    [Documentation]    Valida que o endpoint principal da API está acessível.
    [Tags]    smoke    critical
    O endpoint de reservas está disponível
    Consulto GET /booking
    O status deve ser 200

Autenticação básica está funcional
    [Documentation]    Valida que o fluxo de autenticação retorna token.
    [Tags]    smoke    critical    autenticacao
    O endpoint de autenticação está disponível
    Realizo POST em /auth com credenciais válidas
    O token deve ser retornado

CRUD básico está funcional
    [Documentation]    Valida criação e consulta de reserva em sequência.
    [Tags]    smoke    critical    booking
    Tenho um token de autenticação
    Crio uma reserva e consulto pelo ID retornado
    A reserva deve existir com os dados corretos


*** Keywords ***
O endpoint de reservas está disponível
    Log    Sessão criada no Suite Setup

O endpoint de autenticação está disponível
    Log    Sessão criada no Suite Setup

Consulto GET /booking
    ${response}=    Obter Lista De Reservas
    Set Test Variable    ${RESPONSE}    ${response}

O status deve ser 200
    Status Deve Ser    ${RESPONSE}    200

Realizo POST em /auth com credenciais válidas
    ${payload}=    Create Dictionary    username=${ADMIN_USER}    password=${ADMIN_PASS}
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

O token deve ser retornado
    Response Body Deve Conter Chave    ${RESPONSE}    token
    ${token}=    Get From Dictionary    ${RESPONSE.json()}    token
    Should Not Be Empty    ${token}

Tenho um token de autenticação
    ${payload}=    Create Dictionary    username=${ADMIN_USER}    password=${ADMIN_PASS}
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    ${token}=    Get From Dictionary    ${response.json()}    token
    Set Test Variable    ${AUTH_TOKEN}    ${token}

Crio uma reserva e consulto pelo ID retornado
    ${payload}=    Montar Payload De Reserva Completo    firstname=Smoke    lastname=Test
    ${response_create}=    Criar Nova Reserva    ${payload}
    Status Deve Ser    ${response_create}    200
    ${id}=    Get From Dictionary    ${response_create.json()}    bookingid
    Set Test Variable    ${SMOKE_BOOKING_ID}    ${id}
    ${response_get}=    Obter Reserva Por ID    ${id}
    Set Test Variable    ${RESPONSE}    ${response_get}

A reserva deve existir com os dados corretos
    Status Deve Ser    ${RESPONSE}    200
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Be Equal As Strings    ${json['firstname']}    Smoke
    Should Be Equal As Strings    ${json['lastname']}    Test
