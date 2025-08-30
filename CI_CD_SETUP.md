# Seedfy App CI/CD Pipeline

Este documento explica como configurar e usar o pipeline de CI/CD para construir APKs do Seedfy App.

## 📋 Workflows Disponíveis

### 1. Build APK (`build-apk.yml`)
- **Trigger**: Push para `main` ou `develop`, Pull Requests para `main`, ou execução manual
- **Funcionalidades**:
  - Análise de código com `flutter analyze`
  - Execução de testes com `flutter test`
  - Build de APK debug e release
  - Upload de artefatos
  - Criação automática de releases (apenas no branch `main`)

### 2. Build Signed APK (`build-signed-apk.yml`)
- **Trigger**: Criação de release ou execução manual
- **Funcionalidades**:
  - Build de APK assinado para produção
  - Build de App Bundle (.aab) para Google Play Store
  - Suporte a versioning customizado

## 🔧 Configuração Necessária

### Secrets do GitHub
Configure os seguintes secrets no seu repositório GitHub (Settings > Secrets and variables > Actions):

#### Para Firebase (Opcional)
```
FIREBASE_CONFIG_BASE64    # Base64 do arquivo google-services.json
GOOGLE_SERVICES_BASE64    # Base64 do arquivo google-services.json (backup)
```

#### Para APK Assinado (Necessário para produção)
```
KEYSTORE_BASE64          # Base64 do arquivo keystore.jks
STORE_PASSWORD           # Senha do keystore
KEY_PASSWORD             # Senha da chave
KEY_ALIAS               # Alias da chave
```

### Como gerar os secrets:

#### Firebase Config:
```bash
# Na pasta do projeto
base64 -i android/app/google-services.json | pbcopy
```

#### Keystore (para APK assinado):
```bash
# Gerar keystore (se não existir)
keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# Converter para Base64
base64 -i keystore.jks | pbcopy
```

## 🚀 Como Usar

### Build Automático
1. **Push para `main` ou `develop`**: Automaticamente builda e cria artefatos
2. **Pull Request para `main`**: Roda testes e análise de código
3. **Push para `main`**: Cria release automática com APKs

### Build Manual
1. Vá para Actions no GitHub
2. Selecione "Build APK" ou "Build Signed APK"
3. Clique em "Run workflow"
4. Para builds assinados, especifique a versão desejada

### Downloads
- **Artefatos**: Disponíveis na página da execução do workflow
- **Releases**: Página de releases do repositório (builds automáticos do `main`)

## 📱 Tipos de Build

### Debug APK
- Para desenvolvimento e testes
- Não requer assinatura
- Permite debugging
- Arquivo: `app-debug.apk`

### Release APK
- Para produção
- Otimizado e minificado
- Arquivo: `app-release.apk`

### App Bundle (.aab)
- Format preferido para Google Play Store
- Menor tamanho de download
- Arquivo: `app-release.aab`

## 🔍 Troubleshooting

### Erro "google-services.json not found"
- Configure o secret `FIREBASE_CONFIG_BASE64`
- Ou adicione o arquivo diretamente ao repositório (não recomendado)

### Erro de assinatura
- Verifique se todos os secrets de keystore estão configurados
- Confirme se o keystore é válido

### Falha nos testes
- Execute `flutter test` localmente para identificar problemas
- Corrija os testes antes do push

## 📊 Monitoramento

- **Actions**: Acompanhe builds em tempo real
- **Artifacts**: Downloads disponíveis por 90 dias
- **Releases**: Histórico de versões com changelogs automáticos

## 🏗️ Estrutura dos Workflows

```
.github/
├── workflows/

│   └── build-signed-apk.yml    # Build assinado para produção
```

## 📝 Versioning

O sistema usa semantic versioning:
- `major.minor.patch+build`
- Build number é incrementado automaticamente
- Para builds manuais, você pode especificar a versão

Exemplo: `1.0.0+123` onde `123` é o número do build do GitHub Actions.
