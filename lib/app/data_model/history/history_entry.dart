enum HistoryItemType { product, material }

class HistoryEntry {
  final String id;
  final HistoryItemType type;
  final DateTime viewedAt;
  final bool isFavorite;

  const HistoryEntry({
    required this.id,
    required this.type,
    required this.viewedAt,
    this.isFavorite = false,
  });

  HistoryEntry copyWith({DateTime? viewedAt, bool? isFavorite}) {
    return HistoryEntry(
      id: id,
      type: type,
      viewedAt: viewedAt ?? this.viewedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'viewedAt': viewedAt.toIso8601String(),
    'isFavorite': isFavorite,
  };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
    id: json['id'] as String,
    type: HistoryItemType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => HistoryItemType.product,
    ),
    viewedAt:
        DateTime.tryParse(json['viewedAt'] as String? ?? '') ?? DateTime.now(),
    isFavorite: json['isFavorite'] as bool? ?? false,
  );
}
