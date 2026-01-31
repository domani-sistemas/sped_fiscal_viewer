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
          _buildCanhotoCte(),
          _buildHeader(),
          _buildRemetente(),
          _buildDestinatario(),
          _buildExpedidor(),
          _buildRecebedor(),
          _buildTomadorServico(),
          _buildDocumentosOriginarios(), // Nova seção adicionada
          _buildComponentesValor(),
          _buildImposto(),
          _buildValores(),
          _buildCarga(),
          _buildSeguro(),
          _buildModalRodoviario(),
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
    return pw.Container(
      height: 35,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(2),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Text(
              'DECLARO QUE RECEBI OS VOLUMES DESTE CONHECIMENTO EM PERFEITO ESTADO PELO QUE DOU POR CUMPRIDO O PRESENTE CONTRATO DE TRANSPORTE',
              style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'NOME: _________________ RG: _______ ASSINATURA/CARIMBO: _______',
              style: pw.TextStyle(fontSize: 6),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                    'TÉRMINO DA PRESTAÇÃO - DATA/HORA: ___/___/______ ___:___',
                    style: pw.TextStyle(fontSize: 6)),
                pw.Text(
                    'INÍCIO DA PRESTAÇÃO - DATA/HORA: ___/___/______ ___:___',
                    style: pw.TextStyle(fontSize: 6)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                    'CT-e  Nº. ${data.numeroDocumento} Serie ${data.serie}  ${data.dataEmissaoFormatada}',
                    style: pw.TextStyle(
                        fontSize: 6, fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ],
        ),
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
                height: 120,
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
                      data.emitente.nome.toUpperCase(),
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
                      'Fone/Fax: ${data.emitente.enderecoTelefone ?? ''}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'CNPJ / CPF: ${data.emitente.cnpjFormatado}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'Insc. Estadual: ${data.emitente.ie ?? ''}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ),
            ),
            // Coluna central - DACTE e Campos de Tipo (20%)
            pw.Expanded(
              flex: 20,
              child: pw.Container(
                height: 120,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(3),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _label('TIPO DO CTE'),
                    _value('0 - Normal', size: 7),
                    pw.SizedBox(height: 1),
                    _label('TIPO DO SERVIÇO'),
                    _value('0 - Normal', size: 7),
                    pw.SizedBox(height: 1),
                    _label('TOMADOR DO SERVIÇO'),
                    _value('3 - Destinatário', size: 7),
                    pw.SizedBox(height: 2),
                    pw.Center(
                      child: pw.Text(
                        'DACTE',
                        style: pw.TextStyle(
                            fontSize: 10, fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Center(
                      child: pw.Text('Documento Auxiliar do',
                          style: pw.TextStyle(fontSize: 5)),
                    ),
                    pw.Center(
                      child: pw.Text('Conhecimento de Transporte',
                          style: pw.TextStyle(fontSize: 5)),
                    ),
                    pw.Center(
                      child: pw.Text('Eletrônico',
                          style: pw.TextStyle(fontSize: 5)),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Row(
                      children: [
                        pw.Text('MODAL: ',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Rodoviário', style: pw.TextStyle(fontSize: 6)),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('MODELO: ',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        pw.Text('57', style: pw.TextStyle(fontSize: 6)),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('SÉRIE: ',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        pw.Text(data.serie, style: pw.TextStyle(fontSize: 6)),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('NÚMERO: ',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        pw.Text('${data.numeroDocumento}',
                            style: pw.TextStyle(fontSize: 6)),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Text('FL: ',
                            style: pw.TextStyle(
                                fontSize: 6, fontWeight: pw.FontWeight.bold)),
                        pw.Text('1/1', style: pw.TextStyle(fontSize: 6)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Coluna direita - Código de barras, Chave e Protocolo (40%)
            pw.Expanded(
              flex: 40,
              child: pw.Container(
                height: 120,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                padding: const pw.EdgeInsets.all(3),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                    pw.SizedBox(height: 2),
                    _label('CHAVE DE ACESSO'),
                    pw.Text(
                      _formatarChaveAcessoDacte(data.chaveAcesso),
                      style: pw.TextStyle(fontSize: 7, font: pw.Font.courier()),
                      maxLines: 2,
                    ),
                    pw.SizedBox(height: 1),
                    pw.Text(
                      'Consulta de autenticidade no portal nacional do CT-e',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(fontSize: 5),
                    ),
                    pw.SizedBox(height: 4),
                    _label('PROTOCOLO DE AUTORIZAÇÃO DE USO'),
                    _value(
                        '135240000000000 - ${data.dataEmissaoFormatada} 10:30:00',
                        size: 7),
                    pw.SizedBox(height: 4),
                    _label('DATA/HORA EMISSÃO'),
                    _value('${data.dataEmissaoFormatada} 10:30:00', size: 7),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Segunda linha do header - Natureza e Prestação
        pw.Row(
          children: [
            pw.Expanded(
              flex: 60,
              child: _boxWithLabel(
                height: 25,
                label: 'CFOP - NATUREZA DA OPERAÇÃO',
                child: _value('5351 - TRANSPORTE DE CARGA', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 40,
              child: pw.Container(
                height: 25,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 0.5),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                        decoration: pw.BoxDecoration(
                          border: pw.Border(
                              right: pw.BorderSide(
                                  color: PdfColors.black, width: 0.5)),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            _label('INÍCIO DA PRESTAÇÃO'),
                            _value('SÃO PAULO - SP', size: 7),
                          ],
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            _label('TÉRMINO DA PRESTAÇÃO'),
                            _value('BELO HORIZONTE - MG', size: 7),
                          ],
                        ),
                      ),
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
                    label: 'NOME / RAZÃO SOCIAL',
                    child: _value(remetente.nome.toUpperCase(), size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ / CPF',
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
                    label: 'BAIRRO / DISTRITO',
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
                    child: _value(
                        remetente.enderecoPais?.toUpperCase() ?? 'BRASIL',
                        size: 8))),
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
                    label: 'NOME / RAZÃO SOCIAL',
                    child: _value(destinatario.nome.toUpperCase(), size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ / CPF',
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
                    label: 'BAIRRO / DISTRITO',
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
                    label: 'NOME / RAZÃO SOCIAL',
                    child: _value('', size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ / CPF',
                    child: _value('', size: 8))),
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
                    label: 'BAIRRO / DISTRITO',
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
                    label: 'NOME / RAZÃO SOCIAL',
                    child: _value('', size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ / CPF',
                    child: _value('', size: 8))),
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
                    label: 'BAIRRO / DISTRITO',
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
                    label: 'NOME / RAZÃO SOCIAL',
                    child: _value(tomador.nome.toUpperCase(), size: 8))),
            pw.Expanded(
                flex: 25,
                child: _boxWithLabel(
                    height: 12,
                    label: 'CNPJ / CPF',
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
                    label: 'BAIRRO / DISTRITO',
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
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _tableHeaderCell('TIPO DOC'),
                _tableHeaderCell('CNPJ / CPF EMITENTE'),
                _tableHeaderCell('SÉRIE'),
                _tableHeaderCell('NRO. DOC'),
                _tableHeaderCell('CHAVE DE ACESSO'),
              ],
            ),
            pw.TableRow(
              children: [
                _tableCell('NFe'),
                _tableCell(data.emitente.cnpjFormatado),
                _tableCell('1'),
                _tableCell('123456'),
                _tableCell(
                    '5523 1234 5678 9012 3456 7890 1234 5678 9012 3456 7890',
                    size: 6),
              ],
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(1),
      child: pw.Center(
        child: pw.Text(text,
            style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
      ),
    );
  }

  pw.Widget _tableCell(String text, {double size = 7}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(1),
      child: pw.Center(
        child: pw.Text(text, style: pw.TextStyle(fontSize: size)),
      ),
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
        pw.Container(
          height: 30, // Reduzido para ser mais compacto
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 0.5),
          ),
          child: pw.Row(
            children: [
              _buildComponenteItem('NOME', 'Frete Peso', flex: 25),
              _buildComponenteItem('VALOR', '450,00', flex: 15, alignEnd: true),
              _buildComponenteItem('NOME', 'Frete Valor', flex: 25),
              _buildComponenteItem('VALOR', '30,00', flex: 15, alignEnd: true),
              _buildComponenteItem('NOME', 'OUTROS', flex: 10),
              _buildComponenteItem('VALOR', '0,00', flex: 10, alignEnd: true),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildComponenteItem(String label, String value,
      {int flex = 1, bool alignEnd = false}) {
    return pw.Expanded(
      flex: flex,
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
              width: double.infinity,
              color: PdfColors.grey100,
              child: pw.Center(
                child: pw.Text(label,
                    style: pw.TextStyle(
                        fontSize: 6, fontWeight: pw.FontWeight.bold)),
              ),
            ),
            pw.Expanded(
              child: pw.Container(
                alignment: alignEnd
                    ? pw.Alignment.centerRight
                    : pw.Alignment.centerLeft,
                padding: const pw.EdgeInsets.symmetric(horizontal: 2),
                child: pw.Text(value, style: pw.TextStyle(fontSize: 7)),
              ),
            ),
          ],
        ),
      ),
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
        // Produto predominante
        pw.Container(
          height: 10,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0.5),
            color: PdfColors.grey100,
          ),
          padding: const pw.EdgeInsets.only(left: 2),
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'PRODUTO PREDOMINANTE',
            style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Container(
          height: 12,
          width: double.infinity,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0.5),
          ),
          padding: const pw.EdgeInsets.only(left: 2),
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'Transporte Rodoviário de Carga', // Fallback value since model is missing produtoPredominante
            style: pw.TextStyle(fontSize: 8),
          ),
        ),

        // Outras características e valor
        pw.Row(
          children: [
            pw.Expanded(
              flex: 65,
              child: _boxWithLabel(
                height: 12,
                label: 'OUTRAS CARACTERÍSTICAS DA CARGA',
                child: _value(
                    'ESPECIE: ${data.transporte.especieVolumes ?? ""}',
                    size: 8),
              ),
            ),
            pw.Expanded(
              flex: 35,
              child: _boxWithLabel(
                height: 12,
                label: 'VALOR TOTAL DA MERCADORIA',
                child: _value(
                  'R\$ ${data.valorTotalProdutos.toStringAsFixed(2).replaceAll('.', ',')}',
                  size: 8,
                ),
              ),
            ),
          ],
        ),

        // Peso, volumes, cubagem - linha 1
        pw.Row(
          children: [
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 12,
                label: 'TP MED/UN.MED',
                child: _value('PESO/KG', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 30,
              child: _boxWithLabel(
                height: 12,
                label: 'PESO DECLARADO',
                child: _value(
                  '${data.transporte.pesoBruto?.toStringAsFixed(3).replaceAll('.', ',') ?? '0,000'} KG',
                  size: 8,
                ),
              ),
            ),
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 12,
                label: 'TP MED/UN.MED',
                child: _value('UN', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 30,
              child: _boxWithLabel(
                height: 12,
                label: 'VOLUMES',
                child:
                    _value(data.transporte.quantidadeVolumes ?? '1', size: 8),
              ),
            ),
          ],
        ),

        // Cubagem e quantidade - linha 2
        pw.Row(
          children: [
            pw.Expanded(
              flex: 20,
              child: _boxWithLabel(
                height: 12,
                label: 'TP MED/UN.MED',
                child: _value('M3', size: 8),
              ),
            ),
            pw.Expanded(
              flex: 30,
              child: _boxWithLabel(
                height: 12,
                label: 'CUBAGEM(M³)',
                child: _value(
                  '0,000', // Fallback value since model is missing cubagem
                  size: 8,
                ),
              ),
            ),
            pw.Expanded(
              flex: 50,
              child: _boxWithLabel(
                height: 12,
                label: 'QTDE(VOL)',
                child:
                    _value(data.transporte.quantidadeVolumes ?? '1', size: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSeguro() {
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
          child: pw.Text('INFORMAÇÕES DO SEGURO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12,
                  label: 'RESPONSÁVEL',
                  child: _value('4-REMETENTE', size: 8)),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12, label: 'SEGURADORA', child: _value('', size: 8)),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12,
                  label: 'NÚMERO DA APÓLICE',
                  child: _value('', size: 8)),
            ),
            pw.Expanded(
              flex: 25,
              child: _boxWithLabel(
                  height: 12,
                  label: 'NÚMERO DA AVERBAÇÃO',
                  child: _value('', size: 8)),
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
              'DADOS ESPECÍFICOS DO MODAL RODOVIÁRIO',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
        pw.Row(
          children: [
            pw.Expanded(
              child: _boxWithLabel(
                  height: 14,
                  label: 'RNTRC DO TRANSPORTADOR',
                  child: _value(data.transporte.rntcVeiculo ?? '', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 14, label: 'CIOT', child: _value('', size: 8)),
            ),
            pw.Expanded(
              child: _boxWithLabel(
                  height: 14,
                  label: 'DATA PREVISTA DE ENTREGA',
                  child: _value(data.dataEmissaoFormatada, size: 8)),
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

  String _formatarChaveAcessoDacte(String chave) {
    if (chave.length != 44) return chave;

    // Estrutura da chave CT-e (44 dígitos):
    // UF (2) + AAMM (4) + CNPJ (14) + Modelo (2) + Série (3) + Número (9) + Código (8) + DV (2)
    final uf = chave.substring(0, 2);
    final aamm = chave.substring(2, 6);
    final cnpj = chave.substring(6, 20);
    final modelo = chave.substring(20, 22);
    final serie = chave.substring(22, 25);
    final numero = chave.substring(25, 34);
    final codigo = chave.substring(34, 42);
    final dv = chave.substring(42, 44);

    return '$uf.$aamm.$cnpj-$modelo-$serie-$numero-$codigo-$dv';
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
          'DACTE - Documento Auxiliar do Conhecimento de Transporte Eletrônico - Impresso em $dataStr as $horaStr',
          style: pw.TextStyle(fontSize: 6),
        ),
      ),
    );
  }
}
