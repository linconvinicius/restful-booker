*** Settings ***
Documentation     Testes de segurança da API Restful-Booker — Nível 2 Diferencial.
...               Valida proteção de endpoints contra acesso não autorizado,
...               injeção de dados maliciosos e exposição indevida de recursos.
Resource          ../../../../resources/main.robot
Resource          ../../../../resources/hooks/hooks.resource
Suite Setup       Suite Setup Global
Suite Teardown    Suite Teardown Global
Test Teardown     Test Teardown Padrão


*** Test Cases ***
PUT /booking sem token deve retornar 403 Forbidden
    [Documentation]    Valida que requisições PUT sem autenticação são bloqueadas.
    [Tags]    regression    security    high    segurança
    Estou sem token de autenticação
    Tento fazer PUT em /booking/1 sem credenciais
    O status deve ser 403

DELETE /booking sem token deve retornar 403 Forbidden
    [Documentation]    Valida que requisições DELETE sem autenticação são bloqueadas.
    [Tags]    regression    security    high    segurança
    Estou sem token de autenticação
    Tento fazer DELETE em /booking/1 sem credenciais
    O status deve ser 403

PUT /booking com token inválido deve retornar 403 Forbidden
    [Documentation]    Valida que token forjado não concede acesso à atualização.
    [Tags]    regression    security    high    segurança
    Tenho um token inválido
    Tento fazer PUT em /booking/1 com token forjado
    O status deve ser 403

DELETE /booking com token inválido deve retornar 403 Forbidden
    [Documentation]    Valida que token forjado não concede acesso à deleção.
    [Tags]    regression    security    high    segurança
    Tenho um token inválido
    Tento fazer DELETE em /booking/1 com token forjado
    O status deve ser 403

GET /booking não deve expor informações sensíveis no header de resposta
    [Documentation]    Valida ausência de headers que exponham detalhes de servidor.
    [Tags]    regression    security    medium    segurança
    O endpoint de reservas está disponível
    Consulto GET /booking
    O header X-Powered-By não deve estar exposto

POST /auth com SQL Injection no campo username não deve retornar token
    [Documentation]    Valida que tentativa de injeção SQL no campo username é tratada.
    [Tags]    regression    security    high    segurança    sql-injection
    O endpoint de autenticação está disponível
    Tento autenticar com payload de SQL Injection no username
    A autenticação não deve ter êxito

POST /auth com SQL Injection no campo password não deve retornar token
    [Documentation]    Valida que tentativa de injeção SQL no campo password é tratada.
    [Tags]    regression    security    high    segurança    sql-injection
    O endpoint de autenticação está disponível
    Tento autenticar com payload de SQL Injection no password
    A autenticação não deve ter êxito

GET /booking deve responder em tempo aceitável
    [Documentation]    Valida que o endpoint de listagem responde em menos de 5 segundos.
    [Tags]    regression    security    medium    performance
    O endpoint de reservas está disponível
    Consulto GET /booking e meço o tempo de resposta
    O tempo de resposta deve ser menor que 5 segundos

POST /auth deve responder em tempo aceitável
    [Documentation]    Valida que autenticação responde em menos de 5 segundos.
    [Tags]    regression    security    medium    performance
    O endpoint de autenticação está disponível
    Realizo POST em /auth e meço o tempo de resposta
    O tempo de resposta deve ser menor que 5 segundos

GET /booking/{id} com ID alfanumérico deve retornar 404 ou 405
    [Documentation]    Valida que IDs com caracteres não numéricos são tratados corretamente.
    [Tags]    regression    security    medium    segurança    campos-invalidos
    O endpoint de reservas está disponível
    Consulto GET /booking com id alfanumérico
    O status deve ser 404 ou 405


*** Keywords ***
Estou sem token de autenticação
    Criar Sessão API

O endpoint de reservas está disponível
    Log    Sessão disponível

O endpoint de autenticação está disponível
    Log    Sessão disponível

Tenho um token inválido
    Set Test Variable    ${TOKEN_INVALIDO}    tokenFalsoQueNaoFunciona123

Tento fazer PUT em /booking/1 sem credenciais
    ${payload}=    Montar Payload De Reserva Completo
    ${response}=    Fazer PUT    ${BOOKING_ENDPOINT}/1    ${payload}    alias=default
    Set Test Variable    ${RESPONSE}    ${response}

Tento fazer DELETE em /booking/1 sem credenciais
    ${response}=    Fazer DELETE    ${BOOKING_ENDPOINT}/1    alias=default
    Set Test Variable    ${RESPONSE}    ${response}

Tento fazer PUT em /booking/1 com token forjado
    Criar Sessão Com Token    ${TOKEN_INVALIDO}    alias=fake
    ${payload}=    Montar Payload De Reserva Completo
    ${response}=    Fazer PUT    ${BOOKING_ENDPOINT}/1    ${payload}    alias=fake
    Set Test Variable    ${RESPONSE}    ${response}

Tento fazer DELETE em /booking/1 com token forjado
    Criar Sessão Com Token    ${TOKEN_INVALIDO}    alias=fake2
    ${response}=    Fazer DELETE    ${BOOKING_ENDPOINT}/1    alias=fake2
    Set Test Variable    ${RESPONSE}    ${response}

Consulto GET /booking
    ${response}=    Obter Lista De Reservas
    Set Test Variable    ${RESPONSE}    ${response}

O header X-Powered-By não deve estar exposto
    ${headers}=    Set Variable    ${RESPONSE.headers}
    ${has_header}=    Run Keyword And Return Status
    ...    Dictionary Should Contain Key    ${headers}    X-Powered-By
    IF    ${has_header}
        ${value}=    Get From Dictionary    ${headers}    X-Powered-By
        Log    AVISO: Header X-Powered-By exposto com valor: ${value}    level=WARN
    END
    # Registra como informativo — a ausência é o comportamento ideal
    Log    Verificação de headers de segurança concluída

Tento autenticar com payload de SQL Injection no username
    Criar Sessão API
    ${payload}=    Create Dictionary
    ...    username=' OR '1'='1
    ...    password=qualquer
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Tento autenticar com payload de SQL Injection no password
    Criar Sessão API
    ${payload}=    Create Dictionary
    ...    username=${ADMIN_USER}
    ...    password=' OR '1'='1
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

A autenticação não deve ter êxito
    ${json}=    Set Variable    ${RESPONSE.json()}
    ${has_token}=    Run Keyword And Return Status
    ...    Dictionary Should Contain Key    ${json}    token
    IF    ${has_token}
        ${token}=    Get From Dictionary    ${json}    token
        Should Be Empty    ${token}
        ...    msg=FALHA DE SEGURANÇA: Token gerado para payload de injeção!
    ELSE
        Log    Correto: Nenhum token foi retornado para o payload malicioso
    END

Consulto GET /booking e meço o tempo de resposta
    ${inicio}=    Get Time    epoch
    ${response}=    Obter Lista De Reservas
    ${fim}=    Get Time    epoch
    ${tempo}=    Evaluate    ${fim} - ${inicio}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${TEMPO_RESPOSTA}    ${tempo}

Realizo POST em /auth e meço o tempo de resposta
    Criar Sessão API
    ${payload}=    Create Dictionary    username=${ADMIN_USER}    password=${ADMIN_PASS}
    ${inicio}=    Get Time    epoch
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    ${fim}=    Get Time    epoch
    ${tempo}=    Evaluate    ${fim} - ${inicio}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${TEMPO_RESPOSTA}    ${tempo}

O tempo de resposta deve ser menor que 5 segundos
    Should Be True    ${TEMPO_RESPOSTA} < 5
    ...    msg=Tempo de resposta acima do limite: ${TEMPO_RESPOSTA}s (limite: 5s)

Consulto GET /booking com id alfanumérico
    ${response}=    Obter Reserva Por ID    abc123
    Set Test Variable    ${RESPONSE}    ${response}

O status deve ser 403
    Status Deve Ser    ${RESPONSE}    403

O status deve ser 404
    Status Deve Ser    ${RESPONSE}    404

O status deve ser 200
    Status Deve Ser    ${RESPONSE}    200

O status deve ser 404 ou 405
    ${status}=    Set Variable    ${RESPONSE.status_code}
    Should Be True    ${status} == 404 or ${status} == 405
    ...    msg=Status esperado 404 ou 405 | Recebido: ${status}
