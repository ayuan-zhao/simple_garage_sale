const String itemTable = 'citems';

class ItemFields {
  static final List<String> values = [
    /// Add all fields
    id, c_price, c_image, number, title, description, time
  ];

  static const String id = '_id';
  static const String c_price = 'c_price';
  static const String c_image = 'c_image';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class CommodityItem {
  final int? id;
  final int c_price;
  final String c_image;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const CommodityItem({
    this.id,
    required this.c_price,
    required this.c_image,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  CommodityItem copy({
    int? id,
    int? c_price,
    String? c_image,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      CommodityItem(
        id: id ?? this.id,
        c_price: c_price ?? this.c_price,
        c_image: c_image ?? this.c_image,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static CommodityItem fromJson(Map<String, Object?> json) => CommodityItem(
        id: json[ItemFields.id] as int?,
        c_price: json[ItemFields.c_price] as int,
        c_image: json[ItemFields.c_image] == null ? "" : json[ItemFields.c_image] as String,
        number: json[ItemFields.number] as int,
        title: json[ItemFields.title] as String,
        description: json[ItemFields.description] as String,
        createdTime: DateTime.parse(json[ItemFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        ItemFields.id: id,
        ItemFields.title: title,
        ItemFields.c_price: c_price,
        ItemFields.c_image: c_image,
        ItemFields.number: number,
        ItemFields.description: description,
        ItemFields.time: createdTime.toIso8601String(),
      };
}
