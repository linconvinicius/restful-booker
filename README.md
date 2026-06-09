# Restful-Booker — Automação de Testes de API

Projeto de automação de testes para a API [Restful-Booker](https://restful-booker.herokuapp.com), cobrindo os níveis **Obrigatório** e **Diferencial** do desafio proposto.

---

## Escopo de Cobertura

### Nível 1 — Obrigatório
- Autenticação básica (`POST /auth`)
- CRUD completo de reservas (`GET`, `POST`, `PUT`, `PATCH`, `DELETE /booking`)
- Validação de campos obrigatórios (criação e atualização)

### Nível 2 — Diferencial
- Testes de performance (tempo de resposta dos endpoints)
- Testes de segurança (acesso não autorizado, SQL Injection, headers expostos)
- Automação via scripts com CI/CD no GitHub Actions

---

## Pré-requisitos

- Python 3.12+
- pip

---

## Instalação

```bash
pip install -r requirements.txt
```

---

## Como Executar

### Todos os testes
```bash
robot --outputdir reports tests/
```

### Apenas Smoke
```bash
robot --include smoke --outputdir reports/smoke tests/
```

### Apenas Regression
```bash
robot --include regression --outputdir reports/regression tests/
```

### Apenas testes de segurança
```bash
robot --include segurança --outputdir reports/security tests/
```

### Suite específica
```bash
robot --outputdir reports tests/functional/api/auth/auth_suite.robot
robot --outputdir reports tests/functional/api/booking/booking_suite.robot
robot --outputdir reports tests/functional/api/booking_management/security_suite.robot
```

---

## Estrutura do Projeto

```
restful-booker-rf/
├── .github/workflows/
│   ├── regression.yml      # Pipeline de regressão (main/develop)
│   └── smoke.yml           # Pipeline de smoke (todo push)
├── resources/
│   ├── keywords/
│   │   ├── api_keywords.resource       # Keywords HTTP reutilizáveis
│   │   ├── auth_keywords.resource      # Keywords de negócio - autenticação
│   │   └── booking_keywords.resource   # Keywords de negócio - reservas
│   ├── variables/
│   │   └── common_variables.resource   # Variáveis globais
│   └── hooks/
│       └── hooks.resource              # Setup e teardown de suite/test
├── tests/
│   ├── functional/api/
│   │   ├── auth/
│   │   │   └── auth_suite.robot        # Testes de autenticação
│   │   ├── booking/
│   │   │   └── booking_suite.robot     # CRUD de reservas
│   │   └── booking_management/
│   │       └── security_suite.robot    # Segurança e performance
│   └── smoke/
│       └── smoke_suite.robot           # Smoke tests
├── reports/                            # Relatórios gerados (gitignored)
├── .robocop                            # Config de linting
├── requirements.txt
└── README.md
```

---

## Tags Disponíveis

| Tag | Descrição |
|---|---|
| `smoke` | Testes críticos de execução rápida |
| `regression` | Cobertura completa de regressão |
| `autenticacao` | Cenários de autenticação |
| `booking` | Cenários de reservas |
| `segurança` | Testes de segurança |
| `performance` | Testes de performance |
| `campos-obrigatorios` | Validação de campos obrigatórios |
| `campos-invalidos` | Validação de dados inválidos |
| `sql-injection` | Tentativas de injeção SQL |
| `critical` | Criticidade máxima |
| `high` | Alta criticidade |
| `medium` | Criticidade média |

---

## Credenciais Padrão da API

A API Restful-Booker utiliza credenciais fixas de demonstração:
- **Usuário:** `admin`
- **Senha:** `password123`

> A API reseta seu estado a cada 10 minutos.
