import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart';

class SessionList extends StatelessWidget {
  const SessionList({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<FocusProvider>().sessions;

    if (sessions.isEmpty) {
      return const Center(
        child: Text(
          'No focus sessions yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return AnimatedList(
      initialItemCount: sessions.length,
      itemBuilder: (context, index, animation) {
        final s = sessions[index];
        return SizeTransition(
          sizeFactor: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Card(
              child: ListTile(
                title: Text(s.task),
                trailing: Text('${s.duration.inMinutes} min'),
              ),
            ),
          ),
        );
      },
    );
  }
}
