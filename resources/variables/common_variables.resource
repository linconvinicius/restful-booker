*** Variables ***
${BASE_URL}           https://restful-booker.herokuapp.com
${AUTH_ENDPOINT}      /auth
${BOOKING_ENDPOINT}   /booking

# Credenciais padrão da API
${ADMIN_USER}         admin
${ADMIN_PASS}         password123

# Timeouts
${TIMEOUT}            30s

# Headers padrão
&{HEADERS_JSON}       Content-Type=application/json    Accept=application/json
