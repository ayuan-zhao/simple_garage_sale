const String itemTable = 'citems';

class ItemFields {
  static final List<String> values = [
    /// Add all fields
    id, c_price, number, title, description, time
  ];

  static const String id = '_id';
  static const String c_price = 'c_price';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class CommodityItem {
  final int? id;
  final int c_price;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const CommodityItem({
    this.id,
    required this.c_price,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  CommodityItem copy({
    int? id,
    int? c_price,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      CommodityItem(
        id: id ?? this.id,
        c_price: c_price ?? this.c_price,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static CommodityItem fromJson(Map<String, Object?> json) => CommodityItem(
        id: json[ItemFields.id] as int?,
        c_price: json[ItemFields.c_price] as int,
        number: json[ItemFields.number] as int,
        title: json[ItemFields.title] as String,
        description: json[ItemFields.description] as String,
        createdTime: DateTime.parse(json[ItemFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        ItemFields.id: id,
        ItemFields.title: title,
        ItemFields.c_price: c_price,
        ItemFields.number: number,
        ItemFields.description: description,
        ItemFields.time: createdTime.toIso8601String(),
      };
}
