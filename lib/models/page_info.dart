class PageInfo {
  final bool hasNextPage;
  final bool hasPreviousPage;
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final String? startCursor;
  final String? endCursor;

  const PageInfo({
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.startCursor,
    this.endCursor,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPreviousPage: json['hasPreviousPage'] as bool? ?? false,
      currentPage: json['currentPage'] as int?,
      totalPages: json['totalPages'] as int?,
      totalItems: json['totalItems'] as int?,
      startCursor: json['startCursor'] as String?,
      endCursor: json['endCursor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasNextPage': hasNextPage,
      'hasPreviousPage': hasPreviousPage,
      if (currentPage != null) 'currentPage': currentPage,
      if (totalPages != null) 'totalPages': totalPages,
      if (totalItems != null) 'totalItems': totalItems,
      if (startCursor != null) 'startCursor': startCursor,
      if (endCursor != null) 'endCursor': endCursor,
    };
  }

  @override
  String toString() =>
      'PageInfo(hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage, totalItems: $totalItems)';
}
