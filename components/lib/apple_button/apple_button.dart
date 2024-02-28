import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatelessWidget {
  final Function(String? accessToken, String? error) onUserResult;
  const AppleSignInButton({super.key, required this.onUserResult});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: () async {
              try {
                final credentials = await SignInWithApple.getAppleIDCredential(scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName]);
                onUserResult(credentials.identityToken, null);
              } catch (err) {
                onUserResult(null, "Terjadi Kesalah Internal, $err");
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: GlobalVar.black, foregroundColor: Colors.white54, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Row(children: [SvgPicture.asset('images/apple_logo.svg', width: 64, height: 64), Text("Login with Apple ID", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: GlobalVar.medium))]))));
  }
}
