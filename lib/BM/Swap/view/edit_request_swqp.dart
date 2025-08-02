import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/Swap/model/request_swa.dart';
import 'package:bmproject/BM/Swap/view/editrequst.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    // final name = userProvider.userName;

    if (cisco == null) {
      return Scaffold(body: Center(child: Text(S.of(context).Notloggedin)));
    }

    // final userCisco = currentUser.ciscoNumber;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            S.of(context).MyRequests,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('ciscoNumber', isEqualTo: cisco)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(S.of(context).Norequestsyet));
          }

          final requests = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return RequestModel.fromMap(doc.id, data);
          }).toList();

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  title: Text("${request.requestType} - ${request.location}"),
                  subtitle: Text("${S.of(context).Date}: ${request.date}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditRequestPage(request: request),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDelete(context, request);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, RequestModel request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).Confirmdeletion),
        content: Text(S.of(context).Areyousureyouwanttodeletethisrequest),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.of(context).Cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await FirebaseFirestore.instance
                  .collection('requests')
                  .doc(request.id)
                  .delete();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      S.of(context).Therequestwassuccessfullydeleted,
                    ),
                  ),
                );
              }
            },
            child: Text(
              S.of(context).Delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
