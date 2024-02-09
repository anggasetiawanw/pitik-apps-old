import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/global_variable.dart';
import 'package:pitik_internal_app/ui/home/beranda_activity/beranda_controller.dart';
import 'package:pitik_internal_app/utils/constant.dart';
import 'package:pitik_internal_app/utils/route.dart';
import 'package:pitik_internal_app/widget/common/loading.dart';

class BerandaActivity extends StatelessWidget {
  const BerandaActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final BerandaController controller = Get.put(BerandaController(context: context));

    @override
    Widget header() {
      return Stack(
        children: [
          Image.asset("images/header_ios.png"),
          SafeArea(
            child: Padding(
              padding:  EdgeInsets.only(left: Get.width * 0.8, top: 24, bottom: 16, right: 6),
              child: GestureDetector(
                onTap: () => Get.toNamed(RoutePage.notification),
                child: SizedBox(
                  width: 50,
                  height: 34,
                  child: Stack(
                    children: [
                      Positioned(left: 12, top: 8, child: SvgPicture.asset('images/notification_icon.svg', width: 24, height: 24)),
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: AppColors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Obx(() => Text(controller.countUnreadNotifications.toString(), style: AppTextStyle.subTextStyle.copyWith(fontSize: 10, fontWeight: AppTextStyle.medium, color: Colors.white)),)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget toolTab() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Fitur Produksi",
              style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.bold),
            ),
            SizedBox(
              width: 68,
              height: 26,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        if (controller.isList.isFalse) {
                          controller.isList.value = true;
                        }
                      },
                      child: Obx(
                        () => Container(
                          width: 34,
                          height: 26,
                          decoration: BoxDecoration(color: controller.isList.isTrue ? const Color(0xFFFEEFD2) : const Color(0xFFFAFAFA), borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))),
                          child: Center(
                            child: SvgPicture.asset(controller.isList.isTrue ? "images/list_on_icon.svg" : "images/list_off_icon.svg"),
                          ),
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      if (controller.isList.isTrue) {
                        controller.isList.value = false;
                      }
                    },
                    child: Obx(
                      () => Container(
                        width: 34,
                        height: 26,
                        decoration: BoxDecoration(color: controller.isList.isTrue ? const Color(0xFFFAFAFA) : const Color(0xFFFEEFD2), borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4))),
                        child: Center(
                          child: SvgPicture.asset(controller.isList.isTrue ? "images/grid_off_icon.svg" : "images/grid_on_icon.svg"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget menuWidget() {
      return Obx(() => controller.isList.isTrue
          ? Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.module.value.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(controller.module.value[index]['homeRoute'])!.then((value) => controller.refreshHome(context));
                        Constant.track("Click_Menu_${controller.module.value[index]['nameModule']}");
                      },
                      child: Container(
                        width: double.infinity,
                        height: 64,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.outlineColor), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(color: AppColors.iconHomeBg, borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                child: SvgPicture.asset(controller.module.value[index]['iconPath']),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              controller.module.value[index]['nameIcon'],
                              style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          : Expanded(
              child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: controller.module.value.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(controller.module.value[index]['homeRoute'])!.then((value) => controller.refreshHome(context));
                        Constant.track("Click_Menu_${controller.module.value[index]['nameModule']}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          height: 104,
                          width: 104,
                          decoration: BoxDecoration(border: Border.all(width: 1, color: AppColors.outlineColor), borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(color: AppColors.iconHomeBg, borderRadius: BorderRadius.circular(6)),
                                  child: Center(
                                    child: SvgPicture.asset(controller.module.value[index]['iconPath']),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  controller.module.value[index]['nameIcon'],
                                  style: AppTextStyle.blackTextStyle.copyWith(fontWeight: AppTextStyle.medium),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => controller.isLoading.isTrue
          ? const Center(
              child: ProgressLoading(),
            )
          : Column(
              children: [
                header(),
                const SizedBox(
                  height: 16,
                ),
                if (controller.module.value.isEmpty) ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("images/akses_disable.svg"),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                "Oops.. maaf kamu tidak memiliki akses untuk masuk ke halaman ini",
                                style: AppTextStyle.greyTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ))
                        ],
                      ),
                    ),
                  )
                ] else ...[
                  toolTab(),
                  const SizedBox(
                    height: 14,
                  ),
                  menuWidget()
                ]
              ],
            )),
    );
  }
}
