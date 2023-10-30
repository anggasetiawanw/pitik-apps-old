import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';

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
                  "${Constant.profileUser!.fullName}",
                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.bold, fontSize: 16),
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "${Constant.profileUser!.email}",
                  style: AppTextStyle.greyTextStyle.copyWith(fontSize: 12),
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
          SizedBox(width: Get.width, child: Image.asset("images/header_bg.png")),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selamat Datang\nDi Internal App!",
                  style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
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
                //             color: AppColors.red,
                //             borderRadius: BorderRadius.circular(8)),
                //         child: Center(
                //             child: Text(
                //           "333",
                //           style: AppTextStyle.whiteTextStyle.copyWith(
                //               fontSize: 10, fontWeight: AppTextStyle.medium),
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

    Widget listComponent(Function() onTap, String imagePath, String title) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 30, top: 24, right: 30),
          child: Row(
            children: [
              SvgPicture.asset(
                imagePath,
                width: 24,
                height: 24,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                title,
                style: AppTextStyle.blackTextStyle.copyWith(fontSize: 14),
              ),
              if (title != "Logout") ...[const Spacer(), SvgPicture.asset("images/arrow_profile.svg")]
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //   header(),
          Image.asset("images/header_ios.png"),
        //   Flexible(
        //     child: ListView(
        //       children: [
                nameInfo(),
                Container(
                  margin: const EdgeInsets.only(top: 32, left: 39, right: 39),
                  child: const Divider(
                    color: AppColors.outlineColor,
                    thickness: 1.6,
                  ),
                ),
                Obx(() => Constant.isDeveloper.isTrue ? listComponent(() => Get.toNamed(RoutePage.developer), "images/branch_icon.svg", "Developer Option") : const SizedBox()),
                Obx(() => Constant.isChangeBranch.isTrue ? listComponent(() => Get.toNamed(RoutePage.changeBranch), "images/branch_icon.svg", "Ganti Branch") : const SizedBox()),
                listComponent(() => Get.toNamed(RoutePage.privacyPage), "images/privacy.svg", "Kebijakan Privasi"),
                listComponent(() => Get.toNamed(RoutePage.termPage), "images/term.svg", "Syarat & Ketentuan"),
                listComponent(() => Get.toNamed(RoutePage.aboutUsPage), "images/about_us.svg", "Tentang Kami"),
                listComponent(() => Get.toNamed(RoutePage.helpPage), "images/help.svg", "Bantuan"),
                listComponent(() => Get.toNamed(RoutePage.licensePage), "images/license.svg", "Lisensi"),
                listComponent(Constant.invalidResponse(), "images/logout_icon.svg", "Logout"),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "V $_version",
                      style: AppTextStyle.grayTextStyle,
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 80,
                // )
              ],
        //     ),
        //   )
        // ],
      ),
    );
  }
}
