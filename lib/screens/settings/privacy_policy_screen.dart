import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Your Privacy Matters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Text(
            'We collect only necessary data to process orders, manage delivery, and improve your shopping experience.',
          ),
          SizedBox(height: 10),
          Text(
            'Your account details are stored securely and are never sold to third parties.',
          ),
          SizedBox(height: 10),
          Text(
            'You can request account deletion or data export by contacting support from the Help & Support page.',
          ),
        ],
      ),
    );
  }
}
