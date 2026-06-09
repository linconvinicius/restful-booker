*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     BuiltIn

Resource    variables/common_variables.resource
Resource    keywords/api_keywords.resource
Resource    keywords/auth_keywords.resource
Resource    keywords/booking_keywords.resource
Resource    keywords/bdd_pt.resource
Resource    hooks/hooks.resource