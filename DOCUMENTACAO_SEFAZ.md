# Documentação do Pacote SPED Viewer - Layout SEFAZ

## Visão Geral

O pacote `sped_fiscal_viewer` foi atualizado para gerar documentos fiscais (NF-e e CT-e) em conformidade com os layouts aprovados pela SEFAZ. Esta atualização corrige o problema onde os PDFs gerados não condiziam com o layout oficial estabelecido pela SEFAZ.

## Novas Implementações

### DanfeSefazPrinter

Implementação aprimorada do DANFE (Documento Auxiliar da Nota Fiscal Eletrônica) que segue o layout oficial SEFAZ:

- **Cabeçalho**: Inclui espaço para logo, informações do emitente e título DANFE conforme especificações oficiais
- **Tabela de Itens**: Colunas corretas com larguras apropriadas para código, descrição, NCM, CST, CFOP, unidade, quantidade, valores unitário e total
- **Totais**: Cálculos corretos de ICMS, IPI, PIS, COFINS e valores totais
- **Transporte**: Todos os campos obrigatórios para informações de transporte
- **Dados Adicionais**: Seção para informações complementares e reservada ao fisco

### DacteSefazPrinter

Implementação do DACTE (Documento Auxiliar do Conhecimento de Transporte Eletrônico) que segue o layout oficial SEFAZ:

- **Cabeçalho**: Inclui espaço para logo, informações do emitente e título DACTE conforme especificações oficiais
- **Tabela de Itens**: Colunas apropriadas para CT-e com descrição de serviços
- **Totais**: Cálculos específicos para CT-e, incluindo valores de serviço e tributos
- **Transporte**: Campos específicos para transporte de cargas
- **Dados Adicionais**: Seção para informações complementares e reservada ao fisco

## Diferenças em Relação à Implementação Anterior

A implementação anterior (`DanfePrinter`) tinha uma estrutura básica que não seguia as especificações oficiais da SEFAZ. As principais diferenças nas novas implementações incluem:

- **Estrutura de layout**: Segue exatamente o formato estabelecido pela SEFAZ
- **Campos obrigatórios**: Todos os campos obrigatórios estão presentes e corretamente posicionados
- **Formatação**: Estilo e formatação consistentes com os documentos oficiais
- **Tamanhos e proporções**: Respeita as proporções e tamanhos estabelecidos nas especificações
- **Tipografia**: Fontes Helvetica/Sans-Serif com tamanhos adequados (títulos: 6pt a 7pt, dados: 8pt a 9pt)
- **Margens**: Margens de 1cm (10mm) conforme padrão SEFAZ
- **Preenchimento de página**: Lógica implementada para preencher a página com espaços vazios quando necessário, garantindo que o rodapé fique posicionado corretamente no final da página
- **Código de barras**: Utiliza pw.BarcodeWidget com pw.Barcode.code128() para a Chave de Acesso (44 dígitos)
- **Tamanho do documento**: Documentos ocupam o tamanho mínimo de um papel A4

## Uso

Para gerar DANFE SEFAZ-compliant:

```dart
final danfePrinter = DanfeSefazPrinter(documentoNfe);
final pdf = await danfePrinter.generate();
```

Para gerar DACTE SEFAZ-compliant:

```dart
final dactePrinter = DacteSefazPrinter(documentoCte);
final pdf = await dactePrinter.generate();
```

## Testes

Ambas as implementações foram testadas com dados de exemplo e geram PDFs que seguem as especificações SEFAZ. Os arquivos de teste `test_package.dart` e `test_cte_package.dart` demonstram o uso das novas implementações.

## Conformidade

As implementações seguem as especificações da SEFAZ conforme definido no projeto de referência PHP `sped-da` (NFePHP), garantindo que os documentos gerados sejam válidos para uso oficial.