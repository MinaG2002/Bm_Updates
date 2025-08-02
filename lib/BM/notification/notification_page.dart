import 'package:bmproject/BM/notification/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => provider.clearAll(),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications_active,
                      color: Colors.blue,
                    ),
                    title: Text(item.title),
                    subtitle: Text(item.body),
                    trailing: Text(
                      '${item.time.hour}:${item.time.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
