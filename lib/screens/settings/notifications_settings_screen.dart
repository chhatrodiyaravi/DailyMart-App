import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _orderUpdates = true;
  bool _offersAndDeals = true;
  bool _deliveryAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: _orderUpdates,
            onChanged: (value) {
              setState(() {
                _orderUpdates = value;
              });
            },
            title: const Text('Order Updates'),
            subtitle: const Text('Get status updates for your orders'),
          ),
          SwitchListTile(
            value: _offersAndDeals,
            onChanged: (value) {
              setState(() {
                _offersAndDeals = value;
              });
            },
            title: const Text('Offers and Deals'),
            subtitle: const Text('Receive discount and promo notifications'),
          ),
          SwitchListTile(
            value: _deliveryAlerts,
            onChanged: (value) {
              setState(() {
                _deliveryAlerts = value;
              });
            },
            title: const Text('Delivery Alerts'),
            subtitle: const Text('Get delivery arrival reminders'),
          ),
        ],
      ),
    );
  }
}
