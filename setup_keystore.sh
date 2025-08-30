#!/bin/bash

# Seedfy App - Keystore & Secrets Setup Helper
# Este script ajuda a gerar keystores e configurar secrets do GitHub

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}🔑 Seedfy Keystore Setup Helper${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

print_step() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if keytool is available
check_keytool() {
    if ! command -v keytool &> /dev/null; then
        print_error "keytool não encontrado. Certifique-se de que o Java JDK está instalado."
        echo "Para instalar no macOS: brew install openjdk"
        echo "Para instalar no Ubuntu: sudo apt install openjdk-11-jdk"
        exit 1
    fi
}

# Generate keystore
generate_keystore() {
    print_step "Gerando keystore para assinatura da aplicação..."

    read -p "Nome da empresa/desenvolvedor: " DEVELOPER_NAME
    read -p "Nome da organização: " ORGANIZATION
    read -p "Cidade: " CITY
    read -p "Estado: " STATE
    read -p "País (código de 2 letras, ex: BR): " COUNTRY

    echo ""
    print_warning "IMPORTANTE: Lembre-se das senhas! Você precisará delas para configurar o CI/CD."

    # Generate keystore
    keytool -genkey -v -keystore upload-keystore.jks \
        -keyalg RSA -keysize 2048 -validity 10000 \
        -alias upload \
        -dname "CN=$DEVELOPER_NAME, OU=$ORGANIZATION, L=$CITY, S=$STATE, C=$COUNTRY"

    print_step "Keystore gerado: upload-keystore.jks"

    # Create sample key.properties
    cat > key.properties.sample << EOF
# Exemplo de arquivo key.properties
# NUNCA commite este arquivo no Git!
storePassword=SUA_SENHA_DO_KEYSTORE
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=upload
storeFile=upload-keystore.jks
EOF

    print_step "Arquivo de exemplo criado: key.properties.sample"
}

# Generate GitHub Secrets
generate_secrets() {
    print_step "Gerando valores para GitHub Secrets..."

    if [ ! -f "upload-keystore.jks" ]; then
        print_error "Keystore não encontrado. Execute a opção 1 primeiro."
        return
    fi

    # Convert keystore to base64
    KEYSTORE_BASE64=$(base64 -i upload-keystore.jks)

    # Convert google-services.json to base64 if exists
    if [ -f "android/app/google-services.json" ]; then
        GOOGLE_SERVICES_BASE64=$(base64 -i android/app/google-services.json)
    fi

    echo ""
    print_info "Configure os seguintes secrets no GitHub:"
    print_info "Repository Settings > Secrets and variables > Actions > New repository secret"
    echo ""

    echo "KEYSTORE_BASE64:"
    echo "$KEYSTORE_BASE64"
    echo ""

    echo "STORE_PASSWORD:"
    read -s -p "Digite a senha do keystore: " STORE_PASSWORD
    echo "$STORE_PASSWORD"
    echo ""

    echo "KEY_PASSWORD:"
    read -s -p "Digite a senha da chave: " KEY_PASSWORD
    echo "$KEY_PASSWORD"
    echo ""

    echo "KEY_ALIAS:"
    echo "upload"
    echo ""

    if [ ! -z "$GOOGLE_SERVICES_BASE64" ]; then
        echo "GOOGLE_SERVICES_JSON_BASE64:"
        echo "$GOOGLE_SERVICES_BASE64"
        echo ""
    fi

    # Save to file for reference
    cat > github_secrets.txt << EOF
# GitHub Secrets para Seedfy App
# Configure estes valores em: Repository Settings > Secrets and variables > Actions

KEYSTORE_BASE64=$KEYSTORE_BASE64

STORE_PASSWORD=$STORE_PASSWORD

KEY_PASSWORD=$KEY_PASSWORD

KEY_ALIAS=upload

EOF

    if [ ! -z "$GOOGLE_SERVICES_BASE64" ]; then
        echo "GOOGLE_SERVICES_JSON_BASE64=$GOOGLE_SERVICES_BASE64" >> github_secrets.txt
    fi

    print_step "Secrets salvos em: github_secrets.txt"
    print_warning "IMPORTANTE: Não commite o arquivo github_secrets.txt!"
}

# Test keystore
test_keystore() {
    if [ ! -f "upload-keystore.jks" ]; then
        print_error "Keystore não encontrado."
        return
    fi

    print_step "Testando keystore..."
    keytool -list -v -keystore upload-keystore.jks -alias upload
}

# Clean up
cleanup() {
    print_warning "Limpando arquivos sensíveis..."

    files_to_clean=("upload-keystore.jks" "key.properties" "github_secrets.txt")

    for file in "${files_to_clean[@]}"; do
        if [ -f "$file" ]; then
            echo "Remover $file? (y/N)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                rm "$file"
                print_step "Removido: $file"
            fi
        fi
    done
}

# Main menu
main_menu() {
    while true; do
        print_header
        echo "Escolha uma opção:"
        echo "1) Gerar novo keystore"
        echo "2) Gerar GitHub Secrets (base64)"
        echo "3) Testar keystore existente"
        echo "4) Limpar arquivos sensíveis"
        echo "5) Sair"
        echo ""
        read -p "Digite sua escolha (1-5): " choice

        case $choice in
            1)
                check_keytool
                generate_keystore
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            2)
                generate_secrets
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            3)
                test_keystore
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            4)
                cleanup
                echo ""
                read -p "Pressione Enter para continuar..."
                ;;
            5)
                print_step "Saindo..."
                exit 0
                ;;
            *)
                print_error "Opção inválida"
                sleep 1
                ;;
        esac
    done
}

# Run main menu
main_menu
