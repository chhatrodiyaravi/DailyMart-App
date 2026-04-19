import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HelpTile(
            icon: Icons.chat_bubble_outline,
            title: 'Chat with support',
            subtitle: 'Average response time: 2 minutes',
          ),
          _HelpTile(
            icon: Icons.call_outlined,
            title: 'Call support',
            subtitle: '+91 1800 000 1234',
          ),
          _HelpTile(
            icon: Icons.email_outlined,
            title: 'Email support',
            subtitle: 'support@dailymart.app',
          ),
          const SizedBox(height: 12),
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const ExpansionTile(
            title: Text('How can I track my order?'),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'Open your orders from Profile to see real-time updates.',
                ),
              ),
            ],
          ),
          const ExpansionTile(
            title: Text('How do I cancel an order?'),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(
                  'You can cancel before it is packed from the order details page.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade700),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
