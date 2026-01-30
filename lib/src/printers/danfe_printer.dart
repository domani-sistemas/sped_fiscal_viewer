import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/documento_fiscal.dart';

class DanfePrinter {
  final DocumentoFiscal data;

  DanfePrinter(this.data);

  Future<pw.Document> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (context) => [
          _buildHeader(),
          pw.SizedBox(height: 8),
          _buildEmitenteDestinatario(),
          pw.SizedBox(height: 8),
          _buildNaturezaOperacao(),
          pw.SizedBox(height: 8),
          _buildTabelaItens(),
          pw.SizedBox(height: 8),
          _buildTotais(),
          pw.SizedBox(height: 8),
          _buildTransporte(),
          pw.SizedBox(height: 8),
          _buildDadosAdicionais(),
          pw.SizedBox(height: 8),
          _buildRodape(),
        ],
      ),
    );

    return pdf;
  }

  // =========================
  // HELPERS PADRONIZADOS
  // =========================

  pw.Widget _label(String text) => pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
      );

  pw.Widget _value(String text, {double size = 10, bool bold = false}) =>
      pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: size,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: PdfColors.black,
        ),
      );

  pw.Container _box({
    required double height,
    required pw.Widget child,
    PdfColor? borderColor,
    PdfColor? backgroundColor,
  }) {
    return pw.Container(
      height: height,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: borderColor ?? PdfColors.black,
          width: 1,
        ),
        color: backgroundColor,
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: child,
      ),
    );
  }

  pw.Container _boxWithLabel({
    required double height,
    required String label,
    required pw.Widget child,
  }) {
    return pw.Container(
      height: height,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 2, top: 2),
            child: _label(label),
          ),
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(2),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // HEADER
  // =========================

  pw.Widget _buildHeader() {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            // Coluna esquerda - Identificação do emitente
            pw.Expanded(
              flex: 41,
              child: pw.Container(
                height: 36,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'IDENTIFICAÇÃO DO EMITENTE',
                      style: pw.TextStyle(
                          fontSize: 6, fontStyle: pw.FontStyle.italic),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      data.emitente.nome,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      data.emitente.enderecoCompleto,
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            // Coluna central - DANFE
            pw.Expanded(
              flex: 17,
              child: pw.Container(
                height: 36,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'DANFE',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Documento Auxiliar da Nota Fiscal Eletrônica',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('0 - ENTRADA',
                                  style: pw.TextStyle(fontSize: 8)),
                              pw.Text('1 - SAÍDA',
                                  style: pw.TextStyle(fontSize: 8)),
                            ],
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                data.tipoOperacao,
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Nº ${data.numeroDocumento.toString().padLeft(9, '0')}',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.Text(
                                'Série ${data.serie.padLeft(3, '0')}',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            // Coluna direita - Código de barras e chave de acesso
            pw.Expanded(
              flex: 42,
              child: pw.Container(
                height: 36,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Column(
                  children: [
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.code128(),
                      data: data.chaveAcesso,
                      width: 75,
                      height: 12,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 2),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'CHAVE DE ACESSO',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 2),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        _formatarChaveAcesso(data.chaveAcesso),
                        style: pw.TextStyle(
                            fontSize: 8, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 2),
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'Consulta de autenticidade no portal nacional da NF-e',
                        style: pw.TextStyle(fontSize: 6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 1),
        // Linha com natureza da operação e protocolo de autorização
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 12,
                label: 'NATUREZA DA OPERAÇÃO',
                child: _value(data.tipoOperacao == 'S' ? 'VENDA' : 'COMPRA'),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              flex: 42,
              child: _boxWithLabel(
                height: 12,
                label: 'PROTOCOLO DE AUTORIZAÇÃO DE USO',
                child: _value('000000000000000 00/00/0000 00:00:00'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // EMITENTE / DESTINATÁRIO
  // =========================

  pw.Widget _buildEmitenteDestinatario() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _boxWithLabel(
            height: 50,
            label: 'NOME/RAZÃO SOCIAL',
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _value(data.emitente.nome, bold: true),
                pw.SizedBox(height: 2),
                _value(data.emitente.enderecoCompleto),
                pw.SizedBox(height: 2),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('CNPJ/CPF: ${data.emitente.cnpjFormatado}',
                              style: pw.TextStyle(fontSize: 8)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              'INSCRIÇÃO ESTADUAL: ${data.emitente.ie ?? 'N/A'}',
                              style: pw.TextStyle(fontSize: 8)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 1),
        pw.Expanded(
          child: _boxWithLabel(
            height: 50,
            label: 'NOME/RAZÃO SOCIAL',
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _value(data.destinatario.nome, bold: true),
                pw.SizedBox(height: 2),
                _value(data.destinatario.enderecoCompleto),
                pw.SizedBox(height: 2),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              'CNPJ/CPF: ${data.destinatario.cnpjFormatado}',
                              style: pw.TextStyle(fontSize: 8)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              'INSCRIÇÃO ESTADUAL: ${data.destinatario.ie ?? 'N/A'}',
                              style: pw.TextStyle(fontSize: 8)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // NATUREZA DA OPERAÇÃO
  // =========================

  pw.Widget _buildNaturezaOperacao() {
    return _boxWithLabel(
      height: 12,
      label: 'NATUREZA DA OPERAÇÃO',
      child: _value('VENDA'),
    );
  }

  // =========================
  // TABELA DE ITENS
  // =========================

  pw.Widget _buildTabelaItens() {
    return pw.Column(
      children: [
        pw.Container(
          height: 16,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
            color: PdfColors.grey300,
          ),
          child: pw.Center(
            child: pw.Text(
              'DADOS DOS PRODUTOS / SERVIÇOS',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.TableHelper.fromTextArray(
          headers: [
            'CÓDIGO',
            'DESCRIÇÃO',
            'NCM',
            'CST',
            'CFOP',
            'UN',
            'QTD',
            'V.UNIT',
            'V.TOTAL',
            'BC.ICMS',
            'V.ICMS',
            'V.IPI'
          ],
          data: data.itens
              .map((i) => [
                    i.codigoProdutoFormatado,
                    i.descricaoProduto,
                    i.ncmFormatado,
                    i.cstFormatado,
                    i.cfop.toString(),
                    i.unidade,
                    i.quantidadeFormatada,
                    i.valorUnitarioFormatado,
                    i.valorTotalFormatado,
                    i.baseCalculoIcmsFormatada,
                    i.valorIcmsFormatado,
                    i.valorIpiFormatado,
                  ])
              .toList(),
          border: pw.TableBorder.all(color: PdfColors.black),
          headerStyle:
              pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
          cellStyle: pw.TextStyle(fontSize: 8),
          cellHeight: 20,
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.center,
            3: pw.Alignment.center,
            4: pw.Alignment.center,
            5: pw.Alignment.center,
            6: pw.Alignment.centerRight,
            7: pw.Alignment.centerRight,
            8: pw.Alignment.centerRight,
            9: pw.Alignment.centerRight,
            10: pw.Alignment.centerRight,
            11: pw.Alignment.centerRight,
          },
        ),
      ],
    );
  }

  // =========================
  // TOTAIS
  // =========================

  pw.Widget _buildTotais() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: _box(
            height: 60,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CÁLCULO DO IMPOSTO',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('BASE DE CÁLCULO DO ICMS',
                              style: pw.TextStyle(fontSize: 8)),
                          pw.Text(data.valorBaseCalculoIcms.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('VALOR DO ICMS',
                              style: pw.TextStyle(fontSize: 8)),
                          pw.Text(data.valorIcms.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('BASE DE CÁLCULO DO ICMS ST',
                              style: pw.TextStyle(fontSize: 8)),
                          pw.Text('0,00',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('VALOR DO ICMS ST',
                              style: pw.TextStyle(fontSize: 8)),
                          pw.Text('0,00',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('VALOR APROX. DOS TRIBUTOS',
                              style: pw.TextStyle(fontSize: 8)),
                          pw.Text(
                              (data.valorTotalProdutos * 0.35)
                                  .toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('VALOR TOTAL DOS PRODUTOS',
                              style: pw.TextStyle(fontSize: 8)),
                          pw.Text(data.valorTotalProdutos.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 1),
        pw.Expanded(
          child: _box(
            height: 60,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'TOTAL DA NOTA',
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  data.valorTotalFormatado,
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'FORMA PAGAMENTO',
                  style:
                      pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  '01-DINHEIRO: ${data.valorTotalFormatado}',
                  style: pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================
  // TRANSPORTE
  // =========================

  pw.Widget _buildTransporte() {
    return pw.Column(
      children: [
        pw.Container(
          height: 16,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
            color: PdfColors.grey300,
          ),
          child: pw.Center(
            child: pw.Text(
              'TRANSPORTADOR / VOLUMES TRANSPORTADOS',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('NOME/RAZÃO SOCIAL',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.nomeTransportador ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              flex: 2,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('FRETE POR CONTA',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.modalidadeFrete ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('CÓDIGO ANTT',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.rntcVeiculo ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('PLACA DO VEÍCULO',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        '${data.transporte.placaVeiculo ?? 'N/A'} / ${data.transporte.ufVeiculo ?? 'N/A'}',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('UF',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.ufVeiculo ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('CNPJ/CPF',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.cnpjTransportadorFormatado,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 1),
        pw.Row(
          children: [
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('ENDEREÇO',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.enderecoTransportador ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('MUNICÍPIO',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.municipioTransportador ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('UF',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.ufTransportador ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('INSCRIÇÃO ESTADUAL',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text('N/A', style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 1),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 2,
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('QUANTIDADE',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.quantidadeVolumes ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('ESPÉCIE',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.especieVolumes ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('MARCA',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.marcaVolumes ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('NUMERAÇÃO',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.numeracaoVolumes ?? 'N/A',
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('PESO BRUTO',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.pesoBrutoFormatado,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 20,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('PESO LÍQUIDO',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold)),
                    pw.Text(data.transporte.pesoLiquidoFormatado,
                        style: pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // DADOS ADICIONAIS
  // =========================

  pw.Widget _buildDadosAdicionais() {
    return pw.Column(
      children: [
        pw.Container(
          height: 16,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1),
            color: PdfColors.grey300,
          ),
          child: pw.Center(
            child: pw.Text(
              'DADOS ADICIONAIS',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 2,
              child: _box(
                height: 40,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INFORMAÇÕES COMPLEMENTARES',
                      style: pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Informações complementares da nota fiscal',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(width: 1),
            pw.Expanded(
              child: _box(
                height: 40,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'RESERVADO AO FISCO',
                      style: pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Informações do fisco',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // RODAPÉ
  // =========================

  pw.Widget _buildRodape() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Container(
            height: 20,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black, width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                'DANFE - Documento Auxiliar da Nota Fiscal Eletrônica - Impresso em ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}',
                style: pw.TextStyle(fontSize: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatarChaveAcesso(String chave) {
    if (chave.length != 44) return chave;
    return '${chave.substring(0, 4)} ${chave.substring(4, 8)} ${chave.substring(8, 12)} ${chave.substring(12, 16)} ${chave.substring(16, 20)} ${chave.substring(20, 24)} ${chave.substring(24, 28)} ${chave.substring(28, 32)} ${chave.substring(32, 36)} ${chave.substring(36, 40)} ${chave.substring(40, 44)}';
  }
}
