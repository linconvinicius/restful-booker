*** Settings ***
Documentation    Aliases para palavras-chave BDD em Português (Dado/Quando/Então/E/Mas)
Library     BuiltIn


*** Keywords ***
Dado
    [Arguments]    ${keyword}    @{args}
    Run Keyword    ${keyword}    @{args}

Quando
    [Arguments]    ${keyword}    @{args}
    Run Keyword    ${keyword}    @{args}

Então
    [Arguments]    ${keyword}    @{args}
    Run Keyword    ${keyword}    @{args}

E
    [Arguments]    ${keyword}    @{args}
    Run Keyword    ${keyword}    @{args}

Mas
    [Arguments]    ${keyword}    @{args}
    Run Keyword    ${keyword}    @{args}
