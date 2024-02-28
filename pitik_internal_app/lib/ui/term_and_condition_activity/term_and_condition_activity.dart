//
// // ignore_for_file: must_be_immutable, no_logic_in_create_state
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:mobile_flutter/component/button_fill/button_fill.dart';
// import 'package:mobile_flutter/component/listener/buttonlistener.dart';
// import 'package:mobile_flutter/engine/model/auth.dart';
// import '../engine/util/globar_var.dart';
// import 'dashboard_activity.dart';
//
// /*
//   @author AKBAR <dicky.maulana@pitik.id>
//  */
//
// class TermAndConditionActivity extends StatefulWidget {
//
//     Auth auth;
//
//     TermAndConditionActivity({super.key, required this.auth});
//
//     @override
//     State<StatefulWidget> createState() => TermAndConditionState(auth: auth);
// }
//
// class TermAndConditionState extends State<TermAndConditionActivity> implements ButtonListener {
//
//     Auth auth;
//     TermAndConditionState({required this.auth});
//
//     late ButtonState _buttonState;
//     final _controller = ScrollController();
//     bool showBottomSheet = false;
//
//     @override
//     void initState() {
//         super.initState();
//
//         // Setup the listener.
//         _controller.addListener(() {
//             if (_controller.position.pixels > 0 && _controller.position.atEdge) {
//                 _buttonState.enable();
//             } else {
//                 _buttonState.disable();
//             }
//         });
//     }
//
//     @override
//     Widget build(BuildContext context) {
//         return Scaffold(
//             backgroundColor: Colors.white,
//             body: ListView(
//                 controller: _controller,
//                 children: [
//                     Center(
//                         child: Text(
//                             "Kebijikan Privasi\nPitik Digital Indonesia",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(color: AppColors.primaryOrange, fontSize: 16)
//                         ),
//                     ),
//                     Center(
//                         child: Text(
//                             "Terakhir di perbarui 17 Des 2022 - 10:00",
//                             textAlign: TextAlign.left,
//                             style: TextStyle(color: AppColors.greyText, fontSize: 12)
//                         ),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Html(data: Constant.privacyPolicy)
//                     )
//                 ],
//             ),
//             bottomSheet: Material(
//                 elevation: 50,
//                 color: Colors.white,
//                 child: Padding(
//                     padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
//                     child: ButtonFill(buttonListener: this, label: 'Saya Setuju')
//                 ),
//             )
//         );
//     }
//
//     @override
//     void onButtonClick(int id) {
//         Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => DashboardActivity(auth: auth)),
//             (Route<dynamic> route) => false
//         );
//     }
//
//     @override
//     void onButtonStateReturn(int id, dynamic button) {
//         _buttonState = button;
//         _buttonState.disable();
//     }
// }
