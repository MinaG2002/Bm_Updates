import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/Login/model/textfield_wedget.dart';
import 'package:bmproject/BM/Login/view/creat_Account.dart';
import 'package:bmproject/BM/nav_bar/view/nav_bar.dart';
import 'package:bmproject/BM/admin/Nav_Admin/nav_admin.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // final usernameController = TextEditingController();
  final ciscoController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool aaaa = true;

  @override
  void dispose() {
    //  usernameController.dispose();
    ciscoController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _login() async {
    Future<void> checkIfAdmin(String cisco, String phone) async {
      final result = await FirebaseFirestore.instance
          .collection('admin')
          .where('cisco', isEqualTo: cisco)
          .where('password', isEqualTo: phone)
          .get();

      if (result.docs.isNotEmpty) {
        // المستخدم أدمن
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Welcome Admin"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavAdmin()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('بيانات الدخول غير صحيحة')),
        );
      }
    }

    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final provider = Provider.of<UserProvider>(context, listen: false);
      final success = await provider.login(
        //  usernameController.text.trim(),
        ciscoController.text.trim(),
        phoneController.text.trim(),
      );

      setState(() => isLoading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Welcome Agent"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomNavBarBM()),
        );
      } else {
        await checkIfAdmin(
          ciscoController.text.trim(),
          phoneController.text.trim(),
        );
      }
    }
  }

  void _openWhatsAppAdmin() async {
    final message = Uri.encodeComponent(
      "I'm experiencing an issue with my Cisco ID or password. I would appreciate your assistance.",
    );
    int phone = 1228319567;
    final url = Uri.parse("https://wa.me/20$phone?text=$message");

    if (true) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    //  else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("❌ لا يمكن فتح واتساب")),
    //   );
    // }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("نسيت كلمة السر؟"),
        content: const Text("يرجى التواصل مع الإدارة لاستعادة بياناتك."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إغلاق"),
          ),
          TextButton(
            onPressed: _openWhatsAppAdmin,
            child: const Text(
              "التواصل",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("تسجيل الدخول")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 1 / 6),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Baloo2',
                  ),
                ),
                const Text(
                  "Hi!Welcome back,you`ve been missed",
                  style: TextStyle(fontFamily: 'Baloo2'),
                ),
                const SizedBox(height: 100),
                CustomTextField(
                  lapel: "Cisco Number ",
                  TextInputTypeee: TextInputType.number,
                  Trueee: false,
                  Hinttexttt: "Enter your cisco",
                  controlll: ciscoController,
                ),
                const SizedBox(height: 18),
                const Row(children: [Text("Password")]),
                const SizedBox(height: 5),
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Please Enter " : null,
                  textInputAction: TextInputAction.next,
                  controller: phoneController,
                  keyboardType: TextInputType.text,
                  obscureText: aaaa,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        // aaaa = !aaaa;
                        setState(() {
                          aaaa = !aaaa;
                        });
                      },
                      icon: aaaa
                          ? const Icon(
                              Icons.visibility,
                              color: AppTheme.primaryColor,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: AppTheme.primaryColor,
                            ),
                    ),
                    hintText: "************",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        width: 1.5,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 20, bottom: 10),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(flex: 1),
                    TextButton(
                      onPressed: _forgotPassword,
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppTheme.primaryColor,
                    ),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: const Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatAccount(),
                          ),
                        );
                      },
                      child: const Text(
                        'sign Up',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
