import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    if (!notification.isRead) {
      backgroundColor = Colors.blue.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        child: ListTile(
          leading: CircleAvatar(
            child: _getNotificationIcon(),
          ),
          title: Text(
            notification.message,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Text(
            timeago.format(notification.timestamp),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          trailing: notification.isRead
              ? null
              : Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.profileView:
        return const Icon(Icons.visibility);
      case NotificationType.follow:
        return const Icon(Icons.person_add);
      case NotificationType.like:
        return const Icon(Icons.favorite);
      case NotificationType.comment:
        return const Icon(Icons.comment);
      default:
        return const Icon(Icons.notifications);
    }
  }
}
