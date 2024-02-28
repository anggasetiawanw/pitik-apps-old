import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 06/07/23

class PerformaActivity extends StatefulWidget {
  const PerformaActivity({super.key});

  @override
  State<PerformaActivity> createState() => _PerformaActivityState();
}

class _PerformaActivityState extends State<PerformaActivity> {
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

  Future<void> _getAppVersion() async {
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
              'images/pitik_avatar.svg',
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
                  'Kun',
                  style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 16),
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Robert.Kuncoro@pitik.id',
                  style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),
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
          SizedBox(width: Get.width, child: Image.asset('images/header_bg.png')),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selamat Datang\nDi Internal App!',
                  style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
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

    return Scaffold(
      body: Column(
        children: [
          header(),
          nameInfo(),
          Container(
            margin: const EdgeInsets.only(top: 32, left: 39, right: 39),
            child: const Divider(
              color: GlobalVar.outlineColor,
              thickness: 1.6,
            ),
          ),
          GestureDetector(
            onTap: () {
              // AuthImpl().delete(null, []);
              // UserGoogleImpl().delete(null, []);
              // Get.offNamed(RoutePage.loginPage);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 30, left: 30, top: 34),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'images/logout_icon.svg',
                    height: 22,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Text(
                    'Logout',
                    style: GlobalVar.blackTextStyle,
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'V $_version',
              style: GlobalVar.greyTextStyle,
            ),
          )),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
