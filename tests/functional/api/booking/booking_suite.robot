*** Settings ***
Documentation     CRUD completo de reservas da API Restful-Booker.
...               Cobre criação, leitura, atualização e remoção de bookings,
...               incluindo validação de campos obrigatórios e filtros de busca.
Resource          ../../../../resources/main.robot
Suite Setup       Suite Setup Global
Suite Teardown    Suite Teardown Global
Test Teardown     Test Teardown Padrão


*** Variables ***
${BOOKING_ID_CRIADO}    ${EMPTY}


*** Test Cases ***
GET /booking deve retornar lista de reservas existentes
    [Documentation]    Valida que a listagem de reservas retorna array com bookingid.
    [Tags]    smoke    regression    critical    booking    crud
    O endpoint de reservas está disponível
    Consulto GET /booking sem parâmetros
    A lista de reservas deve ter estrutura válida

GET /booking com filtro por firstname deve retornar reservas correspondentes
    [Documentation]    Valida filtro de reservas pelo parâmetro firstname.
    [Tags]    regression    medium    booking    filtro
    O endpoint de reservas está disponível
    Consulto GET /booking com parâmetro firstname igual a Eric
    A resposta deve ter status 200
    O resultado deve ser uma lista

GET /booking com filtro por lastname deve retornar reservas correspondentes
    [Documentation]    Valida filtro de reservas pelo parâmetro lastname.
    [Tags]    regression    medium    booking    filtro
    O endpoint de reservas está disponível
    Consulto GET /booking com parâmetro lastname igual a Brown
    A resposta deve ter status 200
    O resultado deve ser uma lista

GET /booking/{id} deve retornar detalhes de uma reserva existente
    [Documentation]    Valida retorno de booking específico com todos os campos.
    [Tags]    smoke    regression    critical    booking    crud
    O endpoint de reservas está disponível
    Consulto GET /booking com id igual a 1
    O status deve ser 200
    A reserva deve conter os campos obrigatórios

GET /booking/{id} com ID inexistente deve retornar 404
    [Documentation]    Valida que ID não cadastrado retorna Not Found.
    [Tags]    regression    medium    booking    campos-invalidos
    O endpoint de reservas está disponível
    Consulto GET /booking com id igual a 999999
    O status deve ser 404

POST /booking com todos os campos válidos deve criar reserva
    [Documentation]    Valida criação de reserva com payload completo.
    [Tags]    smoke    regression    critical    booking    crud
    O endpoint de reservas está disponível
    Crio uma reserva com todos os campos preenchidos
    O status deve ser 200
    A resposta deve conter bookingid e os dados enviados
    Armazeno o ID da reserva criada

POST /booking sem firstname deve retornar erro de validação
    [Documentation]    Valida que campo firstname é obrigatório na criação.
    [Tags]    regression    high    booking    campos-obrigatorios
    O endpoint de reservas está disponível
    Crio uma reserva sem o campo firstname
    A resposta deve indicar campo obrigatório ausente

POST /booking sem lastname deve retornar erro de validação
    [Documentation]    Valida que campo lastname é obrigatório na criação.
    [Tags]    regression    high    booking    campos-obrigatorios
    O endpoint de reservas está disponível
    Crio uma reserva sem o campo lastname
    A resposta deve indicar campo obrigatório ausente

POST /booking sem totalprice deve retornar erro de validação
    [Documentation]    Valida que campo totalprice é obrigatório na criação.
    [Tags]    regression    high    booking    campos-obrigatorios
    O endpoint de reservas está disponível
    Crio uma reserva sem o campo totalprice
    A resposta deve indicar campo obrigatório ausente

POST /booking sem checkin deve retornar erro de validação
    [Documentation]    Valida que data de checkin é obrigatória na criação.
    [Tags]    regression    high    booking    campos-obrigatorios
    O endpoint de reservas está disponível
    Crio uma reserva sem a data de checkin
    A resposta deve indicar campo obrigatório ausente

POST /booking sem checkout deve retornar erro de validação
    [Documentation]    Valida que data de checkout é obrigatória na criação.
    [Tags]    regression    high    booking    campos-obrigatorios
    O endpoint de reservas está disponível
    Crio uma reserva sem a data de checkout
    A resposta deve indicar campo obrigatório ausente

POST /booking com formato de data inválido deve retornar erro
    [Documentation]    Valida que formato de data incorreto é rejeitado.
    [Tags]    regression    medium    booking    campos-invalidos
    O endpoint de reservas está disponível
    Crio uma reserva com formato de data inválido
    A resposta deve indicar dado inválido

PUT /booking/{id} com token válido deve atualizar reserva completa
    [Documentation]    Valida atualização total de reserva com autenticação.
    [Tags]    regression    critical    booking    crud
    Tenho um booking ID disponível para atualização
    Atualizo a reserva completamente com dados novos
    O status deve ser 200
    Os dados da reserva devem refletir as alterações

PATCH /booking/{id} com token válido deve atualizar campos parciais
    [Documentation]    Valida atualização parcial de reserva com autenticação.
    [Tags]    regression    high    booking    crud
    Tenho um booking ID disponível para atualização
    Atualizo apenas o firstname da reserva
    O status deve ser 200
    O firstname da reserva deve estar atualizado

PUT /booking/{id} sem autenticação deve retornar 403
    [Documentation]    Valida que atualização sem token é bloqueada.
    [Tags]    regression    high    booking    segurança
    O endpoint de reservas está disponível
    Tento atualizar a reserva 1 sem informar token
    O status deve ser 403

DELETE /booking/{id} com token válido deve remover a reserva
    [Documentation]    Valida remoção de reserva com autenticação.
    [Tags]    regression    critical    booking    crud
    Tenho um booking ID disponível para deleção
    Deleto a reserva com o token válido
    O status deve ser 201
    A reserva deletada não deve mais existir

DELETE /booking/{id} sem autenticação deve retornar 403
    [Documentation]    Valida que remoção sem token é bloqueada.
    [Tags]    regression    high    booking    segurança
    O endpoint de reservas está disponível
    Tento deletar a reserva 1 sem informar token
    O status deve ser 403


*** Keywords ***
O endpoint de reservas está disponível
    Log    Sessão já criada no Suite Setup

Consulto GET /booking sem parâmetros
    ${response}=    Obter Lista De Reservas
    Set Test Variable    ${RESPONSE}    ${response}

Consulto GET /booking com parâmetro firstname igual a ${nome}
    ${params}=    Create Dictionary    firstname=${nome}
    ${response}=    Obter Lista De Reservas    params=${params}
    Set Test Variable    ${RESPONSE}    ${response}

Consulto GET /booking com parâmetro lastname igual a ${sobrenome}
    ${params}=    Create Dictionary    lastname=${sobrenome}
    ${response}=    Obter Lista De Reservas    params=${params}
    Set Test Variable    ${RESPONSE}    ${response}

Consulto GET /booking com id igual a ${id}
    ${response}=    Obter Reserva Por ID    ${id}
    Set Test Variable    ${RESPONSE}    ${response}

A lista de reservas deve ter estrutura válida
    Lista De Reservas Deve Ter Estrutura Válida    ${RESPONSE}

A resposta deve ter status 200
    Status Deve Ser    ${RESPONSE}    200

O resultado deve ser uma lista
    ${lista}=    Set Variable    ${RESPONSE.json()}
    Should Not Be Empty    ${lista}

O status deve ser 200
    Status Deve Ser    ${RESPONSE}    200

O status deve ser 201
    Status Deve Ser    ${RESPONSE}    201

O status deve ser 403
    Status Deve Ser    ${RESPONSE}    403

O status deve ser 404
    Status Deve Ser    ${RESPONSE}    404

A reserva deve conter os campos obrigatórios
    Reserva Deve Ter Campos Obrigatórios    ${RESPONSE}

Crio uma reserva com todos os campos preenchidos
    ${payload}=    Montar Payload De Reserva Completo
    ${response}=    Criar Nova Reserva    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${PAYLOAD_ENVIADO}    ${payload}

A resposta deve conter bookingid e os dados enviados
    Response Body Deve Conter Chave    ${RESPONSE}    bookingid
    Response Body Deve Conter Chave    ${RESPONSE}    booking
    ${booking}=    Get From Dictionary    ${RESPONSE.json()}    booking
    Should Be Equal As Strings    ${booking['firstname']}    ${PAYLOAD_ENVIADO['firstname']}
    Should Be Equal As Strings    ${booking['lastname']}    ${PAYLOAD_ENVIADO['lastname']}

Armazeno o ID da reserva criada
    ${id}=    Get From Dictionary    ${RESPONSE.json()}    bookingid
    Set Suite Variable    ${BOOKING_ID_CRIADO}    ${id}

Crio uma reserva sem o campo ${campo}
    ${bookingdates}=    Create Dictionary    checkin=2025-03-01    checkout=2025-03-05
    ${payload}=    Create Dictionary
    ...    firstname=Test
    ...    lastname=User
    ...    totalprice=100
    ...    depositpaid=${True}
    ...    bookingdates=${bookingdates}
    Remove From Dictionary    ${payload}    ${campo}
    ${response}=    Criar Nova Reserva    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Crio uma reserva sem a data de ${campo_data}
    ${bookingdates}=    Create Dictionary    checkin=2025-03-01    checkout=2025-03-05
    Remove From Dictionary    ${bookingdates}    ${campo_data}
    ${payload}=    Create Dictionary
    ...    firstname=Test
    ...    lastname=User
    ...    totalprice=100
    ...    depositpaid=${True}
    ...    bookingdates=${bookingdates}
    ${response}=    Criar Nova Reserva    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

Crio uma reserva com formato de data inválido
    ${bookingdates}=    Create Dictionary    checkin="01/03/2025"    checkout="05/03/2025"
    ${payload}=    Montar Payload De Reserva Completo
    Set To Dictionary    ${payload}    bookingdates=${bookingdates}
    ${response}=    Criar Nova Reserva    ${payload}
    Set Test Variable    ${RESPONSE}    ${response}

A resposta deve indicar campo obrigatório ausente
    ${status}=    Set Variable    ${RESPONSE.status_code}
    Should Be True    ${status} == 400 or ${status} == 500
    ...    msg=Status esperado 400 ou 500 para campo ausente | Recebido: ${status}

A resposta deve indicar dado inválido
    ${status}=    Set Variable    ${RESPONSE.status_code}
    Should Be True    ${status} == 400 or ${status} == 500
    ...    msg=Status esperado 400 ou 500 para dado inválido | Recebido: ${status}

Tenho um booking ID disponível para atualização
    ${payload}=    Montar Payload De Reserva Completo
    ${response}=    Criar Nova Reserva    ${payload}
    Status Deve Ser    ${response}    200
    ${id}=    Get From Dictionary    ${response.json()}    bookingid
    Set Test Variable    ${BOOKING_ID_TESTE}    ${id}

Atualizo a reserva completamente com dados novos
    ${payload}=    Montar Payload De Reserva Completo
    ...    firstname=Carlos
    ...    lastname=Silva
    ...    totalprice=250
    ...    checkin=2025-06-01
    ...    checkout=2025-06-07
    ${response}=    Atualizar Reserva Completa    ${BOOKING_ID_TESTE}    ${payload}    ${TOKEN}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${PAYLOAD_ATUALIZADO}    ${payload}

Os dados da reserva devem refletir as alterações
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Be Equal As Strings    ${json['firstname']}    ${PAYLOAD_ATUALIZADO['firstname']}
    Should Be Equal As Strings    ${json['lastname']}    ${PAYLOAD_ATUALIZADO['lastname']}

Atualizo apenas o firstname da reserva
    ${payload}=    Create Dictionary    firstname=NovoNome
    ${response}=    Atualizar Reserva Parcial    ${BOOKING_ID_TESTE}    ${payload}    ${TOKEN}
    Set Test Variable    ${RESPONSE}    ${response}

O firstname da reserva deve estar atualizado
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Be Equal As Strings    ${json['firstname']}    NovoNome

Tento atualizar a reserva 1 sem informar token
    Criar Sessão API
    ${payload}=    Montar Payload De Reserva Completo
    ${response}=    Fazer PUT    ${BOOKING_ENDPOINT}/1    ${payload}    alias=default
    Set Test Variable    ${RESPONSE}    ${response}

Tenho um booking ID disponível para deleção
    ${payload}=    Montar Payload De Reserva Completo
    ${response}=    Criar Nova Reserva    ${payload}
    Status Deve Ser    ${response}    200
    ${id}=    Get From Dictionary    ${response.json()}    bookingid
    Set Test Variable    ${BOOKING_ID_DELETAR}    ${id}

Deleto a reserva com o token válido
    ${response}=    Deletar Reserva    ${BOOKING_ID_DELETAR}    ${TOKEN}
    Set Test Variable    ${RESPONSE}    ${response}

A reserva deletada não deve mais existir
    ${response}=    Obter Reserva Por ID    ${BOOKING_ID_DELETAR}
    Status Deve Ser    ${response}    404

Tento deletar a reserva 1 sem informar token
    Criar Sessão API
    ${response}=    Fazer DELETE    ${BOOKING_ENDPOINT}/1    alias=default
    Set Test Variable    ${RESPONSE}    ${response}
