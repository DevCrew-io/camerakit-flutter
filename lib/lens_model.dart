class LensModel {
  final String id;
  final String name;

  LensModel({
    required this.id,
    required this.name,
  });

  factory LensModel.fromJson(Map<String, dynamic> json) {
    return LensModel(
      id: json['id'],
      name: json['name'],
    );
  }
}