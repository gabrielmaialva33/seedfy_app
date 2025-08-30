#!/bin/bash

# Seedfy App Build Script
# This script runs the same commands as the CI/CD pipeline for local testing

set -e

echo "🚀 Seedfy App Build Script"
echo "=========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter não está instalado ou não está no PATH"
    exit 1
fi

print_step "Verificando versão do Flutter..."
flutter --version

print_step "Instalando dependências..."
flutter pub get

print_step "Analisando código..."
flutter analyze

print_step "Executando testes..."
if flutter test; then
    print_step "Todos os testes passaram!"
else
    print_warning "Alguns testes falharam, mas continuando com o build..."
fi

print_step "Limpando builds anteriores..."
flutter clean
flutter pub get

# Build options
echo ""
echo "Escolha o tipo de build:"
echo "1) Debug APK"
echo "2) Release APK"
echo "3) App Bundle (AAB)"
echo "4) Todos"
read -p "Digite sua escolha (1-4): " choice

case $choice in
    1)
        print_step "Buildando Debug APK..."
        flutter build apk --debug
        print_step "Debug APK criado em: build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    2)
        print_step "Buildando Release APK..."
        flutter build apk --release
        print_step "Release APK criado em: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    3)
        print_step "Buildando App Bundle..."
        flutter build appbundle --release
        print_step "App Bundle criado em: build/app/outputs/bundle/release/app-release.aab"
        ;;
    4)
        print_step "Buildando Debug APK..."
        flutter build apk --debug

        print_step "Buildando Release APK..."
        flutter build apk --release

        print_step "Buildando App Bundle..."
        flutter build appbundle --release

        echo ""
        print_step "Todos os builds concluídos:"
        echo "  - Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
        echo "  - Release APK: build/app/outputs/flutter-apk/app-release.apk"
        echo "  - App Bundle: build/app/outputs/bundle/release/app-release.aab"
        ;;
    *)
        print_error "Opção inválida"
        exit 1
        ;;
esac

echo ""
print_step "Build concluído com sucesso! 🎉"

# Show file sizes
echo ""
echo "Tamanhos dos arquivos:"
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    ls -lh build/app/outputs/flutter-apk/app-debug.apk | awk '{print "Debug APK: " $5}'
fi
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    ls -lh build/app/outputs/flutter-apk/app-release.apk | awk '{print "Release APK: " $5}'
fi
if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
    ls -lh build/app/outputs/bundle/release/app-release.aab | awk '{print "App Bundle: " $5}'
fi
