
// ignore_for_file: must_be_immutable

import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class ProfileActivity extends StatefulWidget {
    String homeRoute;
    String changePassRoute;
    String privacyRoute;
    String termRoute;
    String aboutUsRoute;
    String helpRoute;
    String licenseRoute;

    ProfileActivity({super.key, required this.homeRoute, required this.changePassRoute, required this.privacyRoute, required this.termRoute, required this.aboutUsRoute, required this.helpRoute, required this.licenseRoute});

    @override
    State<ProfileActivity> createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {  
    String? _version;
    // String? _buildNumber;
    // String? _buildSignature;
    // String? _appName;
    // String? _packageName;
    // String? _installerStore;
  
  
    @override
    void initState() {
        super.initState();
        _getAppVersion();
    }
  
    void _getAppVersion() async {
        final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  
        final version = packageInfo.version;
    //   final buildNumber = packageInfo.buildNumber;
    //   final buildSignature = packageInfo.buildSignature;
    //   final appName = packageInfo.appName;
    //   final packageName = packageInfo.packageName;
    //   final installerStore = packageInfo.installerStore;
  
        setState(() {
            _version = version;
        // _buildNumber = buildNumber;
        // _buildSignature = buildSignature;
        // _appName = appName;
        // _packageName = packageName;
        // _installerStore = installerStore;
        });
    }

    @override
    Widget build(BuildContext context) {
        Widget nameInfo() {
            String? name = GlobalVar.profileUser!.name == null || GlobalVar.profileUser!.name!.isEmpty ? GlobalVar.profileUser!.fullName :  GlobalVar.profileUser!.name;
            String? role = GlobalVar.profileUser!.role == null || GlobalVar.profileUser!.role!.isEmpty ? GlobalVar.profileUser!.userType : GlobalVar.profileUser!.role;

            return Container(
                margin: const EdgeInsets.only(top: 14, left: 32),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                        SvgPicture.asset("images/pitik_avatar.svg", width: 64, height: 64),
                        const SizedBox(width: 8),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(name ?? '-', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 16), overflow: TextOverflow.clip),
                                const SizedBox(height: 4),
                                Text(role ?? '-', style: GlobalVar.greyTextStyle.copyWith(fontSize: 12), overflow: TextOverflow.clip),
                            ],
                        )
                    ],
                ),
            );
        }

        Widget listComponent(Function() onTap, String imagePath, String title) {
            return GestureDetector(
                onTap: onTap,
                    child: Container(
                    margin: const EdgeInsets.only( left: 30, top: 24, right: 30),
                    child: Row(
                        children: [
                            SvgPicture.asset(imagePath),
                            const SizedBox(width: 18,),
                            Text(title, style: GlobalVar.blackTextStyle.copyWith(fontSize: 14),),
                            if(title != "Logout")...[
                                const Spacer(),
                                SvgPicture.asset("images/arrow_profile.svg")
                           ]
                        ],
                    ),
                ),
            );
        }

        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
                children: [
                    SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              nameInfo(),
                              Container(
                                  margin: const EdgeInsets.only(top: 32,left: 39, right: 39),
                                  child: Divider(
                                      color: GlobalVar.outlineColor,
                                      thickness: 1.6,
                                  ),
                              ),
                              listComponent(() => Get.toNamed(widget.changePassRoute, arguments: [false, widget.homeRoute]), "images/key_icon.svg", "Ubah Kata Sandi"),
                              listComponent(() => Get.toNamed(widget.privacyRoute, arguments: [false, widget.homeRoute]), "images/privacy.svg", "Kebijakan Privasi"),
                              listComponent(() => Get.toNamed(widget.termRoute), "images/term.svg", "Syarat & Ketentuan"),
                              listComponent(() => Get.toNamed(widget.aboutUsRoute), "images/about_us.svg", "Tentang Kami"),
                              listComponent(() => Get.toNamed(widget.helpRoute), "images/help.svg", "Bantuan"),
                              listComponent(() => Get.toNamed(widget.licenseRoute), "images/license.svg", "Lisensi"),
                              listComponent(() => GlobalVar.invalidResponse(), "images/logout_icon.svg", "Logout"),
                              const SizedBox(height: 16,),
                              Align(alignment: Alignment.bottomCenter,child: Text("V $_version",style: GlobalVar.greyTextStyle,),),
                              const SizedBox(height: 40,)
                          ],
                      ),
                    ),
                ],
            )
        );
    }
}
