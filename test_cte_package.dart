// ignore_for_file: avoid_print

import 'package:sped_viewer/sped_viewer.dart';
import 'dart:io';

void main() async {
  // Criar um documento fiscal de exemplo (CT-e)
  final documentoCte = DocumentoFiscal(
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
    emitente: Participante(
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
    destinatario: Participante(
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
    transporte: Transporte(
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
    impostos: Impostos(
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

  try {
    // Gerar o PDF com o novo layout SEFAZ para CT-e
    final dactePrinter = DacteSefazPrinter(documentoCte);
    final pdf = await dactePrinter.generate();

    // Converter para bytes
    final bytes = await pdf.save();

    // Salvar o PDF em um arquivo para verificação
    final file = File('teste_cte_sefaz.pdf');
    await file.writeAsBytes(bytes);

    print(
        'PDF DACTE SEFAZ gerado com sucesso! Arquivo salvo como: ${file.path}');
    print('Tamanho do arquivo: ${bytes.length} bytes');
  } catch (e) {
    print('Erro ao gerar PDF DACTE: $e');
  }
}
