
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 02/08/23

class ProfileActivity extends StatefulWidget {
  const ProfileActivity({super.key});

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
      return Container(
        margin: const EdgeInsets.only(top: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/pitik_avatar.svg",
              width: 64,
              height: 64,
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(
                      "${GlobalVar.profileUser!.name}",
                      style: GlobalVar.blackTextStyle
                          .copyWith(fontWeight: GlobalVar.bold, fontSize: 16),
                      overflow: TextOverflow.clip,
                  ),
                  const SizedBox(
                      height: 4,
                  ),
                  Text(
                      "${GlobalVar.profileUser!.role}",
                      style: GlobalVar.greyTextStyle
                          .copyWith(fontSize: 12),
                      overflow: TextOverflow.clip,
                  ),
              ],
            )
          ],
        ),
      );
    }

    Widget header() {
        return Stack(
            children: [
              SizedBox(
                  width: Get.width, child: Image.asset("images/header_bg.png")),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 42),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selamat Datang\nDi Pitik Connect!",
                      style: GlobalVar.whiteTextStyle
                          .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
                    ),
                    // Container(
                    //   width: 40,
                    //   height: 28,
                    //   child: Stack(
                    //     children: [
                    //       Align(
                    //         alignment: Alignment.bottomRight,
                    //         child: SvgPicture.asset(
                    //           "images/notification_icon.svg",
                    //           width: 21,
                    //           height: 20,
                    //         ),
                    //       ),
                    //       Container(
                    //         width: 30,
                    //         height: 16,
                    //         decoration: BoxDecoration(
                    //             color: GlobalVar.red,
                    //             borderRadius: BorderRadius.circular(8)),
                    //         child: Center(
                    //             child: Text(
                    //           "333",
                    //           style: GlobalVar.whiteTextStyle.copyWith(
                    //               fontSize: 10, fontWeight: GlobalVar.medium),
                    //         )),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          );
    }

    Widget listComponent(Function() onTap, String imagePath, String title){
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
        backgroundColor: Colors.white,
        body: Stack(
            children: [
                SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          header(),
                          nameInfo(),
                          Container(
                              margin: const EdgeInsets.only(top: 32,left: 39, right: 39),
                              child: const Divider(
                                  color: GlobalVar.outlineColor,
                                  thickness: 1.6,
                              ),
                          ),
                          listComponent(() => Get.toNamed(RoutePage.changePassPage, arguments: false), "images/key_icon.svg", "Ubah Kata Sandi"),
                          listComponent(() => Get.toNamed(RoutePage.privacyPage, arguments: false), "images/privacy.svg", "Kebijakan Privasi"),
                          listComponent(() => Get.toNamed(RoutePage.termPage), "images/term.svg", "Syarat & Ketentuan"),
                          listComponent(() => Get.toNamed(RoutePage.aboutUsPage), "images/about_us.svg", "Tentang Kami"),
                          listComponent(() => Get.toNamed(RoutePage.helpPage), "images/help.svg", "Bantuan"),
                          listComponent(() => Get.toNamed(RoutePage.licensePage), "images/license.svg", "Lisensi"),
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
