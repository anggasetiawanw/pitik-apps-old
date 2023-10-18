
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:global_variable/text_style.dart';
import 'package:pitik_internal_app/ui/home/beranda_activity/beranda_activity.dart';
import 'package:pitik_internal_app/ui/home/profile_activity/profile_activity.dart';

import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.tabIndex,
            children: const [
              BerandaActivity(),
              ProfileActivity()
            ],
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(158, 157, 157, 0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), 
                    )
                ]
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    GestureDetector(
                        onTap: (){
                            controller.changeTabIndex(0);
                        },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              SvgPicture.asset(controller.tabIndex == 0 ? "images/beranda_on_icon.svg" :"images/beranda_off_icon.svg" ),
                              const SizedBox(height: 5,),
                              Text("Beranda", style: controller.tabIndex == 0 ? AppTextStyle.primaryTextStyle.copyWith(fontWeight: AppTextStyle.medium): AppTextStyle.grayTextStyle.copyWith(fontWeight: AppTextStyle.medium) ),
                          ],
                      ),
                    ),
                    GestureDetector(
                        onTap: (){
                            controller.changeTabIndex(1);
                        },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              SvgPicture.asset(controller.tabIndex == 1 ? "images/profile_on_icon.svg" :"images/profile_off_icon.svg" ),
                              const SizedBox(height: 5,),
                              Text("Profil", style: controller.tabIndex == 1 ? AppTextStyle.primaryTextStyle.copyWith(fontWeight: AppTextStyle.medium): AppTextStyle.grayTextStyle.copyWith(fontWeight: AppTextStyle.medium) ),
                          ],
                      ),
                    ),

                ],
            ),
          )
        );
      },
    );
  }
}