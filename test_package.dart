// ignore_for_file: avoid_print

import 'lib/src/printers/danfe_sefaz_printer.dart';
import 'lib/src/models/documento_fiscal.dart';
import 'lib/src/models/participante.dart';
import 'lib/src/models/item_documento.dart';
import 'lib/src/models/transporte.dart';
import 'lib/src/models/impostos.dart';
import 'dart:io';

void main() async {
  // Criar um documento fiscal de exemplo (NF-e)
  final documentoNfe = DocumentoFiscal(
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
    emitente: Participante(
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
    destinatario: Participante(
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
        aliquotaIcms: 18.00,
        valorIpi: 50.00,
        aliquotaIpi: 5.00,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
    transporte: Transporte(
      modalidadeFrete: '0',
      cnpjTransportador: '11222333000145',
      nomeTransportador: 'Transportadora Exemplo',
      enderecoTransportador: 'Rua Transporte, 789',
      municipioTransportador: 'Campinas',
      ufTransportador: 'SP',
      placaVeiculo: 'ABC1D23',
      ufVeiculo: 'SP',
      rntcVeiculo: '12345678',
      quantidadeVolumes: '10',
      especieVolumes: 'CAIXAS',
      marcaVolumes: 'N/D',
      numeracaoVolumes: '1-10',
      pesoLiquido: 100.0,
      pesoBruto: 120.0,
      valorFrete: 50.0,
      valorSeguro: 20.0,
    ),
    impostos: Impostos(
      valorTotalTributos: 446.50,
      baseCalculoIcms: 1000.00,
      valorIcms: 180.00,
      valorIpi: 50.00,
      valorPis: 6.50,
      valorCofins: 30.00,
    ),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  try {
    // Gerar o PDF com o novo layout SEFAZ
    final danfePrinter = DanfeSefazPrinter(documentoNfe);
    final pdf = await danfePrinter.generate();

    // Converter para bytes
    final bytes = await pdf.save();

    // Salvar o PDF em um arquivo para verificação
    final file = File('teste_nfe_sefaz.pdf');
    await file.writeAsBytes(bytes);

    print('PDF SEFAZ gerado com sucesso! Arquivo salvo como: ${file.path}');
    print('Tamanho do arquivo: ${bytes.length} bytes');
  } catch (e) {
    print('Erro ao gerar PDF: $e');
  }
}
