/// Modelo que representa as informações de impostos de um documento fiscal
class Impostos {
  final double? valorTotalTributos;
  final double? baseCalculoIcms;
  final double? valorIcms;
  final double? valorIcmsDesonerado;
  final double? baseCalculoIcmsSt;
  final double? valorIcmsSt;
  final double? valorIpi;
  final double? valorPis;
  final double? valorCofins;
  final double? valorIi; // Imposto de Importação
  final double? valorIcmsUfDest; // ICMS para a UF de destino
  final double? valorIcmsUfRemet; // ICMS para a UF do remetente

  const Impostos({
    this.valorTotalTributos,
    this.baseCalculoIcms,
    this.valorIcms,
    this.valorIcmsDesonerado,
    this.baseCalculoIcmsSt,
    this.valorIcmsSt,
    this.valorIpi,
    this.valorPis,
    this.valorCofins,
    this.valorIi,
    this.valorIcmsUfDest,
    this.valorIcmsUfRemet,
  });

  /// Retorna o valor total dos tributos formatado como moeda
  String get valorTotalTributosFormatado {
    if (valorTotalTributos == null) return 'N/A';
    return 'R\$ ${valorTotalTributos!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna a base de cálculo do ICMS formatada como moeda
  String get baseCalculoIcmsFormatado {
    if (baseCalculoIcms == null) return 'N/A';
    return 'R\$ ${baseCalculoIcms!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do ICMS formatado como moeda
  String get valorIcmsFormatado {
    if (valorIcms == null) return 'N/A';
    return 'R\$ ${valorIcms!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do ICMS desonerado formatado como moeda
  String get valorIcmsDesoneradoFormatado {
    if (valorIcmsDesonerado == null) return 'N/A';
    return 'R\$ ${valorIcmsDesonerado!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna a base de cálculo do ICMS ST formatada como moeda
  String get baseCalculoIcmsStFormatado {
    if (baseCalculoIcmsSt == null) return 'N/A';
    return 'R\$ ${baseCalculoIcmsSt!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do ICMS ST formatado como moeda
  String get valorIcmsStFormatado {
    if (valorIcmsSt == null) return 'N/A';
    return 'R\$ ${valorIcmsSt!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do IPI formatado como moeda
  String get valorIpiFormatado {
    if (valorIpi == null) return 'N/A';
    return 'R\$ ${valorIpi!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do PIS formatado como moeda
  String get valorPisFormatado {
    if (valorPis == null) return 'N/A';
    return 'R\$ ${valorPis!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do COFINS formatado como moeda
  String get valorCofinsFormatado {
    if (valorCofins == null) return 'N/A';
    return 'R\$ ${valorCofins!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do Imposto de Importação formatado como moeda
  String get valorIiFormatado {
    if (valorIi == null) return 'N/A';
    return 'R\$ ${valorIi!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do ICMS para a UF de destino formatado como moeda
  String get valorIcmsUfDestFormatado {
    if (valorIcmsUfDest == null) return 'N/A';
    return 'R\$ ${valorIcmsUfDest!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  /// Retorna o valor do ICMS para a UF do remetente formatado como moeda
  String get valorIcmsUfRemetFormatado {
    if (valorIcmsUfRemet == null) return 'N/A';
    return 'R\$ ${valorIcmsUfRemet!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // =========================
  // Serialização JSON
  // =========================

  factory Impostos.fromJson(Map<String, dynamic> json) {
    return Impostos(
      valorTotalTributos: (json['valor_total_tributos'] as num?)?.toDouble(),
      baseCalculoIcms: (json['base_calculo_icms'] as num?)?.toDouble(),
      valorIcms: (json['valor_icms'] as num?)?.toDouble(),
      valorIcmsDesonerado: (json['valor_icms_desonerado'] as num?)?.toDouble(),
      baseCalculoIcmsSt: (json['base_calculo_icms_st'] as num?)?.toDouble(),
      valorIcmsSt: (json['valor_icms_st'] as num?)?.toDouble(),
      valorIpi: (json['valor_ipi'] as num?)?.toDouble(),
      valorPis: (json['valor_pis'] as num?)?.toDouble(),
      valorCofins: (json['valor_cofins'] as num?)?.toDouble(),
      valorIi: (json['valor_ii'] as num?)?.toDouble(),
      valorIcmsUfDest: (json['valor_icms_uf_dest'] as num?)?.toDouble(),
      valorIcmsUfRemet: (json['valor_icms_uf_remet'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valor_total_tributos': valorTotalTributos,
      'base_calculo_icms': baseCalculoIcms,
      'valor_icms': valorIcms,
      'valor_icms_desonerado': valorIcmsDesonerado,
      'base_calculo_icms_st': baseCalculoIcmsSt,
      'valor_icms_st': valorIcmsSt,
      'valor_ipi': valorIpi,
      'valor_pis': valorPis,
      'valor_cofins': valorCofins,
      'valor_ii': valorIi,
      'valor_icms_uf_dest': valorIcmsUfDest,
      'valor_icms_uf_remet': valorIcmsUfRemet,
    };
  }

  // =========================
  // Métodos de cópia
  // =========================

  Impostos copyWith({
    double? valorTotalTributos,
    double? baseCalculoIcms,
    double? valorIcms,
    double? valorIcmsDesonerado,
    double? baseCalculoIcmsSt,
    double? valorIcmsSt,
    double? valorIpi,
    double? valorPis,
    double? valorCofins,
    double? valorIi,
    double? valorIcmsUfDest,
    double? valorIcmsUfRemet,
  }) {
    return Impostos(
      valorTotalTributos: valorTotalTributos ?? this.valorTotalTributos,
      baseCalculoIcms: baseCalculoIcms ?? this.baseCalculoIcms,
      valorIcms: valorIcms ?? this.valorIcms,
      valorIcmsDesonerado: valorIcmsDesonerado ?? this.valorIcmsDesonerado,
      baseCalculoIcmsSt: baseCalculoIcmsSt ?? this.baseCalculoIcmsSt,
      valorIcmsSt: valorIcmsSt ?? this.valorIcmsSt,
      valorIpi: valorIpi ?? this.valorIpi,
      valorPis: valorPis ?? this.valorPis,
      valorCofins: valorCofins ?? this.valorCofins,
      valorIi: valorIi ?? this.valorIi,
      valorIcmsUfDest: valorIcmsUfDest ?? this.valorIcmsUfDest,
      valorIcmsUfRemet: valorIcmsUfRemet ?? this.valorIcmsUfRemet,
    );
  }

  @override
  String toString() {
    return 'Impostos(valorIcms: $valorIcms, valorIpi: $valorIpi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Impostos &&
        other.valorIcms == valorIcms &&
        other.valorIpi == valorIpi;
  }

  @override
  int get hashCode => Object.hash(valorIcms, valorIpi);
}