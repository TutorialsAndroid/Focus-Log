import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/focus_session.dart';

class FocusProvider extends ChangeNotifier {
  static const _storageKey = 'focus_sessions';

  FocusSession? _activeSession;
  final List<FocusSession> _sessions = [];

  FocusProvider() {
    _loadSessions();
  }

  FocusSession? get activeSession => _activeSession;
  List<FocusSession> get sessions => List.unmodifiable(_sessions);

  void startSession(String task) {
    if (task.trim().isEmpty) return;

    _activeSession = FocusSession(
      task: task.trim(),
      start: DateTime.now(),
      end: DateTime.now(),
    );
    notifyListeners();
  }

  void stopSession() {
    if (_activeSession == null) return;

    final completed = FocusSession(
      task: _activeSession!.task,
      start: _activeSession!.start,
      end: DateTime.now(),
    );

    _sessions.insert(0, completed);
    _activeSession = null;

    _saveSessions();
    notifyListeners();
  }

  Duration get todayTotal {
    final today = DateTime.now();
    return _sessions
        .where((s) =>
    s.start.year == today.year &&
        s.start.month == today.month &&
        s.start.day == today.day)
        .fold(Duration.zero, (sum, s) => sum + s.duration);
  }

  List<int> get weeklyTotals {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: i));
      return _sessions
          .where((s) =>
      s.start.year == day.year &&
          s.start.month == day.month &&
          s.start.day == day.day)
          .fold(0, (sum, s) => sum + s.duration.inMinutes);
    }).reversed.toList();
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _sessions.map((s) => s.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;

    final List decoded = jsonDecode(raw);
    _sessions
      ..clear()
      ..addAll(decoded.map((e) => FocusSession.fromJson(e)));

    notifyListeners();
  }
}
