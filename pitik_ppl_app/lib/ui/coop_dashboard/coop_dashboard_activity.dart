
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pitik_ppl_app/ui/coop_dashboard/coop_dashboard_controller.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class CoopDashboardActivity extends GetView<CoopDashboardController> {
    const CoopDashboardActivity({super.key});

    @override
    Widget build(BuildContext context) {
        return Obx(() =>
            Scaffold(
                backgroundColor: Colors.white,
                key: scaffoldKey,
                floatingActionButton: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: GestureDetector(
                        onTap: () => controller.showMenuBottomSheet(),
                        child: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                color: GlobalVar.primaryOrange,
                                shape: BoxShape.circle
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [SvgPicture.asset('images/floating_home_icon.svg')]
                            )
                        )
                    )
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: SafeArea(
                    child: Stack(
                        children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                                        color: GlobalVar.primaryLight
                                    ),
                                )
                            ),
                            Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 6),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                            GestureDetector(
                                                onTap: () => Get.back(),
                                                child: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                        color: GlobalVar.redBackground
                                                    ),
                                                    child: Row(
                                                        children: [
                                                            Text('${controller.coop.coopName} (Hari ${controller.coop.day})', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: GlobalVar.red)),
                                                            const SizedBox(width: 16),
                                                            SvgPicture.asset('images/arrow_diagonal_red_icon.svg')
                                                        ],
                                                    )
                                                ),
                                            ),
                                            SizedBox(
                                                width: 50,
                                                height: 34,
                                                child: Stack(
                                                    children: [
                                                        Positioned(
                                                            left: 16,
                                                            top: 5,
                                                            child: SvgPicture.asset('images/notification_icon.svg', width: 24, height: 24)
                                                        ),
                                                        Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                                color: GlobalVar.red
                                                            ),
                                                            child: Padding(
                                                                padding: const EdgeInsets.all(4),
                                                                child: Text('200', style: GlobalVar.subTextStyle.copyWith(fontSize: 10, fontWeight: GlobalVar.medium, color: Colors.white)),
                                                            ),
                                                        )
                                                    ],
                                                ),
                                            )
                                        ]
                                    )
                                )
                            ),
                            Positioned(
                                top: 58,
                                left: 16,
                                right: 16,
                                child: controller.profileTab.isTrue ? const SizedBox() : Text('Halo ${GlobalVar.profileUser!.fullName}', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium, color: Colors.black)),
                            ),
                            Positioned.fill(
                                top: 90,
                                left: controller.historyTab.isFalse ? 16 : 0,
                                right: controller.historyTab.isFalse ? 16 : 0,
                                child: controller.isLoading.isTrue ? Image.asset(
                                    "images/card_height_450_lazy.gif",
                                    height: 400,
                                    width: 450,
                                ) :
                                (
                                    controller.homeTab.isTrue ? controller.generateHomeWidget() : // to home
                                    controller.historyTab.isTrue ? controller.generateHistoryWidget() : // to history
                                    controller.monitorTab.isTrue ? controller.generateMonitorWidget() : // to monitor
                                    controller.generateProfileWidget() // to profile
                                )
                            ),
                            Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: BottomNavigationBar(
                                    type: BottomNavigationBarType.fixed,
                                    elevation: 15,
                                    backgroundColor: Colors.white,
                                    items: <BottomNavigationBarItem>[
                                        BottomNavigationBarItem(
                                            activeIcon: SvgPicture.asset('images/home_active_icon.svg'),
                                            icon: SvgPicture.asset('images/home_inactive_icon.svg'),
                                            label: 'Beranda',
                                        ),
                                        BottomNavigationBarItem(
                                            activeIcon: SvgPicture.asset('images/history_active_icon.svg'),
                                            icon: SvgPicture.asset('images/history_inactive_icon.svg'),
                                            label: 'Riwayat',
                                        ),
                                        const BottomNavigationBarItem(
                                            activeIcon: SizedBox(),
                                            icon: SizedBox(),
                                            label: '',
                                        ),
                                        BottomNavigationBarItem(
                                            activeIcon: SvgPicture.asset('images/monitor_active_icon.svg'),
                                            icon: SvgPicture.asset('images/monitor_inactive_icon.svg'),
                                            label: 'Monitor',
                                        ),
                                        BottomNavigationBarItem(
                                            activeIcon: SvgPicture.asset('images/profile_active_icon.svg'),
                                            icon: SvgPicture.asset('images/profile_inactive_icon.svg'),
                                            label: 'Profile',
                                        ),
                                    ],
                                    currentIndex: controller.homeTab.isTrue ? 0 : controller.historyTab.isTrue ? 1 : controller.monitorTab.isTrue ? 3 : controller.profileTab.isTrue ? 4 : -1,
                                    selectedItemColor: GlobalVar.primaryOrange,
                                    unselectedItemColor: GlobalVar.gray,
                                    showUnselectedLabels: true,
                                    onTap: (position) {
                                        if (position == 0) {
                                            controller.toHome(context);
                                        } else if (position == 1) {
                                            controller.toHistory();
                                        } else if (position == 3) {
                                            controller.toMonitor();
                                        } else if (position == 4) {
                                            controller.toProfile();
                                        }
                                    },
                                )
                            )
                        ]
                    ),
                )
            )
        );
    }
}