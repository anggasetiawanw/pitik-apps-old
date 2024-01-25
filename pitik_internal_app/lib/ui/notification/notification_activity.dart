import 'package:components/global_var.dart';
import 'package:components/progress_loading/progress_loading.dart';
import 'package:engine/util/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pitik_internal_app/ui/notification/notification_controller.dart';
import 'package:pitik_internal_app/widget/common/custom_appbar.dart';

class NotificationActivity extends StatelessWidget {
  const NotificationActivity({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationController controller = Get.put(NotificationController(context: context));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppbar(title: "Notification", onBack: () => Get.back(), actions: [
            PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: Colors.white), // add this line
                itemBuilder: (_) => <PopupMenuItem<String>>[
                      PopupMenuItem<String>(
                          value: 'Baca Semua',
                          child: Container(
                              height: 32,
                              width: 120,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                              child: Text(
                                'Baca Semua',
                                style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium),
                              ))),
                    ],
                onSelected: (index) async {
                  switch (index) {
                    case 'Baca Semua':
                      controller.onReadAllNotification();
                      break;
                  }
                })
          ])),
      body: Obx(
        () => controller.notificationList.isEmpty
            ? Center(child: Text("Tidak ada notifikasi", style: GlobalVar.blackTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium)))
            : RawScrollbar(
                thumbVisibility: true,
                controller: controller.scrollController,
                thumbColor: GlobalVar.primaryOrange,
                radius: const Radius.circular(8),
                child: RefreshIndicator(
                  onRefresh: () => Future.delayed(const Duration(milliseconds: 200), () {
                    controller.notificationList.clear();
                    controller.page = 1;
                    controller.getListNotification();
                  }),
                  child: controller.isLoading.isTrue
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16, top: 16),
                          child: Image.asset('images/card_height_450_lazy.gif'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.isLoadMore.isTrue ? controller.notificationList.length + 1 : controller.notificationList.length,
                          itemBuilder: (context, index) {
                            int length = controller.notificationList.length;
                            if (index >= length) {
                              return const Column(
                                children: [
                                  Center(child: ProgressLoading()),
                                  SizedBox(height: 100),
                                ],
                              );
                            }
                            return GestureDetector(
                              onTap: () => controller.onTapNotification(index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: controller.notificationList[index].isRead! ? Colors.white : GlobalVar.primaryLight, border: Border.all(color: controller.notificationList[index].isRead! ? GlobalVar.outlineColor : GlobalVar.primaryLight)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Center(
                                              child: SvgPicture.asset(controller.notificationList[index].isRead! ? "images/notification_off_icon.svg" : "images/notification_icon.svg"),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.notificationList[index].headline ?? "",
                                                style: GlobalVar.blackTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: GlobalVar.medium,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                controller.notificationList[index].subHeadline ?? "",
                                                style: GlobalVar.greyTextStyle.copyWith(
                                                  fontSize: 10,
                                                  fontWeight: GlobalVar.regular,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                DateFormat("dd MMMM yyyy - HH:mm").format(Convert.getDatetime(controller.notificationList[index].isRead! ? controller.notificationList[index].createdDate! : controller.notificationList[index].modifiedDate!)),
                                                style: GlobalVar.greyTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.regular),
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (!controller.notificationList[index].isRead!) ...[
                                      Container(
                                        height: 4,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                                          border: Border.all(width: 1, color: GlobalVar.primaryOrange),
                                          color: GlobalVar.primaryOrange,
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
      ),
    );
  }
}
