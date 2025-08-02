import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/Swap/controller/con_swap.dart';
import 'package:bmproject/BM/Swap/model/request_swa.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  State<AddRequestPage> createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ciscoController = TextEditingController();
  final phoneController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedLocation;
  String? selectedRequestType;
  DateTime? selectedDate;

  final locations = ['Dokki', 'DownTown', ' Nasr City', "October"];
  final requestTypes = ['Shift', 'Off', 'annual leave'];

  @override
  void dispose() {
    nameController.dispose();
    ciscoController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final cisco = userProvider.userCisco;
    final name = userProvider.userName;
    ciscoController.text = cisco ?? "33";
    super.initState();
  }
  // @override
  // void initState() {
  //   final currentUser =
  //       Provider.of<UserProvider>(context, listen: false).currentUser;
  //   if (currentUser != null) {
  //     ciscoController.text = currentUser.ciscoNumber;
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            S.of(context).AddaSwapRequest,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),
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
                keyboardType: TextInputType.text,
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).EnterLocation,
                  hintText: "Enter your Location",
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
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: Colors.grey,
                  labelText: S.of(context).SelectDate,
                  hintText: S.of(context).SelectDate,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      selectedLocation != null &&
                      selectedRequestType != null &&
                      selectedDate != null) {
                    final request = RequestModel(
                      id: '',
                      name: nameController.text,
                      ciscoNumber: ciscoController.text,
                      location: selectedLocation!,
                      phone: phoneController.text,
                      requestType: selectedRequestType!,
                      date: selectedDate!.toString().split(' ')[0],
                      notes: notesController.text,
                    );
                    await provider.addRequest(request);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddRequestPage(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          S.of(context).addrequestsuccessfully,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: AppTheme.secondaryColor,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  S.of(context).SubmitRequest,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
