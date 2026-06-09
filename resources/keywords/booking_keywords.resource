*** Settings ***
Library     Collections
Resource    api_keywords.resource
Resource    ../variables/common_variables.resource


*** Keywords ***
Obter Lista De Reservas
    [Documentation]    Consulta o endpoint GET /booking e retorna o response.
    [Arguments]    ${params}=${None}
    Criar Sessão API
    ${response}=    Fazer GET    ${BOOKING_ENDPOINT}    params=${params}
    RETURN    ${response}

Obter Reserva Por ID
    [Documentation]    Consulta uma reserva específica pelo ID.
    [Arguments]    ${booking_id}
    Criar Sessão API
    ${response}=    Fazer GET    ${BOOKING_ENDPOINT}/${booking_id}
    RETURN    ${response}

Criar Nova Reserva
    [Documentation]    Cria uma reserva via POST /booking com o payload fornecido.
    [Arguments]    ${payload}
    Criar Sessão API
    ${response}=    Fazer POST    ${BOOKING_ENDPOINT}    ${payload}
    RETURN    ${response}

Atualizar Reserva Completa
    [Documentation]    Atualiza todos os campos de uma reserva via PUT /booking/{id}.
    [Arguments]    ${booking_id}    ${payload}    ${token}
    Criar Sessão Com Token    ${token}
    ${response}=    Fazer PUT    ${BOOKING_ENDPOINT}/${booking_id}    ${payload}
    RETURN    ${response}

Atualizar Reserva Parcial
    [Documentation]    Atualiza campos específicos de uma reserva via PATCH /booking/{id}.
    [Arguments]    ${booking_id}    ${payload}    ${token}
    Criar Sessão Com Token    ${token}
    ${response}=    Fazer PATCH    ${BOOKING_ENDPOINT}/${booking_id}    ${payload}
    RETURN    ${response}

Deletar Reserva
    [Documentation]    Remove uma reserva via DELETE /booking/{id}.
    [Arguments]    ${booking_id}    ${token}
    Criar Sessão Com Token    ${token}
    ${response}=    Fazer DELETE    ${BOOKING_ENDPOINT}/${booking_id}
    RETURN    ${response}

Montar Payload De Reserva Completo
    [Documentation]    Cria dicionário com todos os campos obrigatórios de uma reserva.
    [Arguments]
    ...    ${firstname}=Jane
    ...    ${lastname}=Doe
    ...    ${totalprice}=150
    ...    ${depositpaid}=${True}
    ...    ${checkin}=2025-01-15
    ...    ${checkout}=2025-01-20
    ...    ${additionalneeds}=Breakfast
    ${bookingdates}=    Create Dictionary    checkin=${checkin}    checkout=${checkout}
    ${payload}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=${additionalneeds}
    RETURN    ${payload}

Lista De Reservas Deve Ter Estrutura Válida
    [Documentation]    Valida que a lista retornada contém objetos com bookingid.
    [Arguments]    ${response}
    Status Deve Ser    ${response}    200
    ${lista}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${lista}    msg=Lista de reservas retornou vazia
    ${primeira}=    Get From List    ${lista}    0
    Dictionary Should Contain Key    ${primeira}    bookingid
    ...    msg=Objeto da lista não contém campo 'bookingid'

Reserva Deve Ter Campos Obrigatórios
    [Documentation]    Valida presença dos campos obrigatórios em uma reserva.
    [Arguments]    ${response}
    ${json}=    Set Variable    ${response.json()}
    FOR    ${campo}    IN    firstname    lastname    totalprice    depositpaid    bookingdates
        Dictionary Should Contain Key    ${json}    ${campo}
        ...    msg=Campo obrigatório '${campo}' ausente na reserva
    END
    Dictionary Should Contain Key    ${json['bookingdates']}    checkin
    Dictionary Should Contain Key    ${json['bookingdates']}    checkout
