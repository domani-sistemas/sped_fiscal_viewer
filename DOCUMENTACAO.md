# Documentação do Pacote SPED Viewer

## Visão Geral

O pacote `sped_fiscal_viewer` é uma solução modular para geração de representações em PDF de documentos fiscais brasileiros, incluindo NF-e (Nota Fiscal Eletrônica) e CT-e (Conhecimento de Transporte Eletrônico).

## Estrutura do Pacote

O pacote inclui implementações para geração de DANFE (NF-e) e DACTE (CT-e) em conformidade com os layouts aprovados pela SEFAZ:

- `DanfeSefazPrinter`: Impressora SEFAZ-compliant para NF-e
- `DacteSefazPrinter`: Impressora SEFAZ-compliant para CT-e
- `DanfePrinter`: Implementação anterior (mantida para compatibilidade)

## Estrutura do Pacote

```
sped_viewer/
├── lib/
│   ├── src/
│   │   ├── models/
│   │   │   ├── documento_fiscal.dart
│   │   │   ├── item_documento.dart
│   │   │   ├── participante.dart
│   │   │   ├── transporte.dart
│   │   │   └── impostos.dart
│   │   └── printers/
│   │       └── danfe_printer.dart
│   └── sped_viewer.dart
├── test_app/
│   ├── lib/main.dart
│   └── pubspec.yaml
├── test_package.dart
├── test_cte_package.dart
└── README.md
```

## Modelos de Dados

O pacote inclui os seguintes modelos de dados:

- `DocumentoFiscal`: Representa um documento fiscal genérico (NFe, CTe, NFCe, etc.)
- `ItemDocumentoFiscal`: Representa um item no documento fiscal
- `Participante`: Representa emitente ou destinatário
- `Transporte`: Informações de transporte
- `Impostos`: Informações de impostos

## Impressora Disponível

- `DanfePrinter`: Gera o DANFE para NF-e e adaptações para CT-e

## Como Testar o Pacote

### 1. Teste Unitário Simples

Execute os testes unitários para verificar a funcionalidade:

```bash
dart test_package.dart
```

Este comando criará um PDF de exemplo de NF-e e salvará como `teste_nfe.pdf`.

```bash
dart test_cte_package.dart
```

Este comando criará um PDF de exemplo de CT-e e salvará como `teste_cte.pdf`.

### 2. Aplicativo de Teste Flutter (Melhorado)

O pacote inclui um aplicativo de teste Flutter com visualização direta de PDFs:

1. Navegue até o diretório do aplicativo de teste:
```bash
cd test_app
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

O aplicativo oferece opções para gerar e visualizar exemplos de NF-e e CT-e com:

- Visualização direta do PDF gerado
- Informações detalhadas sobre o arquivo (nome, caminho e tamanho)
- Interface intuitiva para testar ambos os tipos de documentos
- Armazenamento local dos arquivos PDF gerados

## Exemplo de Uso

### Importação

```dart
import 'package:sped_viewer/sped_viewer.dart';
```

### Criando um Documento Fiscal

```dart
final documento = DocumentoFiscal(
  id: 1,
  idEstabelecimento: 1,
  chaveAcesso: '12345678901234567890123456789012345678901234',
  tipoDocumento: 'NFE', // ou 'CTE'
  modelo: '55', // 55 para NF-e, 57 para CT-e
  serie: '1',
  numeroDocumento: 123,
  dataEmissao: DateTime.now(),
  cfopPrincipal: 5101,
  tipoOperacao: 'S', // 'S' para saída, 'E' para entrada
  emitente: Participante(
    cnpj: '12345678000195',
    nome: 'Empresa Exemplo Ltda',
    // ... outros campos
  ),
  destinatario: Participante(
    cnpj: '98765432000195',
    nome: 'Cliente Exemplo SA',
    // ... outros campos
  ),
  valorTotalNota: 1000.00,
  itens: [
    ItemDocumentoFiscal(
      id: 1,
      idDocumentoFiscal: 1,
      numeroItem: 1,
      descricaoProduto: 'Produto Exemplo',
      unidade: 'UN',
      quantidade: 10,
      valorUnitario: 100.00,
      valorTotalItem: 1000.00,
      cfop: 5101,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ],
  transporte: Transporte(
    // ... informações de transporte
  ),
  impostos: Impostos(
    // ... informações de impostos
  ),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

### Gerando o PDF

```dart
final danfePrinter = DanfePrinter(documento);
final pdf = await danfePrinter.generate();
final bytes = await pdf.save();

// Agora você pode salvar ou exibir o PDF
```

## Personalização

O pacote foi projetado para ser flexível e personalizável:

- Os modelos de dados são extensíveis para acomodar diferentes tipos de documentos fiscais
- A impressora pode ser estendida para suportar diferentes formatos e layouts
- O código está estruturado para facilitar a adição de novos tipos de documentos (NFC-e, CC-e, etc.)

## Melhorias Futuras

- Adicionar suporte para NFC-e (Nota Fiscal do Consumidor Eletrônica)
- Adicionar suporte para CC-e (Carta de Correção Eletrônica)
- Implementar layouts específicos para CT-e
- Adicionar mais opções de personalização de layout
- Melhorar a renderização de tabelas com muitos itens
- Adicionar suporte para múltiplas páginas em documentos longos

## Solução de Problemas

Se encontrar problemas ao gerar PDFs:

1. Verifique se todos os campos obrigatórios estão preenchidos
2. Confirme que os valores numéricos estão no formato correto
3. Verifique se os dados de endereço estão formatados corretamente
4. Certifique-se de que as datas estão no formato adequado

## Contribuindo

Para contribuir com o pacote:

1. Faça um fork do repositório
2. Crie um branch para sua feature (`git checkout -b feature/NovaFeature`)
3. Faça commit das suas alterações (`git commit -m 'Adiciona NovaFeature'`)
4. Faça push para o branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request