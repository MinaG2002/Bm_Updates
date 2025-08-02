// import 'package:flutter/material.dart';

// class UpdateScreen extends StatelessWidget {
//   const UpdateScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200], // خلفية رمادية ناعمة
//       body: Center(
//         child: Container(
//           width: 320,
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 10,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircleAvatar(
//                 backgroundColor: Colors.red,
//                 radius: 36,
//                 child: Icon(Icons.settings, color: Colors.white, size: 36),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Update Available',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'A new version of the app is available. '
//                 'Please update to get the latest features and performance improvements.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   OutlinedButton(
//                     onPressed: () {
//                       // تنفيذ عند الضغط على "Later"
//                     },
//                     child: const Text('Later'),
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                     ),
//                     onPressed: () {
//                       // تنفيذ عند الضغط على "Update Now"
//                     },
//                     child: const Text('Update Now'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
