import 'participante.dart';
import 'item_documento.dart';
import 'transporte.dart';
import 'impostos.dart';

/// Modelo que representa um documento fiscal genérico (NFe, CTe, NFCe, etc.)
class DocumentoFiscal {
  final int? id;
  final int idEstabelecimento;
  final String chaveAcesso;
  final String tipoDocumento; // 'NFE', 'CTE', 'NFCE', etc.
  final String modelo;
  final String serie;
  final int numeroDocumento;
  final DateTime dataEmissao;
  final DateTime? dataEntradaSaida;
  final int cfopPrincipal;
  final String tipoOperacao; // 'E' ou 'S'
  final Participante emitente;
  final Participante destinatario;
  final double valorBaseCalculoIcms;
  final double valorIcms;
  final double valorIpi;
  final double valorPis;
  final double valorCofins;
  final double valorTotalProdutos;
  final double valorTotalNota;
  final String status; // 'ATIVA', 'CANCELADA', 'ANULADA'
  final String? caminhoXml;
  final List<ItemDocumentoFiscal> itens;
  final Transporte transporte;
  final Impostos impostos;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentoFiscal({
    this.id,
    required this.idEstabelecimento,
    required this.chaveAcesso,
    required this.tipoDocumento,
    required this.modelo,
    required this.serie,
    required this.numeroDocumento,
    required this.dataEmissao,
    this.dataEntradaSaida,
    required this.cfopPrincipal,
    required this.tipoOperacao,
    required this.emitente,
    required this.destinatario,
    this.valorBaseCalculoIcms = 0.0,
    this.valorIcms = 0.0,
    this.valorIpi = 0.0,
    this.valorPis = 0.0,
    this.valorCofins = 0.0,
    this.valorTotalProdutos = 0.0,
    required this.valorTotalNota,
    this.status = 'ATIVA',
    this.caminhoXml,
    required this.itens,
    required this.transporte,
    required this.impostos,
    required this.createdAt,
    required this.updatedAt,
  });

  // =========================
  // Métodos auxiliares
  // =========================

  /// Retorna o tipo de documento formatado para exibição
  String get tipoDocumentoFormatado {
    switch (tipoDocumento) {
      case 'NFE':
        return 'NF-e';
      case 'CTE':
        return 'CT-e';
      case 'NFCE':
        return 'NFC-e';
      default:
        return tipoDocumento;
    }
  }

  /// Retorna o número e série formatados
  String get numeroSerieFormatado => '$numeroDocumento/$serie';

  /// Retorna a cor apropriada para o status
  /*Color get statusColor {
    switch (status) {
      case 'ATIVA':
        return Colors.green;
      case 'CANCELADA':
        return Colors.red;
      case 'ANULADA':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }*/

  /// Retorna a opção de visualização baseada no tipo de documento
  String get opcaoVisualizacao => 'Visualizar $tipoDocumentoFormatado';

  /// Verifica se é uma operação de entrada
  bool get isEntrada => tipoOperacao == 'E';

  /// Verifica se é uma operação de saída
  bool get isSaida => tipoOperacao == 'S';

  /// Retorna o tipo de operação formatado
  String get tipoOperacaoFormatado => isEntrada ? 'Entrada' : 'Saída';

  /// Verifica se o documento está ativo
  bool get isAtivo => status == 'ATIVA';

  /// Verifica se o documento está cancelado
  bool get isCancelado => status == 'CANCELADA';

  /// Verifica se o documento está anulado
  bool get isAnulado => status == 'ANULADA';

  /// Retorna o status formatado para exibição
  String get statusFormatado {
    switch (status) {
      case 'ATIVA':
        return 'Ativa';
      case 'CANCELADA':
        return 'Cancelada';
      case 'ANULADA':
        return 'Anulada';
      default:
        return status;
    }
  }

  /// Retorna o valor total da nota formatado como moeda
  String get valorTotalFormatado {
    return 'R\$ ${valorTotalNota.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor total dos produtos formatado como moeda
  String get valorTotalProdutosFormatado {
    return 'R\$ ${valorTotalProdutos.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do ICMS formatado como moeda
  String get valorIcmsFormatado {
    return 'R\$ ${valorIcms.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do IPI formatado como moeda
  String get valorIpiFormatado {
    return 'R\$ ${valorIpi.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do PIS formatado como moeda
  String get valorPisFormatado {
    return 'R\$ ${valorPis.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do COFINS formatado como moeda
  String get valorCofinsFormatado {
    return 'R\$ ${valorCofins.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna a data de emissão formatada
  String get dataEmissaoFormatada {
    return '${dataEmissao.day.toString().padLeft(2, '0')}/${dataEmissao.month.toString().padLeft(2, '0')}/${dataEmissao.year}';
  }

  /// Retorna a data de entrada/saída formatada ou "N/A"
  String get dataEntradaSaidaFormatada {
    if (dataEntradaSaida == null) return 'N/A';
    return '${dataEntradaSaida!.day.toString().padLeft(2, '0')}/${dataEntradaSaida!.month.toString().padLeft(2, '0')}/${dataEntradaSaida!.year}';
  }

  /// Retorna a chave de acesso formatada
  String get chaveAcessoFormatada {
    if (chaveAcesso.length != 44) return chaveAcesso;
    return '${chaveAcesso.substring(0, 4)} ${chaveAcesso.substring(4, 8)} ${chaveAcesso.substring(8, 12)} ${chaveAcesso.substring(12, 16)} ${chaveAcesso.substring(16, 20)} ${chaveAcesso.substring(20, 24)} ${chaveAcesso.substring(24, 28)} ${chaveAcesso.substring(28, 32)} ${chaveAcesso.substring(32, 36)} ${chaveAcesso.substring(36, 40)} ${chaveAcesso.substring(40, 44)}';
  }

  // =========================
  // Serialização JSON
  // =========================

  factory DocumentoFiscal.fromJson(Map<String, dynamic> json) {
    return DocumentoFiscal(
      id: json['id'] as int?,
      idEstabelecimento: json['id_estabelecimento'] as int,
      chaveAcesso: json['chave_acesso'] as String,
      tipoDocumento: json['tipo_documento'] as String,
      modelo: json['modelo'] as String,
      serie: json['serie'] as String,
      numeroDocumento: json['numero_documento'] as int,
      dataEmissao: DateTime.parse(json['data_emissao'] as String),
      dataEntradaSaida: json['data_entrada_saida'] != null
          ? DateTime.parse(json['data_entrada_saida'] as String)
          : null,
      cfopPrincipal: json['cfop_principal'] as int,
      tipoOperacao: json['tipo_operacao'] as String,
      emitente: Participante.fromJson(json['emitente'] as Map<String, dynamic>),
      destinatario: Participante.fromJson(json['destinatario'] as Map<String, dynamic>),
      valorBaseCalculoIcms:
          (json['valor_base_calculo_icms'] as num?)?.toDouble() ?? 0.0,
      valorIcms: (json['valor_icms'] as num?)?.toDouble() ?? 0.0,
      valorIpi: (json['valor_ipi'] as num?)?.toDouble() ?? 0.0,
      valorPis: (json['valor_pis'] as num?)?.toDouble() ?? 0.0,
      valorCofins: (json['valor_cofins'] as num?)?.toDouble() ?? 0.0,
      valorTotalProdutos:
          (json['valor_total_produtos'] as num?)?.toDouble() ?? 0.0,
      valorTotalNota: (json['valor_total_nota'] as num).toDouble(),
      status: json['status'] as String? ?? 'ATIVA',
      caminhoXml: json['caminho_xml'] as String?,
      itens: (json['itens'] as List<dynamic>)
          .map((item) => ItemDocumentoFiscal.fromJson(item as Map<String, dynamic>))
          .toList(),
      transporte: Transporte.fromJson(json['transporte'] as Map<String, dynamic>),
      impostos: Impostos.fromJson(json['impostos'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_estabelecimento': idEstabelecimento,
      'chave_acesso': chaveAcesso,
      'tipo_documento': tipoDocumento,
      'modelo': modelo,
      'serie': serie,
      'numero_documento': numeroDocumento,
      'data_emissao': dataEmissao.toIso8601String(),
      'data_entrada_saida': dataEntradaSaida?.toIso8601String(),
      'cfop_principal': cfopPrincipal,
      'tipo_operacao': tipoOperacao,
      'emitente': emitente.toJson(),
      'destinatario': destinatario.toJson(),
      'valor_base_calculo_icms': valorBaseCalculoIcms,
      'valor_icms': valorIcms,
      'valor_ipi': valorIpi,
      'valor_pis': valorPis,
      'valor_cofins': valorCofins,
      'valor_total_produtos': valorTotalProdutos,
      'valor_total_nota': valorTotalNota,
      'status': status,
      'caminho_xml': caminhoXml,
      'itens': itens.map((item) => item.toJson()).toList(),
      'transporte': transporte.toJson(),
      'impostos': impostos.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // =========================
  // Métodos de cópia
  // =========================

  DocumentoFiscal copyWith({
    int? id,
    int? idEstabelecimento,
    String? chaveAcesso,
    String? tipoDocumento,
    String? modelo,
    String? serie,
    int? numeroDocumento,
    DateTime? dataEmissao,
    DateTime? dataEntradaSaida,
    int? cfopPrincipal,
    String? tipoOperacao,
    Participante? emitente,
    Participante? destinatario,
    double? valorBaseCalculoIcms,
    double? valorIcms,
    double? valorIpi,
    double? valorPis,
    double? valorCofins,
    double? valorTotalProdutos,
    double? valorTotalNota,
    String? status,
    String? caminhoXml,
    List<ItemDocumentoFiscal>? itens,
    Transporte? transporte,
    Impostos? impostos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentoFiscal(
      id: id ?? this.id,
      idEstabelecimento: idEstabelecimento ?? this.idEstabelecimento,
      chaveAcesso: chaveAcesso ?? this.chaveAcesso,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      modelo: modelo ?? this.modelo,
      serie: serie ?? this.serie,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      dataEmissao: dataEmissao ?? this.dataEmissao,
      dataEntradaSaida: dataEntradaSaida ?? this.dataEntradaSaida,
      cfopPrincipal: cfopPrincipal ?? this.cfopPrincipal,
      tipoOperacao: tipoOperacao ?? this.tipoOperacao,
      emitente: emitente ?? this.emitente,
      destinatario: destinatario ?? this.destinatario,
      valorBaseCalculoIcms: valorBaseCalculoIcms ?? this.valorBaseCalculoIcms,
      valorIcms: valorIcms ?? this.valorIcms,
      valorIpi: valorIpi ?? this.valorIpi,
      valorPis: valorPis ?? this.valorPis,
      valorCofins: valorCofins ?? this.valorCofins,
      valorTotalProdutos: valorTotalProdutos ?? this.valorTotalProdutos,
      valorTotalNota: valorTotalNota ?? this.valorTotalNota,
      status: status ?? this.status,
      caminhoXml: caminhoXml ?? this.caminhoXml,
      itens: itens ?? this.itens,
      transporte: transporte ?? this.transporte,
      impostos: impostos ?? this.impostos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'DocumentoFiscal(id: $id, chaveAcesso: $chaveAcesso, tipoDocumento: $tipoDocumento, numeroDocumento: $numeroDocumento, serie: $serie, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentoFiscal && other.chaveAcesso == chaveAcesso;
  }

  @override
  int get hashCode => chaveAcesso.hashCode;
}