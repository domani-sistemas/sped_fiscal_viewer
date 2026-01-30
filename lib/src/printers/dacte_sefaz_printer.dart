import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../models/documento_fiscal.dart';

class DacteSefazPrinter {
  final DocumentoFiscal data;

  DacteSefazPrinter(this.data);

  Future<pw.Document> generate() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(
            8), // Margem reduzida para melhor aproveitamento
        build: (context) => [
          _buildCanhotoCte(), // Canhoto superior do CT-e
          _buildHeader(),
          _buildTipoFields(), // Nova seção para TIPO DO CTE, TIPO DO SERVIÇO, TOMADOR
          _buildRemetente(),
          _buildDestinatario(),
          _buildExpedidor(),
          _buildRecebedor(),
          _buildTomadorServico(), // Seção que estava faltando
          _buildDadosCte(),
          _buildDocumentosOriginarios(), // Nova seção adicionada
          _buildComponentesValor(),
          _buildImposto(),
          _buildValores(),
          _buildCarga(),
          _buildModalRodoviario(), // Seção específica do modal rodoviário
          _buildReservadoFisco(), // Nova seção adicionada
          _buildDadosAdicionais(),
        ],
        footer: (context) => _buildFooter(),
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
  // CANHOTO CT-e
  // =========================

  pw.Widget _buildCanhotoCte() {
    return pw.Column(
      children: [
        pw.Container(
          height: 50,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 70,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE',
                        style: pw.TextStyle(
                            fontSize: 6, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'NOME: _________________________________ RG: _________________ ASSINATURA / CARIMBO: _________________________________',
                        style: pw.TextStyle(fontSize: 6),
                      ),
                      pw.Text(
                        'TÉRMINO DA PRESTAÇÃO - DATA/HORA: ___/___/______ ___:___ INÍCIO DA PRESTAÇÃO - DATA/HORA: ___/___/______ ___:___',
                        style: pw.TextStyle(fontSize: 6),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Container(
                width: 0.5,
                color: PdfColors.black,
              ),
              pw.Expanded(
                flex: 30,
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(4),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'CT-e',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        'Nº ${data.numeroDocumento}',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        'Série ${data.serie}',
                        style: pw.TextStyle(fontSize: 8),
                      ),
                      pw.Text(
                        data.dataEmissaoFormatada,
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 5),
      ],
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
            // Coluna esquerda - Identificação do emitente
            pw.Expanded(
              flex: 40,
              child: pw.Container(
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(4),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
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
                      'Telefone/Fax: ${data.emitente.enderecoTelefone ?? ''}',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'CNPJ/CPF: ${data.emitente.cnpjFormatado}',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'IE: ${data.emitente.ie ?? ''}',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                  ],
                ),
              ),
            ),
            // Coluna central - DACTE
            pw.Expanded(
              flex: 20,
              child: pw.Container(
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Column(
                  children: [
                    // Seção superior - Título DACTE
                    pw.Container(
                      height: 25,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'DACTE',
                            style: pw.TextStyle(
                                fontSize: 14, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 2),
                            child: pw.Text(
                              'Documento Auxiliar do Conhecimento de Transporte Eletrônico',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(fontSize: 6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Seção inferior - Lista de campos
                    pw.Expanded(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Text('MODAL: Rodoviário',
                                style: pw.TextStyle(fontSize: 7)),
                            pw.Text('MODELO: 57',
                                style: pw.TextStyle(fontSize: 7)),
                            pw.Text('SÉRIE: ${data.serie}',
                                style: pw.TextStyle(fontSize: 7)),
                            pw.Text('NÚMERO: ${data.numeroDocumento}',
                                style: pw.TextStyle(fontSize: 7)),
                            pw.Text('FL: 1/1',
                                style: pw.TextStyle(fontSize: 7)),
                            pw.Text('DATA E HORA DE EMISSÃO:',
                                style: pw.TextStyle(fontSize: 6)),
                            pw.Text('${data.dataEmissaoFormatada} 10:30:00',
                                style: pw.TextStyle(fontSize: 7)),
                            pw.Text('INSC. SUFRAMA DO DESTINATÁRIO:',
                                style: pw.TextStyle(fontSize: 6)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Coluna direita - Código de barras e chave de acesso
            pw.Expanded(
              flex: 40,
              child: pw.Container(
                height: 80,
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
                        height: 20,
                        drawText: false,
                      );
                    }),
                    pw.Container(
                      height: 20,
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
                                    fontSize: 6,
                                    fontWeight: pw.FontWeight.bold),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Text(
                      'Consulta de autenticidade no portal nacional do CT-e',
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
                child: _value('TRANSPORTE DE CARGA', size: 8),
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
  // CAMPOS TIPO (NOVA SEÇÃO)
  // =========================
  pw.Widget _buildTipoFields() {
    return pw.Row(
      children: [
        pw.Expanded(
            flex: 65, child: pw.Container()), // Espaço vazio para alinhamento
        pw.Expanded(
          flex: 35,
          child: pw.Column(
            children: [
              _boxWithLabel(
                  height: 12,
                  label: 'TIPO DO CTE',
                  child: _value('0 - Normal', size: 8)),
              _boxWithLabel(
                  height: 12,
                  label: 'TIPO DO SERVIÇO',
                  child: _value('0 - Normal', size: 8)),
              _boxWithLabel(
                  height: 12,
                  label: 'TOMADOR DO SERVIÇO',
                  child: _value('3 - Destinatário', size: 8)),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // REMETENTE
  // =========================
  pw.Widget _buildRemetente() {
    // Usando dados do emitente como placeholder
    final remetente = data.emitente;
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('REMETENTE',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 45,
                child: _boxWithLabel(
                    height: 12,
                    label: 'NOME/RAZÃO SOCIAL',
                    child: _value(remetente.nome, size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ/CPF',
                    child: _value(remetente.cnpjFormatado, size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'INSCRIÇÃO ESTADUAL',
                    child: _value(remetente.ie ?? '', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 60,
                child: _boxWithLabel(
                    height: 12,
                    label: 'ENDEREÇO',
                    child: _value(
                        '${remetente.enderecoLogradouro}, ${remetente.enderecoNumero}',
                        size: 8))),
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'BAIRRO/DISTRITO',
                    child: _value(remetente.enderecoBairro ?? '', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'MUNICÍPIO',
                    child: _value(remetente.enderecoMunicipio ?? '', size: 8))),
            pw.Expanded(
                flex: 10,
                child: _boxWithLabel(
                    height: 12,
                    label: 'UF',
                    child: _value(remetente.enderecoUf ?? '', size: 8))),
            pw.Expanded(
                flex: 20,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CEP',
                    child: _value(remetente.cepFormatado, size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'PAÍS',
                    child:
                        _value(remetente.enderecoPais ?? 'BRASIL', size: 8))),
          ],
        ),
      ],
    );
  }

  // =========================
  // DESTINATÁRIO
  // =========================
  pw.Widget _buildDestinatario() {
    final destinatario = data.destinatario;
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('DESTINATÁRIO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 45,
                child: _boxWithLabel(
                    height: 12,
                    label: 'NOME/RAZÃO SOCIAL',
                    child: _value(destinatario.nome, size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ/CPF',
                    child: _value(destinatario.cnpjFormatado, size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'INSCRIÇÃO ESTADUAL',
                    child: _value(destinatario.ie ?? '', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 60,
                child: _boxWithLabel(
                    height: 12,
                    label: 'ENDEREÇO',
                    child: _value(
                        '${destinatario.enderecoLogradouro}, ${destinatario.enderecoNumero}',
                        size: 8))),
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'BAIRRO/DISTRITO',
                    child: _value(destinatario.enderecoBairro ?? '', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'MUNICÍPIO',
                    child:
                        _value(destinatario.enderecoMunicipio ?? '', size: 8))),
            pw.Expanded(
                flex: 10,
                child: _boxWithLabel(
                    height: 12,
                    label: 'UF',
                    child: _value(destinatario.enderecoUf ?? '', size: 8))),
            pw.Expanded(
                flex: 20,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CEP',
                    child: _value(destinatario.cepFormatado, size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'PAÍS',
                    child: _value(destinatario.enderecoPais ?? 'BRASIL',
                        size: 8))),
          ],
        ),
      ],
    );
  }

  // =========================
  // EXPEDIDOR
  // =========================
  pw.Widget _buildExpedidor() {
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('EXPEDIDOR',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 45,
                child: _boxWithLabel(
                    height: 12,
                    label: 'NOME/RAZÃO SOCIAL',
                    child: _value('', size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12, label: 'CNPJ/CPF', child: _value('', size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'INSCRIÇÃO ESTADUAL',
                    child: _value('', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 60,
                child: _boxWithLabel(
                    height: 12, label: 'ENDEREÇO', child: _value('', size: 8))),
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'BAIRRO/DISTRITO',
                    child: _value('', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'MUNICÍPIO',
                    child: _value('', size: 8))),
            pw.Expanded(
                flex: 10,
                child: _boxWithLabel(
                    height: 12, label: 'UF', child: _value('', size: 8))),
            pw.Expanded(
                flex: 20,
                child: _boxWithLabel(
                    height: 12, label: 'CEP', child: _value('', size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12, label: 'PAÍS', child: _value('', size: 8))),
          ],
        ),
      ],
    );
  }

  // =========================
  // RECEBEDOR
  // =========================
  pw.Widget _buildRecebedor() {
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('RECEBEDOR',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 45,
                child: _boxWithLabel(
                    height: 12,
                    label: 'NOME/RAZÃO SOCIAL',
                    child: _value('', size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12, label: 'CNPJ/CPF', child: _value('', size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'INSCRIÇÃO ESTADUAL',
                    child: _value('', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 60,
                child: _boxWithLabel(
                    height: 12, label: 'ENDEREÇO', child: _value('', size: 8))),
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'BAIRRO/DISTRITO',
                    child: _value('', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'MUNICÍPIO',
                    child: _value('', size: 8))),
            pw.Expanded(
                flex: 10,
                child: _boxWithLabel(
                    height: 12, label: 'UF', child: _value('', size: 8))),
            pw.Expanded(
                flex: 20,
                child: _boxWithLabel(
                    height: 12, label: 'CEP', child: _value('', size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12, label: 'PAÍS', child: _value('', size: 8))),
          ],
        ),
      ],
    );
  }

  // =========================
  // TOMADOR DO SERVIÇO
  // =========================
  pw.Widget _buildTomadorServico() {
    // Usando dados do destinatário como tomador do serviço
    final tomador = data.destinatario;
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('TOMADOR DO SERVIÇO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 45,
                child: _boxWithLabel(
                    height: 12,
                    label: 'NOME/RAZÃO SOCIAL',
                    child: _value(tomador.nome, size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ/CPF',
                    child: _value(tomador.cnpjFormatado, size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'INSCRIÇÃO ESTADUAL',
                    child: _value(tomador.ie ?? '', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 60,
                child: _boxWithLabel(
                    height: 12,
                    label: 'ENDEREÇO',
                    child: _value(
                        '${tomador.enderecoLogradouro}, ${tomador.enderecoNumero}',
                        size: 8))),
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'BAIRRO/DISTRITO',
                    child: _value(tomador.enderecoBairro ?? '', size: 8))),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
                flex: 40,
                child: _boxWithLabel(
                    height: 12,
                    label: 'MUNICÍPIO',
                    child: _value(tomador.enderecoMunicipio ?? '', size: 8))),
            pw.Expanded(
                flex: 10,
                child: _boxWithLabel(
                    height: 12,
                    label: 'UF',
                    child: _value(tomador.enderecoUf ?? '', size: 8))),
            pw.Expanded(
                flex: 20,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CEP',
                    child: _value(tomador.cepFormatado, size: 8))),
            pw.Expanded(
                flex: 30,
                child: _boxWithLabel(
                    height: 12,
                    label: 'PAÍS',
                    child: _value(tomador.enderecoPais ?? 'BRASIL', size: 8))),
          ],
        ),
      ],
    );
  }

  // =========================
  // DADOS DO CT-e (SIMPLIFICADO)
  // =========================
  pw.Widget _buildDadosCte() {
    return pw.Column(
      children: [
        pw.Row(
          children: [
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CFOP - NATUREZA DA OPERAÇÃO',
                    child: _value(data.cfopPrincipal.toString(), size: 8))),
            pw.Expanded(
                child: _boxWithLabel(
                    height: 12,
                    label: 'INÍCIO DA PRESTAÇÃO',
                    child: _value(data.emitente.enderecoMunicipio ?? '',
                        size: 8))),
            pw.Expanded(
                child: _boxWithLabel(
                    height: 12,
                    label: 'TÉRMINO DA PRESTAÇÃO',
                    child: _value(data.destinatario.enderecoMunicipio ?? '',
                        size: 8))),
          ],
        ),
      ],
    );
  }

  // =========================
  // DOCUMENTOS ORIGINÁRIOS
  // =========================
  pw.Widget _buildDocumentosOriginarios() {
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('DOCUMENTOS ORIGINÁRIOS',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Container(
          height: 30,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
          ),
          child: pw.Row(
            children: [
              pw.Expanded(
                flex: 15,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      right: pw.BorderSide(color: PdfColors.black, width: 0.5),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        height: 8,
                        color: PdfColors.grey100,
                        child: pw.Center(
                          child: pw.Text('TIPO DOC',
                              style: pw.TextStyle(
                                  fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Center(
                          child:
                              pw.Text('NFe', style: pw.TextStyle(fontSize: 8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 20,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      right: pw.BorderSide(color: PdfColors.black, width: 0.5),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        height: 8,
                        color: PdfColors.grey100,
                        child: pw.Center(
                          child: pw.Text('CNPJ/CPF EMITENTE',
                              style: pw.TextStyle(
                                  fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Center(
                          child: pw.Text(data.emitente.cnpjFormatado,
                              style: pw.TextStyle(fontSize: 8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 15,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      right: pw.BorderSide(color: PdfColors.black, width: 0.5),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        height: 8,
                        color: PdfColors.grey100,
                        child: pw.Center(
                          child: pw.Text('SÉRIE',
                              style: pw.TextStyle(
                                  fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Center(
                          child: pw.Text('1', style: pw.TextStyle(fontSize: 8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 15,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      right: pw.BorderSide(color: PdfColors.black, width: 0.5),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        height: 8,
                        color: PdfColors.grey100,
                        child: pw.Center(
                          child: pw.Text('NRO. DOC',
                              style: pw.TextStyle(
                                  fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Center(
                          child: pw.Text('123456',
                              style: pw.TextStyle(fontSize: 8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.Expanded(
                flex: 35,
                child: pw.Column(
                  children: [
                    pw.Container(
                      height: 8,
                      color: PdfColors.grey100,
                      child: pw.Center(
                        child: pw.Text('CHAVE DE ACESSO',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Center(
                        child: pw.Text(
                            '5523 1234 5678 9012 3456 7890 1234 5678 9012 3456 7890',
                            style: pw.TextStyle(fontSize: 6)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // COMPONENTES DO VALOR DA PRESTAÇÃO DO SERVIÇO
  // =========================
  pw.Widget _buildComponentesValor() {
    return pw.Column(
      children: [
        pw.Container(
          height: 12,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('COMPONENTES DO VALOR DA PRESTAÇÃO DO SERVIÇO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        // Layout horizontal dos componentes
        pw.Container(
          height: 40,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
          ),
          child: pw.Row(
            children: [
              // Coluna NOME
              pw.Expanded(
                flex: 60,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      right: pw.BorderSide(color: PdfColors.black, width: 0.5),
                    ),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Container(
                        height: 8,
                        color: PdfColors.grey100,
                        child: pw.Center(
                          child: pw.Text('NOME',
                              style: pw.TextStyle(
                                  fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Frete Peso',
                                  style: pw.TextStyle(fontSize: 7)),
                              pw.Text('Frete Valor',
                                  style: pw.TextStyle(fontSize: 7)),
                              pw.Text('Sec/Cat (Seguro)',
                                  style: pw.TextStyle(fontSize: 7)),
                              pw.Text('Despacho',
                                  style: pw.TextStyle(fontSize: 7)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Coluna VALOR
              pw.Expanded(
                flex: 40,
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
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text('450,00', style: pw.TextStyle(fontSize: 7)),
                            pw.Text('30,00', style: pw.TextStyle(fontSize: 7)),
                            pw.Text('15,00', style: pw.TextStyle(fontSize: 7)),
                            pw.Text('5,00', style: pw.TextStyle(fontSize: 7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // IMPOSTO
  // =========================
  pw.Widget _buildImposto() {
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('INFORMAÇÕES RELATIVAS AO IMPOSTO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'SITUAÇÃO TRIBUTÁRIA',
                  child: _value('00 - Tributação normal', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'BASE DE CÁLCULO',
                  child: _value(
                      data.valorBaseCalculoIcms
                          .toStringAsFixed(2)
                          .replaceAll('.', ','),
                      size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'ALÍQ ICMS',
                  child: _value('0,00%', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'VALOR ICMS',
                  child: _value(
                      data.valorIcms.toStringAsFixed(2).replaceAll('.', ','),
                      size: 8)),
            ),
          ],
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: '% RED. BC ICMS',
                  child: _value('0,00', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12, label: 'ICMS ST', child: _value('0,00', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12, label: 'CIOT', child: _value('', size: 8)),
            ),
            pw.Expanded(
              child: pw.Container(), // Espaço vazio
            ),
          ],
        )
      ],
    );
  }

  // =========================
  // VALORES
  // =========================
  pw.Widget _buildValores() {
    return pw.Row(
      children: [
        pw.Expanded(
          flex: 70,
          child: pw.Container(), // Espaço vazio
        ),
        pw.Expanded(
          flex: 30,
          child: pw.Column(
            children: [
              _boxWithLabel(
                  height: 14,
                  label: 'VALOR TOTAL DO SERVIÇO',
                  child: _value(
                      'R\$ ${data.valorTotalNota.toStringAsFixed(2).replaceAll('.', ',')}',
                      size: 10,
                      bold: true)),
              _boxWithLabel(
                  height: 14,
                  label: 'VALOR A RECEBER',
                  child: _value(
                      'R\$ ${data.valorTotalNota.toStringAsFixed(2).replaceAll('.', ',')}',
                      size: 10,
                      bold: true)),
            ],
          ),
        ),
      ],
    );
  }

  // =========================
  // INFORMAÇÕES DA CARGA
  // =========================
  pw.Widget _buildCarga() {
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('INFORMAÇÕES DA CARGA',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 50,
              child: _boxWithLabel(
                  height: 12,
                  label: 'PRODUTO PREDOMINANTE',
                  child: _value(data.itens.first.descricaoProduto, size: 8)),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12,
                  label: 'OUTRAS CARACTERÍSTICAS DA CARGA',
                  child: _value('', size: 8)),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12,
                  label: 'VALOR TOTAL DA MERCADORIA',
                  child: _value(
                      data.valorTotalProdutos
                          .toStringAsFixed(2)
                          .replaceAll('.', ','),
                      size: 8)),
            ),
          ],
        ),
        // Tabela de Peso/Cubagem
        pw.Container(
          height: 10,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'PESO / CUBAGEM',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'PESO TOTAL (KG)',
                  child: _value(
                      data.transporte.pesoBruto?.toStringAsFixed(3) ?? '0,000',
                      size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'CUBAGEM (M³)',
                  child: _value('0,000', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'TP MED /UN. MED',
                  child: _value('PESO/KG', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'VOLUMES',
                  child: _value(data.transporte.quantidadeVolumes ?? '1',
                      size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12,
                  label: 'QTDE(VOL)',
                  child: _value(data.transporte.quantidadeVolumes ?? '1',
                      size: 8)),
            ),
          ],
        ),
        // Seção de Seguro
        pw.Container(
          height: 10,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Center(
            child: pw.Text(
              'SEGURO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12, label: 'SEGURADORA', child: _value('', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12, label: 'APÓLICE', child: _value('', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 12, label: 'AVERBAÇÃO', child: _value('', size: 8)),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // MODAL RODOVIÁRIO
  // =========================
  pw.Widget _buildModalRodoviario() {
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
              'DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO - CARGA FRACIONADA',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                  height: 12,
                  label: 'RNTRC DA EMPRESA',
                  child: _value(data.transporte.rntcVeiculo ?? '', size: 8)),
            ),
            pw.Expanded(
              flex: 30,
              child: _boxWithLabel(
                  height: 12,
                  label: 'ESTE CT-E É DE COMPLEMENTO DE VALORES',
                  child: _value('Não', size: 8)),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12,
                  label: 'CHAVE DO CT-E COMPLEMENTADO',
                  child: _value('', size: 8)),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12,
                  label: 'VALOR DO SERVIÇO',
                  child: _value(
                      'R\$ ${data.valorTotalNota.toStringAsFixed(2).replaceAll('.', ',')}',
                      size: 8)),
            ),
          ],
        ),
      ],
    );
  }

  // =========================
  // RESERVADO AO FISCO
  // =========================
  pw.Widget _buildReservadoFisco() {
    return pw.Column(
      children: [
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
            color: PdfColors.grey100,
          ),
          alignment: pw.Alignment.center,
          child: pw.Text('RESERVADO AO FISCO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Container(
          height: 20,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.all(2),
            child: pw.Text(
              'Espaço reservado para uso exclusivo da fiscalização tributária',
              style: pw.TextStyle(fontSize: 6, fontStyle: pw.FontStyle.italic),
            ),
          ),
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
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 65,
              child: _box(
                height: 40,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'OBSERVAÇÕES',
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Valor aproximado dos tributos: R\$ ${(data.valorTotalNota * 0.15).toStringAsFixed(2).replaceAll('.', ',')} (15,00%)',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'EMPRESA OPTANTE PELO SIMPLES NACIONAL',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'NÃO GERA CRÉDITO DE ICMS',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'CONDUTOR: ${data.transporte.nomeTransportador ?? 'NÃO INFORMADO'}',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'PLACA: ${data.transporte.placaVeiculo ?? 'NÃO INFORMADA'} ${data.transporte.ufVeiculo ?? ''} TP: CAMINHÃO RENAVAM: ${data.transporte.rntcVeiculo ?? 'NÃO INFORMADO'}',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                  ],
                ),
              ),
            ),
            pw.Expanded(
              flex: 35,
              child: _box(
                height: 40,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'USO EXCLUSIVO DO EMISSOR DO CT-E',
                      style: pw.TextStyle(
                          fontSize: 6, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Informações internas da transportadora',
                      style: pw.TextStyle(fontSize: 6),
                    ),
                    pw.Text(
                      'Controle interno: ${data.numeroDocumento}',
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

  pw.Widget _buildFooter() {
    final now = DateTime.now();
    final dataHora =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} às ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return pw.Container(
      height: 15,
      child: pw.Center(
        child: pw.Text(
          'DACTE - Documento Auxiliar do Conhecimento de Transporte Eletrônico - Impresso em $dataHora',
          style: pw.TextStyle(fontSize: 6),
        ),
      ),
    );
  }
}
