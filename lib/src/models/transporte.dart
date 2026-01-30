/// Modelo que representa as informações de transporte de um documento fiscal
class Transporte {
  final String? modalidadeFrete; // 0=Por conta do emitente, 1=Por conta do destinatário/remetente, 2=Por conta de terceiros, 9=Sem frete
  final String? cnpjTransportador;
  final String? nomeTransportador;
  final String? enderecoTransportador;
  final String? municipioTransportador;
  final String? ufTransportador;
  final String? placaVeiculo;
  final String? ufVeiculo;
  final String? rntcVeiculo; // Registro Nacional de Transportador de Carga
  final String? quantidadeVolumes;
  final String? especieVolumes;
  final String? marcaVolumes;
  final String? numeracaoVolumes;
  final double? pesoLiquido;
  final double? pesoBruto;
  final String? inscricaoEstadualTransportador;
  final double? valorFrete;
  final double? valorSeguro;

  const Transporte({
    this.modalidadeFrete,
    this.cnpjTransportador,
    this.nomeTransportador,
    this.enderecoTransportador,
    this.municipioTransportador,
    this.ufTransportador,
    this.placaVeiculo,
    this.ufVeiculo,
    this.rntcVeiculo,
    this.quantidadeVolumes,
    this.especieVolumes,
    this.marcaVolumes,
    this.numeracaoVolumes,
    this.pesoLiquido,
    this.pesoBruto,
    this.inscricaoEstadualTransportador,
    this.valorFrete,
    this.valorSeguro,
  });

  /// Retorna o CNPJ do transportador formatado
  String get cnpjTransportadorFormatado {
    if (cnpjTransportador == null || cnpjTransportador!.length != 14) {
      return cnpjTransportador ?? '';
    }
    return '${cnpjTransportador!.substring(0, 2)}.${cnpjTransportador!.substring(2, 5)}.${cnpjTransportador!.substring(5, 8)}/${cnpjTransportador!.substring(8, 12)}-${cnpjTransportador!.substring(12, 14)}';
  }

  /// Retorna o peso líquido formatado
  String get pesoLiquidoFormatado {
    if (pesoLiquido == null) return 'N/A';
    return '${pesoLiquido!.toStringAsFixed(3)} kg';
  }

  /// Retorna o peso bruto formatado
  String get pesoBrutoFormatado {
    if (pesoBruto == null) return 'N/A';
    return '${pesoBruto!.toStringAsFixed(3)} kg';
  }

  // =========================
  // Serialização JSON
  // =========================

  factory Transporte.fromJson(Map<String, dynamic> json) {
    return Transporte(
      modalidadeFrete: json['modalidade_frete'] as String?,
      cnpjTransportador: json['cnpj_transportador'] as String?,
      nomeTransportador: json['nome_transportador'] as String?,
      enderecoTransportador: json['endereco_transportador'] as String?,
      municipioTransportador: json['municipio_transportador'] as String?,
      ufTransportador: json['uf_transportador'] as String?,
      placaVeiculo: json['placa_veiculo'] as String?,
      ufVeiculo: json['uf_veiculo'] as String?,
      rntcVeiculo: json['rntc_veiculo'] as String?,
      quantidadeVolumes: json['quantidade_volumes'] as String?,
      especieVolumes: json['especie_volumes'] as String?,
      marcaVolumes: json['marca_volumes'] as String?,
      numeracaoVolumes: json['numeracao_volumes'] as String?,
      pesoLiquido: (json['peso_liquido'] as num?)?.toDouble(),
      pesoBruto: (json['peso_bruto'] as num?)?.toDouble(),
      inscricaoEstadualTransportador:
          json['inscricao_estadual_transportador'] as String?,
      valorFrete: (json['valor_frete'] as num?)?.toDouble(),
      valorSeguro: (json['valor_seguro'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modalidade_frete': modalidadeFrete,
      'cnpj_transportador': cnpjTransportador,
      'nome_transportador': nomeTransportador,
      'endereco_transportador': enderecoTransportador,
      'municipio_transportador': municipioTransportador,
      'uf_transportador': ufTransportador,
      'placa_veiculo': placaVeiculo,
      'uf_veiculo': ufVeiculo,
      'rntc_veiculo': rntcVeiculo,
      'quantidade_volumes': quantidadeVolumes,
      'especie_volumes': especieVolumes,
      'marca_volumes': marcaVolumes,
      'numeracao_volumes': numeracaoVolumes,
      'peso_liquido': pesoLiquido,
      'peso_bruto': pesoBruto,
      'inscricao_estadual_transportador': inscricaoEstadualTransportador,
      'valor_frete': valorFrete,
      'valor_seguro': valorSeguro,
    };
  }

  // =========================
  // Métodos de cópia
  // =========================

  Transporte copyWith({
    String? modalidadeFrete,
    String? cnpjTransportador,
    String? nomeTransportador,
    String? enderecoTransportador,
    String? municipioTransportador,
    String? ufTransportador,
    String? placaVeiculo,
    String? ufVeiculo,
    String? rntcVeiculo,
    String? quantidadeVolumes,
    String? especieVolumes,
    String? marcaVolumes,
    String? numeracaoVolumes,
    double? pesoLiquido,
    double? pesoBruto,
    String? inscricaoEstadualTransportador,
    double? valorFrete,
    double? valorSeguro,
  }) {
    return Transporte(
      modalidadeFrete: modalidadeFrete ?? this.modalidadeFrete,
      cnpjTransportador: cnpjTransportador ?? this.cnpjTransportador,
      nomeTransportador: nomeTransportador ?? this.nomeTransportador,
      enderecoTransportador:
          enderecoTransportador ?? this.enderecoTransportador,
      municipioTransportador:
          municipioTransportador ?? this.municipioTransportador,
      ufTransportador: ufTransportador ?? this.ufTransportador,
      placaVeiculo: placaVeiculo ?? this.placaVeiculo,
      ufVeiculo: ufVeiculo ?? this.ufVeiculo,
      rntcVeiculo: rntcVeiculo ?? this.rntcVeiculo,
      quantidadeVolumes: quantidadeVolumes ?? this.quantidadeVolumes,
      especieVolumes: especieVolumes ?? this.especieVolumes,
      marcaVolumes: marcaVolumes ?? this.marcaVolumes,
      numeracaoVolumes: numeracaoVolumes ?? this.numeracaoVolumes,
      pesoLiquido: pesoLiquido ?? this.pesoLiquido,
      pesoBruto: pesoBruto ?? this.pesoBruto,
      inscricaoEstadualTransportador: inscricaoEstadualTransportador ??
          this.inscricaoEstadualTransportador,
      valorFrete: valorFrete ?? this.valorFrete,
      valorSeguro: valorSeguro ?? this.valorSeguro,
    );
  }

  @override
  String toString() {
    return 'Transporte(nomeTransportador: $nomeTransportador, modalidadeFrete: $modalidadeFrete)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transporte &&
        other.cnpjTransportador == cnpjTransportador &&
        other.nomeTransportador == nomeTransportador;
  }

  @override
  int get hashCode => Object.hash(cnpjTransportador, nomeTransportador);
}