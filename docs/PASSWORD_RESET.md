# Reset de Senha - Preifma API

Este documento explica como usar a funcionalidade de recuperação de senha na API Preifma.

## Endpoints Disponíveis

### 1. Solicitar Reset de Senha
**POST** `/api/password_resets`

Solicita o envio de um email com link para reset de senha.

**Parâmetros:**
```json
{
  "email": "usuario@example.com"
}
```

**Resposta de Sucesso (200):**
```json
{
  "message": "Email de recuperação enviado com sucesso!",
  "email": "usuario@example.com"
}
```

**Resposta de Erro (404):**
```json
{
  "message": "Email não encontrado em nossa base de dados."
}
```

### 2. Validar Token
**GET** `/api/password_resets/:token/validate`

Valida se o token de reset é válido e não expirou.

**Resposta de Sucesso (200):**
```json
{
  "valid": true,
  "email": "usuario@example.com",
  "message": "Token válido"
}
```

**Resposta de Erro (422):**
```json
{
  "valid": false,
  "message": "Token inválido ou expirado"
}
```

### 3. Alterar Senha
**PATCH** `/api/password_resets/:token`

Altera a senha usando o token de reset.

**Parâmetros:**
```json
{
  "password": "nova_senha123",
  "password_confirmation": "nova_senha123"
}
```

**Resposta de Sucesso (200):**
```json
{
  "message": "Senha alterada com sucesso!"
}
```

**Resposta de Erro (422):**
```json
{
  "message": "Token inválido ou expirado"
}
```

ou

```json
{
  "message": "Senha deve ter pelo menos 6 caracteres"
}
```

## Fluxo Completo

1. **Usuário solicita reset**: Envia email para `/api/password_resets`
2. **Sistema gera token**: Cria token único e envia email
3. **Usuário recebe email**: Com link contendo o token
4. **Frontend valida token**: Chama `/api/password_resets/:token/validate`
5. **Usuário define nova senha**: Chama `/api/password_resets/:token` com nova senha
6. **Sistema atualiza senha**: Limpa token e atualiza senha

## Configuração

### Variáveis de Ambiente

```bash
# URL do frontend para gerar links de reset
FRONTEND_URL=http://localhost:3000

# Configurações de email (produção)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=seu-email@gmail.com
SMTP_PASSWORD=sua-senha-de-app
```

### Configuração de Email em Produção

No arquivo `config/environments/production.rb`:

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: ENV['SMTP_HOST'],
  port: ENV['SMTP_PORT'],
  domain: ENV['SMTP_DOMAIN'],
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

## Segurança

- **Token único**: Cada token é gerado com `SecureRandom.urlsafe_base64(32)`
- **Expiração**: Tokens expiram em 1 hora
- **Uso único**: Token é limpo após uso
- **Validação**: Senha deve ter pelo menos 6 caracteres
- **Confirmação**: Senha deve ser confirmada

## Testes

Execute os testes do reset de senha:

```bash
bin/rails test test/controllers/api/password_resets_controller_test.rb
```

## Exemplo de Uso no Frontend

### React/JavaScript

```javascript
// 1. Solicitar reset
const requestReset = async (email) => {
  const response = await fetch('/api/password_resets', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email })
  });
  return response.json();
};

// 2. Validar token
const validateToken = async (token) => {
  const response = await fetch(`/api/password_resets/${token}/validate`);
  return response.json();
};

// 3. Alterar senha
const resetPassword = async (token, password, passwordConfirmation) => {
  const response = await fetch(`/api/password_resets/${token}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ password, password_confirmation: passwordConfirmation })
  });
  return response.json();
};
```

## Troubleshooting

### Email não está sendo enviado
1. Verificar configuração SMTP
2. Verificar logs da aplicação
3. Em desenvolvimento, usar `letter_opener` para visualizar emails

### Token inválido
1. Verificar se o token não expirou (1 hora)
2. Verificar se o token foi usado apenas uma vez
3. Verificar se o token está correto na URL

### Erro de validação de senha
1. Senha deve ter pelo menos 6 caracteres
2. Senha e confirmação devem ser iguais
3. Verificar se não há caracteres especiais problemáticos 