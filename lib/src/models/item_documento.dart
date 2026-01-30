/// Modelo que representa um item de documento fiscal
class ItemDocumentoFiscal {
  final int? id;
  final int idDocumentoFiscal;
  final int numeroItem;
  final String? codigoProduto;
  final String descricaoProduto;
  final String? ncm;
  final String? cst;
  final int cfop;
  final String unidade;
  final double quantidade;
  final double valorUnitario;
  final double valorTotalItem;
  final double? baseCalculoIcms;
  final double? valorIcms;
  final double? aliquotaIcms;
  final double? valorIpi;
  final double? aliquotaIpi;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemDocumentoFiscal({
    this.id,
    required this.idDocumentoFiscal,
    required this.numeroItem,
    this.codigoProduto,
    required this.descricaoProduto,
    this.ncm,
    this.cst,
    required this.cfop,
    required this.unidade,
    required this.quantidade,
    required this.valorUnitario,
    required this.valorTotalItem,
    this.baseCalculoIcms,
    this.valorIcms,
    this.aliquotaIcms,
    this.valorIpi,
    this.aliquotaIpi,
    required this.createdAt,
    required this.updatedAt,
  });

  // =========================
  // Métodos auxiliares
  // =========================

  /// Retorna o código do produto formatado ou "N/A" se não informado
  String get codigoProdutoFormatado => codigoProduto ?? 'N/A';

  /// Retorna o NCM formatado ou "N/A" se não informado
  String get ncmFormatado => ncm ?? 'N/A';

  /// Retorna o CST formatado ou "N/A" se não informado
  String get cstFormatado => cst ?? 'N/A';

  /// Retorna a quantidade formatada com até 4 casas decimais
  String get quantidadeFormatada {
    if (quantidade == quantidade.toInt()) {
      return quantidade.toInt().toString();
    }
    return quantidade
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  /// Retorna o valor unitário formatado como moeda
  String get valorUnitarioFormatado {
    return 'R\$ ${valorUnitario.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor total do item formatado como moeda
  String get valorTotalFormatado {
    return 'R\$ ${valorTotalItem.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do ICMS formatado como moeda ou "N/A"
  String get valorIcmsFormatado {
    if (valorIcms == null) return 'N/A';
    return 'R\$ ${valorIcms!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor da alíquota do ICMS formatado como porcentagem
  String get aliquotaIcmsFormatado {
    if (aliquotaIcms == null) return 'N/A';
    return '${aliquotaIcms!.toStringAsFixed(2)}%';
  }

  /// Retorna o valor do IPI formatado como moeda ou "N/A"
  String get valorIpiFormatado {
    if (valorIpi == null) return 'N/A';
    return 'R\$ ${valorIpi!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor da alíquota do IPI formatado como porcentagem
  String get aliquotaIpiFormatado {
    if (aliquotaIpi == null) return 'N/A';
    return '${aliquotaIpi!.toStringAsFixed(2)}%';
  }

  /// Retorna a base de cálculo do ICMS formatada como moeda ou "N/A"
  String get baseCalculoIcmsFormatada {
    if (baseCalculoIcms == null) return 'N/A';
    return 'R\$ ${baseCalculoIcms!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // =========================
  // Serialização JSON
  // =========================

  factory ItemDocumentoFiscal.fromJson(Map<String, dynamic> json) {
    return ItemDocumentoFiscal(
      id: json['id'] as int?,
      idDocumentoFiscal: json['id_documento_fiscal'] as int,
      numeroItem: json['numero_item'] as int,
      codigoProduto: json['codigo_produto'] as String?,
      descricaoProduto: json['descricao_produto'] as String,
      ncm: json['ncm'] as String?,
      cst: json['cst'] as String?,
      cfop: json['cfop'] as int,
      unidade: json['unidade'] as String,
      quantidade: (json['quantidade'] as num).toDouble(),
      valorUnitario: (json['valor_unitario'] as num).toDouble(),
      valorTotalItem: (json['valor_total_item'] as num).toDouble(),
      baseCalculoIcms: (json['base_calculo_icms'] as num?)?.toDouble(),
      valorIcms: (json['valor_icms'] as num?)?.toDouble(),
      aliquotaIcms: (json['aliquota_icms'] as num?)?.toDouble(),
      valorIpi: (json['valor_ipi'] as num?)?.toDouble(),
      aliquotaIpi: (json['aliquota_ipi'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_documento_fiscal': idDocumentoFiscal,
      'numero_item': numeroItem,
      'codigo_produto': codigoProduto,
      'descricao_produto': descricaoProduto,
      'ncm': ncm,
      'cst': cst,
      'cfop': cfop,
      'unidade': unidade,
      'quantidade': quantidade,
      'valor_unitario': valorUnitario,
      'valor_total_item': valorTotalItem,
      'base_calculo_icms': baseCalculoIcms,
      'valor_icms': valorIcms,
      'aliquota_icms': aliquotaIcms,
      'valor_ipi': valorIpi,
      'aliquota_ipi': aliquotaIpi,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // =========================
  // Métodos de cópia
  // =========================

  ItemDocumentoFiscal copyWith({
    int? id,
    int? idDocumentoFiscal,
    int? numeroItem,
    String? codigoProduto,
    String? descricaoProduto,
    String? ncm,
    String? cst,
    int? cfop,
    String? unidade,
    double? quantidade,
    double? valorUnitario,
    double? valorTotalItem,
    double? baseCalculoIcms,
    double? valorIcms,
    double? aliquotaIcms,
    double? valorIpi,
    double? aliquotaIpi,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemDocumentoFiscal(
      id: id ?? this.id,
      idDocumentoFiscal: idDocumentoFiscal ?? this.idDocumentoFiscal,
      numeroItem: numeroItem ?? this.numeroItem,
      codigoProduto: codigoProduto ?? this.codigoProduto,
      descricaoProduto: descricaoProduto ?? this.descricaoProduto,
      ncm: ncm ?? this.ncm,
      cst: cst ?? this.cst,
      cfop: cfop ?? this.cfop,
      unidade: unidade ?? this.unidade,
      quantidade: quantidade ?? this.quantidade,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      valorTotalItem: valorTotalItem ?? this.valorTotalItem,
      baseCalculoIcms: baseCalculoIcms ?? this.baseCalculoIcms,
      valorIcms: valorIcms ?? this.valorIcms,
      aliquotaIcms: aliquotaIcms ?? this.aliquotaIcms,
      valorIpi: valorIpi ?? this.valorIpi,
      aliquotaIpi: aliquotaIpi ?? this.aliquotaIpi,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ItemDocumentoFiscal(id: $id, numeroItem: $numeroItem, descricaoProduto: $descricaoProduto, valorTotalItem: $valorTotalItem)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemDocumentoFiscal &&
        other.idDocumentoFiscal == idDocumentoFiscal &&
        other.numeroItem == numeroItem;
  }

  @override
  int get hashCode => Object.hash(idDocumentoFiscal, numeroItem);
}