import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart';

class SessionTimer extends StatefulWidget {
  const SessionTimer({super.key});

  @override
  State<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  final controller = TextEditingController();
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  void _startTicker(DateTime start) {
    _timer?.cancel();
    _elapsed = DateTime.now().difference(start);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed = DateTime.now().difference(start);
      });
    });
  }

  void _stopTicker() {
    _timer?.cancel();
    _elapsed = Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FocusProvider>();
    final active = provider.activeSession;

    // Start/stop timer based on session state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (active != null && _timer == null) {
        _startTicker(active.start);
      }
      if (active == null && _timer != null) {
        _stopTicker();
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (active == null)
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'What are you focusing on?',
                ),
              )
            else ...[
              Text(
                active.task,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDuration(_elapsed),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],

            const SizedBox(height: 16),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: SizedBox(
                key: ValueKey(active == null),
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (active == null) {
                      provider.startSession(controller.text);
                      controller.clear();
                    } else {
                      provider.stopSession();
                    }
                  },
                  child: Text(
                    active == null ? 'Start Focus' : 'End Session',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = two(d.inHours);
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }
}
