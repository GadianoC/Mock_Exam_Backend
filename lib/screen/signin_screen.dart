// import 'package:ai_app/auth.dart';
// import 'package:ai_app/screen/home_screen.dart';
// import 'package:flutter/material.dart';

// class SigninScreen extends StatelessWidget {
//   const SigninScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign In'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final user = await signInWithGoogle();
//             if (user != null && context.mounted) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const HomeScreen(),
//                 ),
//               );
//             }
//           },
//           child: const Text('Sign in with Google'),
//         ),
//       ),
//     );
//   }
// }
