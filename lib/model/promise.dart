class Promise {
  final String? title;
  final String? description;
  final List<DateRange>? dates;
  final bool? isCompleted;
  final int? coloring;
  final int? id;
  Promise({this.title, this.description, this.dates, this.isCompleted, this.id,  this.coloring = 0});
  factory Promise.fromJson(Map<String, dynamic> json) {
    return Promise(
      title: json['title'],
      description: json['description'],
      dates: json['dates'],
      isCompleted: json['isCompleted'],
      coloring: json['coloring'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dates': dates,
      'isCompleted': isCompleted,
      'id': id,
      'coloring': coloring,
    };
  }
  @override
  String toString() {
    return '{title: $title, description: $description, dates: $dates, isCompleted: $isCompleted, id: $id, coloring: $coloring}';
  }
}

class DateRange {
  final DateTime? startDate;
  final DateTime? endDate;
  DateRange({this.startDate, this.endDate});
  @override
  String toString() {
    return '{startDate: $startDate, endDate: $endDate}';
  }
}