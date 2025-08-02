import 'package:bmproject/BM/Swap/model/request_swa.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditRequestPage extends StatefulWidget {
  final RequestModel request;

  const EditRequestPage({super.key, required this.request});

  @override
  State<EditRequestPage> createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController ciscoController;
  late TextEditingController phoneController;
  late TextEditingController notesController;

  String? selectedLocation;
  String? selectedRequestType;
  DateTime? selectedDate;

  final locations = ['Dokki', 'DownTown', ' Nasr City', "October"];
  final requestTypes = ['Shift', 'Off', 'annual leave'];

  @override
  void initState() {
    super.initState();
    final request = widget.request;

    nameController = TextEditingController(text: request.name);
    ciscoController = TextEditingController(text: request.ciscoNumber);
    phoneController = TextEditingController(text: request.phone);
    notesController = TextEditingController(text: request.notes);

    selectedLocation = request.location;
    selectedRequestType = request.requestType;
    selectedDate = DateTime.tryParse(request.date);
  }

  @override
  void dispose() {
    nameController.dispose();
    ciscoController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _updateRequest() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.request.id)
          .update({
            'name': nameController.text,
            'ciscoNumber': ciscoController.text,
            'location': selectedLocation,
            'phone': phoneController.text,
            'requestType': selectedRequestType,
            'date': selectedDate!.toIso8601String().split('T')[0],
            'notes': notesController.text,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.of(context).Editrequestsuccessfully,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _confirmDelete() async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(S.of(context).Confirmdeletion),
        content: Text(S.of(context).Areyousureyouwanttodeletethisrequest),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(S.of(context).Cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              S.of(context).Delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.request.id)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              S.of(context).Therequestwassuccessfullydeleted,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).EditRequest,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).yourName,
                  hintText: S.of(context).Enteryourname,
                  prefixIcon: const Icon(
                    Icons.person_rounded,
                    color: AppTheme.primaryColor,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? S.of(context).Pleaseenteryourname : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ciscoController,
                enabled: false,
                // initialValue: CurrentUser?.ciscoNumber ?? "",
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).Entercisconumber,
                  hintText: S.of(context).Enteryourcisconumber,
                  prefixIcon: const Icon(
                    Icons.password,
                    color: AppTheme.primaryColor,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? S.of(context).Please : null,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: selectedLocation,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).EnterLocation,
                  hintText: S.of(context).EnterLocation,
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: AppTheme.primaryColor,
                  ),
                ),
                items: locations
                    .map(
                      (loc) => DropdownMenuItem(value: loc, child: Text(loc)),
                    )
                    .toList(),
                onChanged: (val) => selectedLocation = val as String,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).Pleaseselectalocation;
                  }
                  return null;
                },
              ),
              //llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).Enteryourphonenumber,
                  hintText: S.of(context).Enteryourphonenumber,
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: AppTheme.primaryColor,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? S.of(context).Pleaseenteryourphone : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: selectedRequestType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).rquestType,
                  hintText: S.of(context).Selectrequesttype,
                  prefixIcon: const Icon(
                    Icons.request_page,
                    color: AppTheme.primaryColor,
                  ),
                ),
                items: requestTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (val) => selectedRequestType = val as String,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).Pleaseselectarequesttype;
                  }
                  return null;
                },
              ),
              //lllllllllllllllllllllllllllllllllll
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).SelectDate,
                  hintText: S.of(context).Selectdate,
                  prefixIcon: const Icon(
                    Icons.date_range,
                    color: AppTheme.primaryColor,
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: selectedDate == null
                      ? ''
                      : selectedDate.toString().split(' ')[0],
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                    });
                  }
                },
                validator: (value) => selectedDate == null
                    ? S.of(context).Pleaseselectadate
                    : null,
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).Notes,
                  hintText: S.of(context).Enteranyadditionalnotes,
                  prefixIcon: const Icon(
                    Icons.note,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateRequest,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppTheme.primaryColor,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
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
                      S.of(context).Save,
                      style: const TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _confirmDelete,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppTheme.primaryColor,
                  ),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
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
                      S.of(context).Delete,
                      style: const TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
