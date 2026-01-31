import 'package:flutter/material.dart';
import 'package:sped_viewer/sped_viewer.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';

void main() {
  runApp(const SpedViewerTestApp());
}

class SpedViewerTestApp extends StatelessWidget {
  const SpedViewerTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPED Viewer Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SpedViewerTestScreen(),
    );
  }
}

class SpedViewerTestScreen extends StatefulWidget {
  const SpedViewerTestScreen({super.key});

  @override
  State<SpedViewerTestScreen> createState() => _SpedViewerTestScreenState();
}

class _SpedViewerTestScreenState extends State<SpedViewerTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPED Viewer Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selecione o tipo de documento para visualizar:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _gerarPdfNfe,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Visualizar NF-e de Exemplo',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _gerarPdfCte,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Visualizar CT-e de Exemplo',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _gerarPdfNfe() async {
    try {
      // Criar um documento fiscal de exemplo (NF-e)
      final documentoNfe = _criarDocumentoNfeExemplo();

      // Gerar o PDF com o novo layout SEFAZ
      final danfePrinter = DanfeSefazPrinter(documentoNfe);
      final pdf = await danfePrinter.generate();

      // Converter para bytes
      final bytes = await pdf.save();

      // Salvar o PDF e exibir
      await _exibirPdf(bytes, 'NF-e_SEFAZ_Exemplo.pdf',
          (format) async => (await danfePrinter.generate()).save());
    } catch (e) {
      if (!mounted) return;
      _mostrarErro('Erro ao gerar NF-e: $e');
    }
  }

  void _gerarPdfCte() async {
    try {
      // Criar um documento fiscal de exemplo (CT-e)
      final documentoCte = _criarDocumentoCteExemplo();

      // Gerar o PDF com o novo layout SEFAZ para CT-e
      final dactePrinter = DacteSefazPrinter(documentoCte);
      final pdf = await dactePrinter.generate();

      // Converter para bytes
      final bytes = await pdf.save();

      // Salvar o PDF e exibir
      await _exibirPdf(bytes, 'CT-e_SEFAZ_Exemplo.pdf',
          (format) async => (await dactePrinter.generate()).save());
    } catch (e) {
      if (!mounted) return;
      _mostrarErro('Erro ao gerar CT-e: $e');
    }
  }

  DocumentoFiscal _criarDocumentoNfeExemplo() {
    return DocumentoFiscal(
      id: 1,
      idEstabelecimento: 1,
      chaveAcesso: '12345678901234567890123456789012345678901234',
      tipoDocumento: 'NFE',
      modelo: '55',
      serie: '1',
      numeroDocumento: 123,
      dataEmissao: DateTime.now(),
      cfopPrincipal: 5101,
      tipoOperacao: 'S',
      emitente: const Participante(
        cnpj: '12345678000195',
        nome: 'Empresa Exemplo Ltda',
        enderecoLogradouro: 'Rua Exemplo',
        enderecoNumero: '123',
        enderecoBairro: 'Centro',
        enderecoMunicipio: 'São Paulo',
        enderecoUf: 'SP',
        enderecoCep: '01001000',
        enderecoTelefone: '(11) 99999-9999',
        ie: '123456789',
      ),
      destinatario: const Participante(
        cnpj: '98765432000195',
        nome: 'Cliente Exemplo SA',
        enderecoLogradouro: 'Av. Exemplo',
        enderecoNumero: '456',
        enderecoBairro: 'Comercial',
        enderecoMunicipio: 'Rio de Janeiro',
        enderecoUf: 'RJ',
        enderecoCep: '20010000',
        enderecoTelefone: '(21) 98888-7777',
      ),
      valorBaseCalculoIcms: 1000.00,
      valorIcms: 180.00,
      valorIpi: 50.00,
      valorPis: 6.50,
      valorCofins: 30.00,
      valorTotalProdutos: 1000.00,
      valorTotalNota: 1266.50,
      status: 'ATIVA',
      itens: [
        ItemDocumentoFiscal(
          id: 1,
          idDocumentoFiscal: 1,
          numeroItem: 1,
          codigoProduto: 'PROD001',
          descricaoProduto: 'Produto Exemplo 1',
          ncm: '12345678',
          cst: '00',
          cfop: 5101,
          unidade: 'UN',
          quantidade: 10,
          valorUnitario: 100.00,
          valorTotalItem: 1000.00,
          baseCalculoIcms: 1000.00,
          valorIcms: 180.00,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ItemDocumentoFiscal(
          id: 2,
          idDocumentoFiscal: 1,
          numeroItem: 2,
          codigoProduto: 'PROD002',
          descricaoProduto: 'Produto Exemplo 2',
          ncm: '87654321',
          cst: '00',
          cfop: 5101,
          unidade: 'KG',
          quantidade: 5,
          valorUnitario: 50.00,
          valorTotalItem: 250.00,
          baseCalculoIcms: 250.00,
          valorIcms: 45.00,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
      transporte: const Transporte(
        modalidadeFrete: '0',
        cnpjTransportador: '11222333000145',
        nomeTransportador: 'Transportadora Exemplo',
        enderecoTransportador: 'Rua Transporte, 789',
        municipioTransportador: 'Campinas',
        ufTransportador: 'SP',
        placaVeiculo: 'ABC1D23',
        ufVeiculo: 'SP',
        rntcVeiculo: '12345678',
        quantidadeVolumes: '15',
        especieVolumes: 'CAIXAS',
        marcaVolumes: 'N/D',
        numeracaoVolumes: '1-15',
        pesoLiquido: 100.0,
        pesoBruto: 120.0,
      ),
      impostos: const Impostos(
        valorTotalTributos: 446.50,
        baseCalculoIcms: 1250.00,
        valorIcms: 225.00,
        valorIpi: 50.00,
        valorPis: 6.50,
        valorCofins: 30.00,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  DocumentoFiscal _criarDocumentoCteExemplo() {
    return DocumentoFiscal(
      id: 2,
      idEstabelecimento: 1,
      chaveAcesso: '55231234567890123456789012345678901234567890',
      tipoDocumento: 'CTE',
      modelo: '57',
      serie: '1',
      numeroDocumento: 456,
      dataEmissao: DateTime.now(),
      cfopPrincipal: 5351,
      tipoOperacao: 'S',
      emitente: const Participante(
        cnpj: '12345678000195',
        nome: 'Transportadora Exemplo Ltda',
        enderecoLogradouro: 'Av. Transporte',
        enderecoNumero: '100',
        enderecoBairro: 'Industrial',
        enderecoMunicipio: 'São Paulo',
        enderecoUf: 'SP',
        enderecoCep: '04301000',
        enderecoTelefone: '(11) 99999-8888',
        ie: '123456789',
      ),
      destinatario: const Participante(
        cnpj: '98765432000195',
        nome: 'Cliente Exemplo SA',
        enderecoLogradouro: 'Rua Destino',
        enderecoNumero: '200',
        enderecoBairro: 'Comercial',
        enderecoMunicipio: 'Belo Horizonte',
        enderecoUf: 'MG',
        enderecoCep: '30190000',
        enderecoTelefone: '(31) 97777-6666',
      ),
      valorBaseCalculoIcms: 500.00,
      valorIcms: 0.00, // CT-e normalmente não tem ICMS
      valorIpi: 0.00,
      valorPis: 0.00,
      valorCofins: 0.00,
      valorTotalProdutos: 500.00,
      valorTotalNota: 500.00,
      status: 'ATIVA',
      itens: [
        ItemDocumentoFiscal(
          id: 1,
          idDocumentoFiscal: 2,
          numeroItem: 1,
          codigoProduto: 'SERV001',
          descricaoProduto: 'Transporte Rodoviário de Carga',
          ncm: '49010000',
          cst: '00',
          cfop: 5351,
          unidade: 'VIAGEM',
          quantidade: 1,
          valorUnitario: 500.00,
          valorTotalItem: 500.00,
          baseCalculoIcms: 0.00,
          valorIcms: 0.00,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ],
      transporte: const Transporte(
        modalidadeFrete: '9',
        cnpjTransportador: '11222333000145',
        nomeTransportador: 'Transportadora Exemplo',
        enderecoTransportador: 'Av. Transporte, 100',
        municipioTransportador: 'São Paulo',
        ufTransportador: 'SP',
        placaVeiculo: 'XYZ9A87',
        ufVeiculo: 'SP',
        rntcVeiculo: '87654321',
        quantidadeVolumes: '1',
        especieVolumes: 'CARGA',
        marcaVolumes: 'N/D',
        numeracaoVolumes: 'N/D',
        pesoLiquido: 5000.0,
        pesoBruto: 6000.0,
      ),
      impostos: const Impostos(
        valorTotalTributos: 0.00,
        baseCalculoIcms: 0.00,
        valorIcms: 0.00,
        valorIpi: 0.00,
        valorPis: 0.00,
        valorCofins: 0.00,
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> _exibirPdf(Uint8List pdfBytes, String fileName,
      Future<Uint8List> Function(PdfPageFormat format) buildPdf) async {
    if (!mounted) return;
    // Navegar para a tela de visualização do PDF usando o novo widget do pacote
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SpedPdfViewer(
          buildPdf: buildPdf,
          fileName: fileName,
        ),
      ),
    );
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
