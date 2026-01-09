import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _version = '';

  static final String _privacyPolicyUrl = 'https://focuslog-mobile.web.app/focuslog-privacy-policy/';
  static final String _termsAndConditionsUrl = 'https://focuslog-mobile.web.app/focuslog-terms-and-conditions/';
  static final String _githubURL = 'https://github.com/TutorialsAndroid';
  static final String _email = "heaticdeveloper@gmail.com";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _email, // 🔁 CHANGE THIS
      query: 'subject=Focus Log Support',
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Section(
            title: 'Legal',
            children: [
              _Tile(
                title: 'Privacy Policy',
                onTap: () => _openUrl(
                  _privacyPolicyUrl, // 🔁 CHANGE
                ),
              ),
              _Tile(
                title: 'Terms & Conditions',
                onTap: () => _openUrl(
                  _termsAndConditionsUrl, // 🔁 CHANGE
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _Section(
            title: 'Support',
            children: [
              _Tile(
                title: 'Help & Support',
                onTap: _sendEmail,
              ),
              _Tile(
                title: 'GitHub',
                onTap: () => _openUrl(
                  _githubURL, // 🔁 CHANGE
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              _version.isEmpty
                  ? ''
                  : 'Focus Log v$_version',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _Tile({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
