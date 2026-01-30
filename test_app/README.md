# SPED Viewer Test App

Este é um aplicativo de teste para o pacote `sped_viewer`, que permite visualizar documentos fiscais brasileiros (NF-e e CT-e) em formato PDF.

## Visão Geral

Este aplicativo demonstra a funcionalidade do pacote `sped_viewer`, permitindo gerar e visualizar representações em PDF de:

- Nota Fiscal Eletrônica (NF-e)
- Conhecimento de Transporte Eletrônico (CT-e)

## Como Usar

1. Certifique-se de que o pacote `sped_viewer` está configurado corretamente no diretório `../`
2. Execute o aplicativo Flutter:

```bash
flutter pub get
flutter run
```

3. Na tela inicial, selecione uma das opções:
   - "Visualizar NF-e de Exemplo" para gerar um PDF de exemplo de NF-e
   - "Visualizar CT-e de Exemplo" para gerar um PDF de exemplo de CT-e

## Estrutura do Projeto

- `lib/main.dart` - Código principal do aplicativo de teste

## Funcionalidades

- Geração de PDF para NF-e com todos os campos relevantes
- Geração de PDF para CT-e com campos específicos para transporte
- Interface simples com botões para selecionar o tipo de documento
- Tratamento de erros durante a geração do PDF

## Observações

- Este é um aplicativo de demonstração para testar o pacote `sped_viewer`
- Em uma aplicação real, você integraria o pacote diretamente em seu projeto
- O pacote `sped_viewer` é completamente desacoplado e opera apenas com modelos de dados Dart