import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart';
import '../models/focus_session.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<FocusProvider>().sessions;

    final grouped = _groupByDate(sessions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: grouped.isEmpty
          ? const Center(
        child: Text(
          'No focus history yet',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: grouped.keys.length,
        itemBuilder: (context, index) {
          final date = grouped.keys.elementAt(index);
          final daySessions = grouped[date]!;

          return _DaySection(
            date: date,
            sessions: daySessions,
          );
        },
      ),
    );
  }

  Map<DateTime, List<FocusSession>> _groupByDate(
      List<FocusSession> sessions) {
    final map = <DateTime, List<FocusSession>>{};

    for (final s in sessions) {
      final date = DateTime(s.start.year, s.start.month, s.start.day);
      map.putIfAbsent(date, () => []).add(s);
    }

    return Map.fromEntries(
      map.entries.toList()
        ..sort((a, b) => b.key.compareTo(a.key)),
    );
  }
}

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<FocusSession> sessions;

  const _DaySection({
    required this.date,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final totalMinutes =
    sessions.fold(0, (sum, s) => sum + s.duration.inMinutes);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(date),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalMinutes min focused',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),

          ...sessions.map(
                (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  title: Text(
                    s.task,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Text(
                    '${s.duration.inMinutes} min',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${_weekday(d.weekday)}, ${d.day}/${d.month}/${d.year}';
  }

  String _weekday(int i) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    return days[i - 1];
  }
}
