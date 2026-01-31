import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/documento_fiscal.dart';

class DanfeSefazPrinter {
  final DocumentoFiscal data;

  DanfeSefazPrinter(this.data);

  Future<pw.Document> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(
            8), // Margem reduzida para melhor aproveitamento
        build: (context) => [
          _buildCanhotoPrincipal(),
          _buildHeader(),
          _buildDestinatarioRemetente(),
          _buildLocalEntrega(),
          _buildFaturas(),
          _buildTotais(),
          _buildTransporte(),
          _buildTabelaItens(),
          _buildIssqn(),
          _buildDadosAdicionaisFisco(),
        ],
        footer: (context) => _buildFooter(),
      ),
    );

    return pdf;
  }

  // =========================
  // CANHOTO PRINCIPAL (DECLARAÇÃO DE RECEBIMENTO)
  // =========================

  pw.Widget _buildCanhotoPrincipal() {
    return pw.Container(
      height: 50,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: pw.Row(
          children: [
            pw.Expanded(
              flex: 75,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'RECEBEMOS DE ${data.emitente.nome.toUpperCase()} OS PRODUTOS E/OU SERVIÇOS CONSTANTES DA NOTA FISCAL ELETRÔNICA INDICADA ABAIXO.',
                    style: pw.TextStyle(
                        fontSize: 6, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'EMISSÃO: ${data.dataEmissaoFormatada} VALOR TOTAL: ${data.valorTotalFormatado}',
                    style: pw.TextStyle(fontSize: 6),
                  ),
                  pw.Text(
                    'DESTINATÁRIO: ${data.destinatario.nome.toUpperCase()}',
                    style: pw.TextStyle(fontSize: 6),
                  ),
                  pw.Text(
                    '${data.destinatario.enderecoLogradouro}, ${data.destinatario.enderecoNumero} ${data.destinatario.enderecoBairro} ${data.destinatario.enderecoMunicipio}-${data.destinatario.enderecoUf}',
                    style: pw.TextStyle(fontSize: 6),
                  ),
                  pw.Spacer(),
                  pw.Row(
                    children: [
                      pw.Text(
                        'DATA DE RECEBIMENTO: ___/___/______',
                        style: pw.TextStyle(fontSize: 6),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Text(
                        'IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR',
                        style: pw.TextStyle(fontSize: 6),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.Container(width: 0.5, color: PdfColors.black),
            pw.Expanded(
              flex: 25,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('NF-e',
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Nº. ${_formatarNumeroNfe(data.numeroDocumento)}',
                      style: pw.TextStyle(
                          fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Série ${data.serie.padLeft(3, '0')}',
                      style: pw.TextStyle(fontSize: 8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // HELPERS PADRONIZADOS
  // =========================

  pw.Widget _label(String text) => pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 6, // 6pt para títulos de campos
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.black,
        ),
      );

  pw.Widget _value(String text, {double size = 8, bool bold = false}) =>
      pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: size,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: PdfColors.black,
        ),
      );

  pw.Container _boxWithLabel({
    required double height,
    required String label,
    required pw.Widget child,
  }) {
    return pw.Container(
      height: height,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            height: 8, // Altura fixa para seção do label
            padding: const pw.EdgeInsets.only(left: 2, top: 1),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100, // Fundo cinza claro para label
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.black, width: 0.5),
              ),
            ),
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: _label(label),
            ),
          ),
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(2),
              child: pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          width: 0.5,
        ),
        color: backgroundColor,
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: child,
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
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Coluna esquerda - Identificação do emitente (40%)
            pw.Expanded(
              flex: 40,
              child: pw.Container(
                height: 90,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Container(height: 20), // Espaço para logo
                    pw.Text(
                      data.emitente.nome,
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      '${data.emitente.enderecoLogradouro}, ${data.emitente.enderecoNumero}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      '${data.emitente.enderecoBairro} - ${data.emitente.enderecoMunicipio} - ${data.emitente.enderecoUf}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'Fone/Fax: ${data.emitente.enderecoTelefone ?? ""}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'CNPJ: ${data.emitente.cnpjFormatado}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'IE: ${data.emitente.ie ?? ""}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
            // Coluna central - DANFE (20%)
            pw.Expanded(
              flex: 20,
              child: pw.Container(
                height: 90,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'DANFE',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 4),
                      child: pw.Text(
                        'Documento Auxiliar da Nota Fiscal Eletrônica',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(fontSize: 6),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('0 - ENTRADA',
                                style: pw.TextStyle(fontSize: 6)),
                            pw.Text('1 - SAÍDA',
                                style: pw.TextStyle(fontSize: 6)),
                          ],
                        ),
                        pw.SizedBox(width: 8),
                        pw.Container(
                          width: 20,
                          height: 20,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                                color: PdfColors.black, width: 0.5),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              data.tipoOperacao == 'S' ? 'X' : '',
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Nº. ${_formatarNumeroNfe(data.numeroDocumento)}',
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Série ${data.serie.padLeft(3, '0')}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Folha 1/1',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
            // Coluna direita - Código de barras e chave de acesso (40%)
            pw.Expanded(
              flex: 40,
              child: pw.Container(
                height: 90,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.LayoutBuilder(builder: (context, constraints) {
                      return pw.BarcodeWidget(
                        barcode: pw.Barcode.code128(),
                        data: data.chaveAcesso,
                        width: constraints?.maxWidth ?? 100,
                        height: 25,
                        drawText: false,
                      );
                    }),
                    pw.Container(
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border:
                            pw.Border.all(color: PdfColors.black, width: 0.5),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Container(
                            height: 8,
                            color: PdfColors.grey100,
                            child: pw.Center(
                              child: pw.Text(
                                'CHAVE DE ACESSO',
                                style: pw.TextStyle(
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Center(
                              child: pw.Text(
                                _formatarChaveAcesso(data.chaveAcesso),
                                style: pw.TextStyle(
                                    font: pw.Font.courier(),
                                    fontSize: 7,
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Text(
                      'Consulta de autenticidade no portal nacional da NF-e',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.Text(
                      'www.nfe.fazenda.gov.br/portal ou no site da Sefaz Autorizadora',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        // Linha com natureza da operação e protocolo de autorização
        pw.Row(
          children: [
            pw.Expanded(
              flex: 60,
              child: _boxWithLabel(
                height: 16,
                label: 'NATUREZA DA OPERAÇÃO',
                child: _value('VENDA DE MERCADORIA', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 40,
              child: _boxWithLabel(
                height: 16,
                label: 'PROTOCOLO DE AUTORIZAÇÃO DE USO',
                child: _value(
                    '135240000000000 ${data.dataEmissaoFormatada} 10:30:00',
                    size: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // DESTINATÁRIO / REMETENTE
  // =========================

  pw.Widget _buildDestinatarioRemetente() {
    return pw.Column(
      children: [
        pw.Container(
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'DESTINATÁRIO / REMETENTE',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 14,
                label: 'NOME / RAZÃO SOCIAL',
                child: _value(data.destinatario.nome, bold: true, size: 8),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 14,
                label: 'CNPJ / CPF',
                child: _value(data.destinatario.cnpjFormatado, size: 8),
              ),
            ),
            pw.Expanded(
              flex: 22,
              child: _boxWithLabel(
                height: 14,
                label: 'DATA DA EMISSÃO',
                child: _value(data.dataEmissaoFormatada, size: 8),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 14,
                label: 'ENDEREÇO',
                child: _value(
                    '${data.destinatario.enderecoLogradouro}, ${data.destinatario.enderecoNumero}',
                    size: 8),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 14,
                label: 'BAIRRO / DISTRITO',
                child: _value(data.destinatario.enderecoBairro ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 22,
              child: _boxWithLabel(
                height: 14,
                label: 'CEP',
                child: _value(data.destinatario.cepFormatado, size: 8),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 14,
                label: 'MUNICÍPIO',
                child:
                    _value(data.destinatario.enderecoMunicipio ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 8,
              child: _boxWithLabel(
                height: 14,
                label: 'UF',
                child: _value(data.destinatario.enderecoUf ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 12,
              child: _boxWithLabel(
                height: 14,
                label: 'FONE / FAX',
                child:
                    _value(data.destinatario.enderecoTelefone ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 22,
              child: _boxWithLabel(
                height: 14,
                label: 'INSCRIÇÃO ESTADUAL',
                child: _value(data.destinatario.ie ?? '', size: 8),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                height: 14,
                label: 'DATA DA SAÍDA',
                child: _value(data.dataEmissaoFormatada,
                    size:
                        8), // Usar data de emissão se não houver data de saída
              ),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                height: 14,
                label: 'HORA DA SAÍDA',
                child: _value('10:30:00', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 50,
              child: pw.Container(),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // INFORMAÇÕES DO LOCAL DE ENTREGA
  // =========================

  pw.Widget _buildLocalEntrega() {
    // Só mostra se o local de entrega for diferente do destinatário
    if (data.destinatario.enderecoLogradouro == null) {
      return pw.Container(); // Retorna container vazio se não há diferença
    }

    return pw.Column(
      children: [
        pw.Container(
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'INFORMAÇÕES DO LOCAL DE ENTREGA',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 14,
                label: 'NOME/RAZÃO SOCIAL',
                child: _value(data.destinatario.nome, bold: true, size: 8),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 14,
                label: 'CNPJ/CPF',
                child: _value(data.destinatario.cnpjFormatado, size: 8),
              ),
            ),
            pw.Expanded(
              flex: 22,
              child: _boxWithLabel(
                height: 14,
                label: 'INSCRIÇÃO ESTADUAL',
                child: _value(data.destinatario.ie ?? '', size: 8),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 14,
                label: 'ENDEREÇO',
                child: _value(
                    '${data.destinatario.enderecoLogradouro}, ${data.destinatario.enderecoNumero}',
                    size: 8),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 14,
                label: 'BAIRRO/DISTRITO',
                child: _value(data.destinatario.enderecoBairro ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 22,
              child: _boxWithLabel(
                height: 14,
                label: 'CEP',
                child: _value(data.destinatario.cepFormatado, size: 8),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 14,
                label: 'MUNICÍPIO',
                child:
                    _value(data.destinatario.enderecoMunicipio ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 8,
              child: _boxWithLabel(
                height: 14,
                label: 'UF',
                child: _value(data.destinatario.enderecoUf ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 12,
              child: _boxWithLabel(
                height: 14,
                label: 'FONE / FAX',
                child: _value('', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 22,
              child: pw.Container(),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // FATURAS / DUPLICATAS
  // =========================

  pw.Widget _buildFaturas() {
    return pw.Column(
      children: [
        pw.Container(
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'FATURA / DUPLICATAS',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Container(
          height: 30,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Container(
                      height: 8,
                      color: PdfColors.grey100,
                      child: pw.Center(
                        child: pw.Text('NÚM.',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Center(
                            child: pw.Text('001',
                                style: pw.TextStyle(fontSize: 7)))),
                  ],
                ),
              ),
              pw.Container(width: 0.5, color: PdfColors.black),
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Container(
                      height: 8,
                      color: PdfColors.grey100,
                      child: pw.Center(
                        child: pw.Text('VENC.',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Center(
                            child: pw.Text(data.dataEmissaoFormatada,
                                style: pw.TextStyle(fontSize: 7)))),
                  ],
                ),
              ),
              pw.Container(width: 0.5, color: PdfColors.black),
              pw.Expanded(
                child: pw.Column(
                  children: [
                    pw.Container(
                      height: 8,
                      color: PdfColors.grey100,
                      child: pw.Center(
                        child: pw.Text('VALOR',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Center(
                            child: pw.Text(data.valorTotalFormatado,
                                style: pw.TextStyle(fontSize: 7)))),
                  ],
                ),
              ),
              // Colunas vazias para outras duplicatas
              ...List.generate(
                  9, (index) => pw.Expanded(child: pw.Container())),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // TABELA DE ITENS
  // =========================

  pw.Widget _buildTabelaItens() {
    const maxItensPerPage = 15;
    final itens = data.itens;
    final itensCount = itens.length;
    final emptyRows =
        itensCount < maxItensPerPage ? maxItensPerPage - itensCount : 0;

    final headers = [
      'CÓD. PRODUTO',
      'DESCRIÇÃO DO PRODUTO / SERVIÇO',
      'NCM/SH',
      'O/CST',
      'CFOP',
      'UN',
      'QUANT',
      'VALOR UNIT',
      'VALOR TOTAL',
      'VALOR DESC',
      'B.CÁLC ICMS',
      'VALOR ICMS',
      'VALOR IPI',
      'ALÍQ ICMS',
      'ALÍQ IPI',
    ];

    var allRows = itens.map((item) {
      return [
        item.codigoProduto ?? '',
        item.descricaoProduto,
        item.ncm ?? '',
        '0${item.cst ?? '00'}', // Adiciona origem "0" + CST
        item.cfop.toString(),
        item.unidade,
        item.quantidade.toStringAsFixed(4).replaceAll('.', ','),
        item.valorUnitario.toStringAsFixed(4).replaceAll('.', ','),
        item.valorTotalItem.toStringAsFixed(2).replaceAll('.', ','),
        '0,00', // Valor desconto - placeholder
        (item.baseCalculoIcms ?? 0.0).toStringAsFixed(2).replaceAll('.', ','),
        (item.valorIcms ?? 0.0).toStringAsFixed(2).replaceAll('.', ','),
        (item.valorIpi ?? 0.0).toStringAsFixed(2).replaceAll('.', ','),
        (item.aliquotaIcms ?? 0.0).toStringAsFixed(2).replaceAll('.', ','),
        (item.aliquotaIpi ?? 0.0).toStringAsFixed(2).replaceAll('.', ','),
      ];
    }).toList();

    for (int i = 0; i < emptyRows; i++) {
      allRows.add(List.filled(15, '')); // Agora são 15 colunas
    }

    return pw.Column(
      children: [
        _buildTabelaItensHeader(),
        pw.TableHelper.fromTextArray(
          border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(8),
            1: pw.FlexColumnWidth(30),
            2: pw.FlexColumnWidth(8),
            3: pw.FlexColumnWidth(5),
            4: pw.FlexColumnWidth(5),
            5: pw.FlexColumnWidth(4),
            6: pw.FlexColumnWidth(7),
            7: pw.FlexColumnWidth(8),
            8: pw.FlexColumnWidth(8),
            9: pw.FlexColumnWidth(7),
            10: pw.FlexColumnWidth(8),
            11: pw.FlexColumnWidth(7),
            12: pw.FlexColumnWidth(7),
            13: pw.FlexColumnWidth(5),
            14: pw.FlexColumnWidth(5),
          },
          headerStyle:
              pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6),
          cellStyle: const pw.TextStyle(fontSize: 6),
          cellPadding: const pw.EdgeInsets.all(1),
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
            12: pw.Alignment.centerRight,
            13: pw.Alignment.center,
            14: pw.Alignment.center,
          },
          headers: headers,
          data: allRows,
        )
      ],
    );
  }

  pw.Widget _buildTabelaItensHeader() {
    return pw.Container(
      height: 12,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
        color: PdfColors.grey100,
      ),
      child: pw.Center(
        child: pw.Text(
          'DADOS DOS PRODUTOS / SERVIÇOS',
          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        ),
      ),
    );
  }

  // =========================
  // TOTAIS
  // =========================

  pw.Widget _buildTotais() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 65,
          child: pw.Column(
            children: [
              pw.Container(
                height: 12,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                  color: PdfColors.grey100,
                ),
                child: pw.Center(
                  child: pw.Text(
                    'CÁLCULO DO IMPOSTO',
                    style: pw.TextStyle(
                        fontSize: 8, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 14,
                        label: 'BASE DE CÁLC. DO ICMS',
                        child: _value(
                            data.valorBaseCalculoIcms
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                            size: 8,
                            bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'VALOR DO ICMS',
                        child: _value(
                            data.valorIcms
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                            size: 8,
                            bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'V. IMP. IMPORTAÇÃO',
                        child: _value('0,00', size: 8, bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'VALOR DO PIS',
                        child: _value(
                            data.valorPis
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                            size: 8,
                            bold: true)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'BASE DE CÁLC. ICMS S.T.',
                        child: _value('0,00', size: 8, bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'VALOR DO ICMS SUBST.',
                        child: _value('0,00', size: 8, bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'V. ICMS UF REMET.',
                        child: _value('0,00', size: 8, bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'VALOR DA COFINS',
                        child: _value(
                            data.valorCofins
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                            size: 8,
                            bold: true)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'V. TOTAL PRODUTOS',
                        child: _value(
                            data.valorTotalProdutos
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                            size: 8,
                            bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'VALOR DO FRETE',
                        child: _value(
                            data.transporte.valorFrete
                                    ?.toStringAsFixed(2)
                                    .replaceAll('.', ',') ??
                                '0,00',
                            size: 8,
                            bold: true)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'VALOR DO SEGURO',
                        child: _value(
                            data.transporte.valorSeguro
                                    ?.toStringAsFixed(2)
                                    .replaceAll('.', ',') ??
                                '0,00',
                            size: 8,
                            bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'DESCONTO',
                        child: _value('0,00', size: 8, bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'V. FCP UF DEST.',
                        child: _value('0,00', size: 8, bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'V. TOT. TRIB.',
                        child: _value(
                            (data.valorIcms +
                                    data.valorIpi +
                                    data.valorPis +
                                    data.valorCofins)
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                            size: 8,
                            bold: true)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'OUTRAS DESPESAS',
                        child: _value('0,00', size: 8, bold: true)),
                  ),
                  pw.Expanded(
                    child: _boxWithLabel(
                        height: 12,
                        label: 'VALOR TOTAL DO IPI',
                        child: _value(
                            data.valorIpi
                                .toStringAsFixed(2)
                                .replaceAll('.', ','),
                            size: 8,
                            bold: true)),
                  ),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _boxWithLabel(
                      height: 16,
                      label: 'V. TOTAL DA NOTA',
                      child: _value(
                          data.valorTotalNota
                              .toStringAsFixed(2)
                              .replaceAll('.', ','),
                          size: 12,
                          bold: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 35,
          child: pw.Column(
            children: [
              pw.Container(
                height: 12,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                  color: PdfColors.grey100,
                ),
                child: pw.Center(
                  child: pw.Text(
                    'CÁLCULO DO ISSQN',
                    style: pw.TextStyle(
                        fontSize: 8, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ),
              _boxWithLabel(
                  height: 12,
                  label: 'INSCRIÇÃO MUNICIPAL',
                  child: _value('', size: 8)),
              _boxWithLabel(
                  height: 12,
                  label: 'VALOR TOTAL DOS SERVIÇOS',
                  child: _value('0,00', size: 8, bold: true)),
              _boxWithLabel(
                  height: 12,
                  label: 'BASE DE CÁLCULO DO ISSQN',
                  child: _value('0,00', size: 8, bold: true)),
              _boxWithLabel(
                  height: 12,
                  label: 'VALOR DO ISSQN',
                  child: _value('0,00', size: 8, bold: true)),
              pw.Container(height: 16),
            ],
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
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'TRANSPORTADOR / VOLUMES TRANSPORTADOS',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 58,
              child: _boxWithLabel(
                height: 14,
                label: 'NOME / RAZÃO SOCIAL',
                child: _value(data.transporte.nomeTransportador ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 14,
              child: _boxWithLabel(
                height: 14,
                label: 'FRETE POR CONTA',
                child: _value(
                    _getModalidadeFreteDescricao(
                        data.transporte.modalidadeFrete),
                    size: 8),
              ),
            ),
            pw.Expanded(
              flex: 14,
              child: _boxWithLabel(
                height: 14,
                label: 'CÓDIGO ANTT',
                child: _value(data.transporte.rntcVeiculo ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 14,
              child: _boxWithLabel(
                height: 14,
                label: 'PLACA DO VEÍCULO',
                child: _value(
                    '${data.transporte.placaVeiculo ?? ''} / ${data.transporte.ufVeiculo ?? ''}',
                    size: 8),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 14,
                label: 'CNPJ / CPF',
                child: _value(data.transporte.cnpjTransportador ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 38,
              child: _boxWithLabel(
                height: 14,
                label: 'ENDEREÇO',
                child: _value(data.transporte.enderecoTransportador ?? '',
                    size: 8),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 14,
                label: 'MUNICÍPIO',
                child: _value(data.transporte.municipioTransportador ?? '',
                    size: 8),
              ),
            ),
            pw.Expanded(
              flex: 8,
              child: _boxWithLabel(
                height: 14,
                label: 'UF',
                child: _value(data.transporte.ufTransportador ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 14,
              child: _boxWithLabel(
                height: 14,
                label: 'INSCRIÇÃO ESTADUAL',
                child: _value(
                    data.transporte.inscricaoEstadualTransportador ?? '',
                    size: 8),
              ),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 10,
              child: _boxWithLabel(
                height: 14,
                label: 'QUANTIDADE',
                child: _value(data.transporte.quantidadeVolumes ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 15,
              child: _boxWithLabel(
                height: 14,
                label: 'ESPÉCIE',
                child: _value(data.transporte.especieVolumes ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 15,
              child: _boxWithLabel(
                height: 14,
                label: 'MARCA',
                child: _value(data.transporte.marcaVolumes ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 15,
              child: _boxWithLabel(
                height: 14,
                label: 'NUMERAÇÃO',
                child: _value(data.transporte.numeracaoVolumes ?? '', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 15,
              child: _boxWithLabel(
                height: 14,
                label: 'PESO BRUTO',
                child: _value(data.transporte.pesoBrutoFormatado, size: 8),
              ),
            ),
            pw.Expanded(
              flex: 15,
              child: _boxWithLabel(
                height: 14,
                label: 'PESO LÍQUIDO',
                child: _value(data.transporte.pesoLiquidoFormatado, size: 8),
              ),
            ),
            pw.Expanded(
              flex: 15,
              child: pw.Container(),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // DADOS ADICIONAIS FISCO
  // =========================

  pw.Widget _buildDadosAdicionaisFisco() {
    return pw.Column(
      children: [
        pw.Container(
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'DADOS ADICIONAIS',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 65,
              child: _box(
                height: 50,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INFORMAÇÕES COMPLEMENTARES',
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Inf. Contribuinte: Trib aprox R\$: ${(data.valorTotalProdutos * 0.35).toStringAsFixed(2).replaceAll('.', ',')} Federal e Estadual',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'Email do Destinatário: ${data.destinatario.email ?? 'não informado'}',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'Empresa optante pelo Simples Nacional',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 35,
              child: _box(
                height: 50,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'RESERVADO AO FISCO',
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Valor Aproximado dos Tributos: R\$ ${(data.valorTotalProdutos * 0.35).toStringAsFixed(2).replaceAll('.', ',')}',
                      style: pw.TextStyle(fontSize: 6),
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
  // MÉTODOS AUXILIARES
  // =========================

  String _formatarChaveAcesso(String chave) {
    if (chave.length != 44) return chave;
    return '${chave.substring(0, 4)} ${chave.substring(4, 8)} ${chave.substring(8, 12)} ${chave.substring(12, 16)} ${chave.substring(16, 20)} ${chave.substring(20, 24)} ${chave.substring(24, 28)} ${chave.substring(28, 32)} ${chave.substring(32, 36)} ${chave.substring(36, 40)} ${chave.substring(40, 44)}';
  }

  String _getModalidadeFreteDescricao(String? modalidade) {
    switch (modalidade) {
      case '0':
        return '0-Emitente';
      case '1':
        return '1-Destinatário';
      case '2':
        return '2-Terceiros';
      case '9':
        return '9-Sem Frete';
      default:
        return modalidade ?? '';
    }
  }

  pw.Widget _buildIssqn() {
    return pw.Column(
      children: [
        pw.Container(
          height: 12,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'CÁLCULO DO ISSQN',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _boxWithLabel(
                  height: 18,
                  label: 'INSCRIÇÃO MUNICIPAL',
                  child: _value('', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 18,
                  label: 'V. TOTAL SERVIÇOS',
                  child: _value('0,00', size: 8, bold: true)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 18,
                  label: 'BASE CÁLC. ISSQN',
                  child: _value('0,00', size: 8, bold: true)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 18,
                  label: 'VALOR DO ISSQN',
                  child: _value('0,00', size: 8, bold: true)),
            ),
          ],
        ),
      ],
    );
  }

  String _formatarNumeroNfe(int numero) {
    String str = numero.toString().padLeft(9, '0');
    return '${str.substring(0, 3)}.${str.substring(3, 6)}.${str.substring(6, 9)}';
  }

  pw.Widget _buildFooter() {
    final now = DateTime.now();
    final dataStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final horaStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    return pw.Container(
      height: 15,
      child: pw.Center(
        child: pw.Text(
          'DANFE - Documento Auxiliar da Nota Fiscal Eletrônica - Impresso em $dataStr as $horaStr',
          style: pw.TextStyle(fontSize: 6),
        ),
      ),
    );
  }
}
