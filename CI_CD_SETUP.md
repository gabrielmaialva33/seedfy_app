# Seedfy App CI/CD Pipeline - Guia Completo

Este documento explica como configurar e usar o pipeline de CI/CD otimizado para construir APKs do Seedfy App, baseado nas melhores práticas do Flutter.

## 🚀 Novidades e Melhorias

### ✨ Implementado baseado em pesquisa das melhores práticas:
- **Java 17**: Atualizado para versão mais recente e estável
- **App Bundle (.aab)**: Formato preferido pela Google Play Store
- **Multi-arquitetura**: Suporte a ARM64, ARM32 e x86_64
- **Keystore automático**: Sistema seguro de assinatura
- **Deploy automático**: Integração com Google Play Store
- **Validações robustas**: Análise de código com `--fatal-infos`

## 📋 Workflows Disponíveis

### 1. Build APK (`build-apk.yml`) - ⚡ Melhorado
- **Triggers**: Push para `main` ou `develop`, Pull Requests para `main`, ou execução manual
- **Novas Funcionalidades**:
  - ✅ Java 17 (versão LTS mais recente)
  - ✅ Builds para múltiplas arquiteturas (ARM64, ARM32, x86_64)
  - ✅ App Bundle (.aab) - preferido pela Google Play
  - ✅ Cache otimizado com Flutter dependencies
  - ✅ Análise rigorosa com `--fatal-infos`
  - ✅ Artifacts numerados com retenção configurável
  - ✅ Releases com informações detalhadas

### 2. Build Signed APK (`build-signed-apk.yml`) - 🔐 Otimizado
- **Triggers**: Criação de release ou execução manual
- **Novas Funcionalidades**:
  - ✅ Validação de keystore obrigatória
  - ✅ Versioning dinâmico via input manual
  - ✅ Deploy direto para Google Play Store (opcional)
  - ✅ Verificação adicional de assinatura com apksigner
  - ✅ Build summary detalhado
  - ✅ Retenção de artifacts por 1 ano

## 🔧 Configuração Necessária

### GitHub Secrets Obrigatórios

#### Para APK Assinado (Produção)
```
KEYSTORE_BASE64          # Base64 do keystore.jks
STORE_PASSWORD           # Senha do keystore
KEY_PASSWORD             # Senha da chave
KEY_ALIAS               # Alias da chave (padrão: upload)
```

#### Para Firebase (Opcional)
```
GOOGLE_SERVICES_JSON_BASE64    # Base64 do google-services.json
```

#### Para Deploy na Google Play (Opcional)
```
GOOGLE_PLAY_SERVICE_ACCOUNT_JSON    # JSON da conta de serviço
```

### 🛠️ Scripts Auxiliares Incluídos

#### 1. Script de Setup de Keystore (`setup_keystore.sh`)
Script interativo para gerar keystore e configurar secrets:

```bash
./setup_keystore.sh
```

**Funcionalidades:**
- ✅ Gerar keystore com validação
- ✅ Converter arquivos para base64
- ✅ Gerar todos os secrets necessários
- ✅ Testar keystore existente
- ✅ Limpeza segura de arquivos

#### 2. Script de Build Local (`build_local.sh`)
Script para testar builds localmente:

```bash
./build_local.sh
```

**Funcionalidades:**
- ✅ Validação completa do ambiente
- ✅ Execução dos mesmos comandos do CI/CD
- ✅ Builds múltiplos (Debug, Release, AAB)
- ✅ Relatório de tamanhos de arquivo

## 🏗️ Configuração do Android Build

### Melhorias no `build.gradle.kts`
- ✅ Suporte adequado a keystore com fallback seguro
- ✅ Configuração condicional de signing
- ✅ Imports corretos para Properties e FileInputStream
- ✅ Build types otimizados

### Estrutura do key.properties
```properties
storePassword=sua_senha_do_keystore
keyPassword=sua_senha_da_chave  
keyAlias=upload
storeFile=keystore.jks
```

## 🚀 Como Usar

### 🔄 Build Automático
1. **Push para `main`**: Build completo + Release automático
2. **Push para `develop`**: Build e testes apenas
3. **Pull Request**: Validação completa com análise

### 🎯 Build Manual Assinado
1. Acesse Actions → "Build Signed APK"
2. Clique "Run workflow"
3. Configure:
   - **Version**: Número da versão (ex: 1.0.1)
   - **Deploy to Play Store**: true/false

### 📱 Deploy para Google Play
Configuração para deploy automático no internal track:
- ✅ Upload automático de App Bundle
- ✅ Track interno para testes
- ✅ Controle manual de deploy

## 📊 Tipos de Build e Tamanhos

### Debug APK (~25-35 MB)
- Para desenvolvimento e debug
- Não otimizado, permite debugging
- Suporta hot reload

### Release APK (~15-25 MB) 
- Otimizado para produção
- Código minificado
- Pronto para distribuição

### App Bundle (.aab) (~12-20 MB)
- **Formato preferido pela Google Play**
- Tamanho de download menor
- Otimização automática por device

## 🔍 Troubleshooting Avançado

### Erro "KEYSTORE_BASE64 secret is required"
```bash
# Use o script auxiliar:
./setup_keystore.sh

# Ou gere manualmente:
base64 -i upload-keystore.jks | pbcopy
```

### Erro de signing no build
```bash
# Verifique os secrets:
echo $KEYSTORE_BASE64 | base64 -d > test-keystore.jks
keytool -list -v -keystore test-keystore.jks
```

### Build falhando por dependências
```bash
# Limpe o cache local:
flutter clean && flutter pub get
rm -rf ~/.pub-cache/hosted/pub.dartlang.org
```

## 📈 Monitoramento e Analytics

### Build Artifacts
- **Debug APK**: Retenção de 30 dias
- **Release APK/AAB**: Retenção de 90 dias  
- **Signed builds**: Retenção de 365 dias

### Build Summary
Cada build gera um relatório detalhado com:
- ✅ Versão e número do build
- ✅ Tamanho dos artifacts
- ✅ Arquiteturas suportadas
- ✅ Status do deploy (se habilitado)

## 🔐 Segurança

### Arquivos Protegidos (.gitignore)
```
android/key.properties
android/app/keystore.jks
*.keystore
*.jks
github_secrets.txt
```

### Melhores Práticas
- ✅ Nunca commitar keystores ou senhas
- ✅ Usar GitHub Secrets para dados sensíveis
- ✅ Rotacionar keystores periodicamente
- ✅ Backup seguro de keystores

## 🎯 Próximos Passos

1. **Configure os secrets** usando `./setup_keystore.sh`
2. **Teste localmente** com `./build_local.sh`
3. **Faça commit** e push para testar o pipeline
4. **Configure Google Play** (opcional) para deploy automático

## 📞 Suporte

- 📖 Documentação oficial: [Flutter Build & Release](https://docs.flutter.dev/deployment/android)
- 🔧 Scripts auxiliares incluídos para troubleshooting
- 🚀 Pipeline testado com as melhores práticas da comunidade

---

**Pipeline otimizado com pesquisa de melhores práticas ✨**
