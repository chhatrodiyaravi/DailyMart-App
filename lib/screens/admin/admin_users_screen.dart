import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/app_user.dart';
import '../../providers/users_provider.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = context.watch<UsersProvider>();
    final List<AppUser> users = usersProvider.users;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final AppUser user = users[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text(
                user.name.isNotEmpty ? user.name.substring(0, 1) : '?',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            title: Text(user.name),
            subtitle: Text(user.isAdmin ? '${user.email} • Admin' : user.email),
            trailing: Switch(
              value: !user.isBlocked,
              onChanged: user.isAdmin
                  ? null
                  : (isActive) {
                      context.read<UsersProvider>().setBlocked(
                        user.id,
                        !isActive,
                      );
                    },
            ),
          ),
        );
      },
    );
  }
}
