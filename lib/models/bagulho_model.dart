class Bagulho {
  final String? id; // Gerado automaticamente pela API, portando é obrigatorio e imutavel
  final DateTime? criadoEm;
  final String name; // !!! Deixe isso sempre em inglês ("name") para evitar confusão com a API
  final String? avatar;
  final String? tag;

  Bagulho({
    this.id,
    this.criadoEm,
    required this.name,
    this.avatar,
    this.tag,
/* ↑ Inicialmente planejado para funcionar como uma tag, mas mudamos para "categoria" para ser mais simples.
O nome do campo na API continua "tag" para manter a consistência com o backend. */
  });

  factory Bagulho.fromJson(Map<String, dynamic> json) {
    return Bagulho(
      id: json['id'],
      criadoEm: json['criadoEm'] != null 
          ? DateTime.parse(json['criadoEm']) 
          : null,
      name: json['name'],
      avatar: json['avatar'],
      tag: json['tag'],
    );
  }

  // Método POST
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'tag': tag,
    };
  }
}