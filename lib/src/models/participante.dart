/// Modelo que representa um participante (emitente ou destinatário) de um documento fiscal
class Participante {
  final String cnpj;
  final String nome;
  final String? cpf;
  final String? ie; // Inscrição Estadual
  final String? enderecoLogradouro;
  final String? enderecoNumero;
  final String? enderecoComplemento;
  final String? enderecoBairro;
  final String? enderecoCep;
  final String? enderecoMunicipio;
  final String? enderecoUf;
  final String? enderecoPais;
  final String? enderecoTelefone;
  final String? email;

  const Participante({
    required this.cnpj,
    required this.nome,
    this.cpf,
    this.ie,
    this.enderecoLogradouro,
    this.enderecoNumero,
    this.enderecoComplemento,
    this.enderecoBairro,
    this.enderecoCep,
    this.enderecoMunicipio,
    this.enderecoUf,
    this.enderecoPais,
    this.enderecoTelefone,
    this.email,
  });

  /// Retorna o CNPJ formatado
  String get cnpjFormatado {
    if (cnpj.length != 14) return cnpj;
    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}';
  }

  /// Retorna o CPF formatado
  String get cpfFormatado {
    if (cpf == null || cpf!.length != 11) return cpf ?? '';
    return '${cpf!.substring(0, 3)}.${cpf!.substring(3, 6)}.${cpf!.substring(6, 9)}-${cpf!.substring(9, 11)}';
  }

  /// Retorna o CEP formatado
  String get cepFormatado {
    if (enderecoCep == null || enderecoCep!.length != 8) return enderecoCep ?? '';
    return '${enderecoCep!.substring(0, 5)}-${enderecoCep!.substring(5, 8)}';
  }

  /// Retorna o endereço completo formatado
  String get enderecoCompleto {
    List<String> partes = [];
    
    if (enderecoLogradouro != null && enderecoLogradouro!.isNotEmpty) {
      partes.add(enderecoLogradouro!);
    }
    
    if (enderecoNumero != null && enderecoNumero!.isNotEmpty) {
      partes.add(enderecoNumero!);
    }
    
    if (enderecoComplemento != null && enderecoComplemento!.isNotEmpty) {
      partes.add(enderecoComplemento!);
    }
    
    if (enderecoBairro != null && enderecoBairro!.isNotEmpty) {
      partes.add(enderecoBairro!);
    }
    
    if (enderecoMunicipio != null && enderecoMunicipio!.isNotEmpty) {
      partes.add(enderecoMunicipio!);
    }
    
    if (enderecoUf != null && enderecoUf!.isNotEmpty) {
      partes.add(enderecoUf!);
    }
    
    return partes.join(', ');
  }

  // =========================
  // Serialização JSON
  // =========================

  factory Participante.fromJson(Map<String, dynamic> json) {
    return Participante(
      cnpj: json['cnpj'] as String,
      nome: json['nome'] as String,
      cpf: json['cpf'] as String?,
      ie: json['ie'] as String?,
      enderecoLogradouro: json['endereco_logradouro'] as String?,
      enderecoNumero: json['endereco_numero'] as String?,
      enderecoComplemento: json['endereco_complemento'] as String?,
      enderecoBairro: json['endereco_bairro'] as String?,
      enderecoCep: json['endereco_cep'] as String?,
      enderecoMunicipio: json['endereco_municipio'] as String?,
      enderecoUf: json['endereco_uf'] as String?,
      enderecoPais: json['endereco_pais'] as String?,
      enderecoTelefone: json['endereco_telefone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cnpj': cnpj,
      'nome': nome,
      'cpf': cpf,
      'ie': ie,
      'endereco_logradouro': enderecoLogradouro,
      'endereco_numero': enderecoNumero,
      'endereco_complemento': enderecoComplemento,
      'endereco_bairro': enderecoBairro,
      'endereco_cep': enderecoCep,
      'endereco_municipio': enderecoMunicipio,
      'endereco_uf': enderecoUf,
      'endereco_pais': enderecoPais,
      'endereco_telefone': enderecoTelefone,
      'email': email,
    };
  }

  // =========================
  // Métodos de cópia
  // =========================

  Participante copyWith({
    String? cnpj,
    String? nome,
    String? cpf,
    String? ie,
    String? enderecoLogradouro,
    String? enderecoNumero,
    String? enderecoComplemento,
    String? enderecoBairro,
    String? enderecoCep,
    String? enderecoMunicipio,
    String? enderecoUf,
    String? enderecoPais,
    String? enderecoTelefone,
    String? email,
  }) {
    return Participante(
      cnpj: cnpj ?? this.cnpj,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      ie: ie ?? this.ie,
      enderecoLogradouro: enderecoLogradouro ?? this.enderecoLogradouro,
      enderecoNumero: enderecoNumero ?? this.enderecoNumero,
      enderecoComplemento: enderecoComplemento ?? this.enderecoComplemento,
      enderecoBairro: enderecoBairro ?? this.enderecoBairro,
      enderecoCep: enderecoCep ?? this.enderecoCep,
      enderecoMunicipio: enderecoMunicipio ?? this.enderecoMunicipio,
      enderecoUf: enderecoUf ?? this.enderecoUf,
      enderecoPais: enderecoPais ?? this.enderecoPais,
      enderecoTelefone: enderecoTelefone ?? this.enderecoTelefone,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'Participante(nome: $nome, cnpj: $cnpj)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Participante &&
        other.cnpj == cnpj &&
        other.nome == nome;
  }

  @override
  int get hashCode => Object.hash(cnpj, nome);
}