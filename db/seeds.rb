# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Usuários só para desenvolvimento local / testes da equipe.
# Senha padrão: pelo menos 8 caracteres, uma maiúscula e uma minúscula (validação do modelo User).
seed_password = ENV.fetch("SEED_USER_PASSWORD", "Senha123")

[
  { email: "admin@preifma.local", name: "Admin (seed)", type_user: :admin },
  { email: "aluno@preifma.local", name: "Aluno (seed)", type_user: :student }
].each do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |user|
    user.name = attrs[:name]
    user.type_user = attrs[:type_user]
    user.password = seed_password
  end
end

Rails.logger.info { "[seeds] Usuários de exemplo criados (ou já existiam). E-mail: admin@preifma.local / aluno@preifma.local" }
