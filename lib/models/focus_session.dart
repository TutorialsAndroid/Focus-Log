class FocusSession {
  final String task;
  final DateTime start;
  final DateTime end;

  FocusSession({
    required this.task,
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);

  Map<String, dynamic> toJson() => {
    'task': task,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      task: json['task'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }
}
