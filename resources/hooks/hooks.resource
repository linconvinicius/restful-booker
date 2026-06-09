*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    ../variables/common_variables.resource
Resource    ../keywords/api_keywords.resource
Resource    ../keywords/bdd_pt.resource


*** Keywords ***
Suite Setup Global
    [Documentation]    Setup global: cria sessão e obtém token de autenticação.
    Criar Sessão API
    ${payload}=    Create Dictionary    username=${ADMIN_USER}    password=${ADMIN_PASS}
    ${response}=    Fazer POST    ${AUTH_ENDPOINT}    ${payload}
    ${token}=    Get From Dictionary    ${response.json()}    token
    Set Suite Variable    ${TOKEN}    ${token}

Suite Teardown Global
    [Documentation]    Teardown global: encerra todas as sessões HTTP abertas.
    Delete All Sessions

Test Teardown Padrão
    [Documentation]    Teardown padrão aplicado a cada test case.
    Run Keyword If Test Failed    Log    FALHOU: ${TEST NAME}    level=ERROR
