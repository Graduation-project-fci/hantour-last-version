// import 'package:flutter/material.dart';
// import 'package:hantourgo/profile_pages/Icons_in_Profile.dart';

// class drawer extends StatefulWidget {
//   const drawer({super.key});

//   @override
//   State<drawer> createState() => _drawerState();
// }

// class _drawerState extends State<drawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 30,
//           ),
//           Container(
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height / 4,
//             margin: EdgeInsets.all(10),
//             padding: EdgeInsets.only(top: 30),
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 176, 176, 236),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                     height: 50,
//                     width: 50,
//                     child: Image.asset(
//                       "assets/images/twitter.png",
//                     )),
//                 const Text("Mostafa Mahmoud"),
//                 const Text("mostafammalik751@gmail.com"),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 2,
//           ),
//           Container(
//             width: double.infinity,
//             height: MediaQuery.of(context).size.height -
//                 (MediaQuery.of(context).size.height / 4) -
//                 72,
//             margin: EdgeInsets.all(10),
//             padding: EdgeInsets.only(top: 30),
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 176, 176, 236),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Column(
//               children: [Custom_icons(Icon(Icons.abc), "Contact")],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// profile pad

import 'package:flutter/material.dart';
import 'package:profile/profile.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Profile(
        imageUrl:
            "https://images.unsplash.com/photo-1598618356794-eb1720430eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
        name: "Shamim Miah",
        website: "shamimmiah.com",
        designation: "Project Manager | Flutter & Blockchain Developer",
        email: "cse.shamimosmanpailot@gmail.com",
        phone_number: "01145446520",
      ),
    ));
  }
}
