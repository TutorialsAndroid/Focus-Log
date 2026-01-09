import 'package:flutter/material.dart';
import 'package:focuslog/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../providers/focus_provider.dart';
import '../utils/consent_manager.dart';
import '../widgets/consent_dialog.dart';
import '../widgets/session_timer.dart';
import '../widgets/session_list.dart';
import '../widgets/weekly_chart.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    final accepted = await ConsentManager.hasAccepted();
    if (!accepted && mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const ConsentDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FocusProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Log', style: TextStyle(fontWeight: FontWeight.w600),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SessionTimer(),
            const SizedBox(height: 24),
            const WeeklyChart(),
            const SizedBox(height: 24),
            const Text(
              'Today',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _format(provider.todayTotal),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),
            const Expanded(child: SessionList()),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) =>
      '${d.inHours}h ${(d.inMinutes % 60).toString().padLeft(2, '0')}m';
}

