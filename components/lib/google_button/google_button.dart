import 'package:components/global_var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function(String? accessToken, String? error) onTapCallback;
  const GoogleSignInButton({super.key, required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;

    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
                final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

                AuthCredential credential = GoogleAuthProvider.credential(
                  accessToken: googleSignInAuthentication.accessToken,
                  idToken: googleSignInAuthentication.idToken,
                );

                final UserCredential userCredential = await auth.signInWithCredential(credential);
                onTapCallback(userCredential.credential!.accessToken, null);
              } catch (err) {
                onTapCallback(null, "Terjadi Kesalah Internal, $err");
              }
            },
            style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black54, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(width: 2, color: GlobalVar.gray))),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child:
                    Row(children: [SvgPicture.asset('images/google_icon.svg', width: 64, height: 64), Text("Login with Google", textAlign: TextAlign.center, style: TextStyle(color: GlobalVar.black, fontSize: 14, fontWeight: GlobalVar.medium))]))));
  }
}
