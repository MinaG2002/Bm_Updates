import 'package:bmproject/BM/Swap/model/request_swa.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AllRequestsPage extends StatefulWidget {
  const AllRequestsPage({super.key});

  @override
  State<AllRequestsPage> createState() => _AllRequestsPageState();
}

class _AllRequestsPageState extends State<AllRequestsPage> {
  String? selectedLocation;

  final locations = ["All", 'Dokki', 'DownTown', ' Nasr City', "October"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            S.of(context).Allrequests,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: S.of(context).FilterbyLocation,
                border: const OutlineInputBorder(),
              ),
              value: selectedLocation ?? 'All',
              items: locations.map((loc) {
                return DropdownMenuItem(value: loc, child: Text(loc));
              }).toList(),
              onChanged: (val) => setState(() => selectedLocation = val),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(S.of(context).Therearenorequestsyet),
                  );
                }

                final allRequests = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return RequestModel.fromMap(doc.id, data);
                }).toList();

                final filteredRequests =
                    selectedLocation == null || selectedLocation == 'All'
                    ? allRequests
                    : allRequests
                          .where((req) => req.location == selectedLocation)
                          .toList();

                return ListView.builder(
                  itemCount: filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = filteredRequests[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          "${request.requestType} - ${request.location}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${S.of(context).Name}: ${request.name}"),
                            Text(
                              "${S.of(context).CiscoNumber}: ${request.ciscoNumber}",
                            ),
                            Text("${S.of(context).Phone}: ${request.phone}"),
                            Text("${S.of(context).Date}: ${request.date}"),
                            if (request.notes.isNotEmpty)
                              Text("${S.of(context).Notes}: ${request.notes}"),
                            ElevatedButton(
                              onPressed: () {
                                _openWhatsApp(
                                  name: request.name,
                                  cisco: request.ciscoNumber,
                                  location: request.location,
                                  date: request.date,
                                  type: request.requestType,
                                  notes: request.notes,
                                  phone: request.phone,
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.green,
                                ),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 1,
                                child: Center(
                                  child: Text(
                                    S.of(context).WhatsApp,
                                    style: const TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openWhatsApp({
    required String name,
    required String cisco,
    required String location,
    required String date,
    required String type,
    required String notes,
    required String phone,
  }) async {
    final message = Uri.encodeComponent('''
أهلاً، شفتك متاحة للسواب؟
الاسم: $name
كود السيسكو: $cisco
الموقع: $location
التاريخ: $date
النوع: $type
ملاحظات: $notes
''');

    final url = Uri.parse("https://wa.me/2$phone?text=$message");

    if (phone.length == 11) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ لا يمكن فتح واتساب")));
    }
  }
}
