import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/consent_manager.dart';

class ConsentDialog extends StatelessWidget {
  const ConsentDialog({super.key});

  static final String _privacyPolicyUrl = 'https://focuslog-mobile.web.app/focuslog-privacy-policy/';
  static final String _termsAndConditionsUrl = 'https://focuslog-mobile.web.app/focuslog-terms-and-conditions/';

  Future<void> _open(String url) async {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Before you continue'),
      content: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            const TextSpan(
              text:
              'By using Focus Log, you agree to our ',
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _open(
                  _privacyPolicyUrl,
                ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Terms & Conditions',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _open(
                  _termsAndConditionsUrl,
                ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await ConsentManager.accept();
            Navigator.of(context).pop();
          },
          child: const Text('I Accept'),
        ),
      ],
    );
  }
}
