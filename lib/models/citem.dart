const String itemTable = 'citems';

class ItemFields {
  static final List<String> values = [
    /// Add all fields
    id, isImportant, number, title, description, time
  ];

  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
}

class CommodityItem {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const CommodityItem({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  CommodityItem copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      CommodityItem(
        id: id ?? this.id,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static CommodityItem fromJson(Map<String, Object?> json) => CommodityItem(
        id: json[ItemFields.id] as int?,
        isImportant: json[ItemFields.isImportant] == 1,
        number: json[ItemFields.number] as int,
        title: json[ItemFields.title] as String,
        description: json[ItemFields.description] as String,
        createdTime: DateTime.parse(json[ItemFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        ItemFields.id: id,
        ItemFields.title: title,
        ItemFields.isImportant: isImportant ? 1 : 0,
        ItemFields.number: number,
        ItemFields.description: description,
        ItemFields.time: createdTime.toIso8601String(),
      };
}
