import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../class/auth_service.dart';
import '../../class/api_service.dart';
import '../../class/global.dart';
import '../../class/jwt_helper.dart';
import '../Campaign/detailedcampaign.dart';
// Import this file in your profile_screen.dart:
// import 'notification_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int id;
  List<NotificationItem> notify = [];

  @override
  void initState() {
    super.initState();
    id = 0;
    loadProfile();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadProfile() async {
    String? token = await AuthService().getToken();
    if (token != null && !JWTHelper.isTokenExpired(token)) {
      Map<String, dynamic> userData = JWTHelper.decodeToken(token);
      setState(() => id = userData['user']['id']);
      print(userData['user']['id']);
      loadNotifications();
      print("User ID: ${userData['user']}");
    } else {
      print("Token is expired or invalid");

    }
    // setState(() => user = res['user']);
  }

  Future<void> loadNotifications() async {
    String ids = id.toString();
    print(ids);
    dynamic token = await ApiService().getUserNotification(ids) ;
    List<Map<String, dynamic>> tasks = token.cast<Map<String, dynamic>>();
    token.forEach((obj) {
      NotificationItem p = new NotificationItem(
          icon: Icons.security,
          iconColor: Colors.orange,
          title: obj['type'],
          message: obj['message'],
          id: obj['type_id'],
          time: obj['created_at'], isRead: false);


      setState(() => notify.add(p));

    });

    print(notify);
    //setState(() => totalStakeholders = waiting);


    //setState(() => categories = tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: Color(0xFF007A74),
                fontSize: 14,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFF007A74),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF007A74),
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Transactions'),
            Tab(text: 'Campaigns'),
            Tab(text: 'System'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const AllNotificationsTab(),
          const TransactionsTab(),
          CampaignsTab(Notify: notify),
          const SystemTab(),
        ],
      ),
    );
  }
}

// === All Notifications Tab ===
class AllNotificationsTab extends StatelessWidget {
  const AllNotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = _getAllNotifications();

    if (notifications.isEmpty) {
      return _buildEmptyState('No notifications yet');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(notifications[index]);
      },
    );
  }

  List<NotificationItem> _getAllNotifications() {
    return [
      NotificationItem(
        icon: Icons.account_balance_wallet,
        iconColor: Colors.green,
        title: 'Money Added',
        message: 'You successfully added ₦50,000 to your wallet',
        time: '2 hours ago',
        isRead: false, id: 0,
      ),
      NotificationItem(
        icon: Icons.campaign,
        iconColor: Colors.orange,
        title: 'Campaign Update',
        message: 'Your campaign "Help John Medical Bill" received a new donation of ₦10,000',
        time: '5 hours ago',
        isRead: false, id: 0,
      ),
      NotificationItem(
        icon: Icons.payment,
        iconColor: Colors.blue,
        title: 'Payment Received',
        message: 'You received ₦25,000 from Sarah Obi',
        time: '1 day ago',
        isRead: true, id: 0,
      ),
      NotificationItem(
        icon: Icons.info_outline,
        iconColor: Colors.purple,
        title: 'Security Alert',
        message: 'Your password was changed successfully',
        time: '2 days ago',
        isRead: true, 
        id: 0,
      ),
    ];
  }
}

// === Transactions Tab ===
class TransactionsTab extends StatelessWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      NotificationItem(
        icon: Icons.account_balance_wallet,
        iconColor: Colors.green,
        title: 'Money Added',
        message: 'You successfully added ₦50,000 to your wallet',
        time: '2 hours ago',
        isRead: false, id: 0,
      ),
      NotificationItem(
        icon: Icons.payment,
        iconColor: Colors.blue,
        title: 'Payment Received',
        message: 'You received ₦25,000 from Sarah Obi',
        time: '1 day ago',
        isRead: true, id: 0,
      ),
      NotificationItem(
        icon: Icons.send,
        iconColor: Colors.red,
        title: 'Money Sent',
        message: 'You sent ₦15,000 to John Doe',
        time: '3 days ago',
        isRead: true, id: 0,
      ),
      NotificationItem(
        icon: Icons.receipt_long,
        iconColor: Colors.teal,
        title: 'Bill Payment',
        message: 'Electricity bill payment of ₦8,500 was successful',
        time: '1 week ago',
        isRead: true, id: 0,
      ),
    ];

    if (transactions.isEmpty) {
      return _buildEmptyState('No transaction notifications');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(transactions[index]);
      },
    );
  }
}

// === Campaigns Tab ===
class CampaignsTab extends StatelessWidget {
  final List<NotificationItem> Notify;
  const CampaignsTab({super.key, required this.Notify});

  @override
  Widget build(BuildContext context) {
    print(Notify);
    final campaigns = Notify;

    if (campaigns.isEmpty) {
      return _buildEmptyState('No campaign notifications');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(campaigns[index]);
      },
    );
  }
}

// === System Tab ===
class SystemTab extends StatelessWidget {
  const SystemTab({super.key});

  @override
  Widget build(BuildContext context) {
    final systemNotifications = [
      NotificationItem(
        icon: Icons.info_outline,
        iconColor: Colors.purple,
        title: 'Security Alert',
        message: 'Your password was changed successfully',
        time: '2 days ago',
        isRead: true, id: 0,
      ),
      NotificationItem(
        icon: Icons.verified_user,
        iconColor: Colors.green,
        title: 'KYC Verification',
        message: 'Complete your KYC verification to unlock all features',
        time: '3 days ago',
        isRead: false, id: 0,
      ),
      NotificationItem(
        icon: Icons.system_update,
        iconColor: Colors.blue,
        title: 'App Update',
        message: 'A new version of GreyFundr is available. Update now for better experience',
        time: '1 week ago',
        isRead: true, id: 0,
      ),
      NotificationItem(
        icon: Icons.security,
        iconColor: Colors.orange,
        title: 'Login Alert',
        message: 'New login detected from Lagos, Nigeria',
        time: '2 weeks ago',
        isRead: true, id: 0,
      ),
    ];

    if (systemNotifications.isEmpty) {
      return _buildEmptyState('No system notifications');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: systemNotifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationItem(systemNotifications[index]);
      },
    );
  }
}

// === Helper Functions ===
Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.notifications_none,
          size: 80,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}

Widget _buildNotificationItem(NotificationItem item) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: item.isRead ? Colors.white : const Color(0xFFF0F9F9),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      onTap: () {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(content: Text('Opening Campaign ${item.title}')),
        );

        navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => CampaignDetailPage(id: item.id.toString()),
            ));
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: item.iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          item.icon,
          color: item.iconColor,
          size: 24,
        ),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: item.isRead ? FontWeight.w500 : FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 4),
          Text(
            item.message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            item.time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Approve',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[500],
            ),
          ),

          Text(
            'Decline',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[500],
            ),
          ),
        ],
      ),
      trailing: !item.isRead
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF007A74),
                shape: BoxShape.circle,
              ),
            )
          : null,
    ),
  );
}

// === Notification Model ===
class NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final int id;

  NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead, 
    required this.id,
  });
}