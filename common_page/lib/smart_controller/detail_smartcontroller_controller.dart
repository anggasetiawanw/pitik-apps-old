
import 'dart:async';

import 'package:common_page/smart_controller/dashboard_fan/dashboard_fan_activity.dart';
import 'package:common_page/smart_controller/dashboard_lamp/dashboard_lamp_activity.dart';
import 'package:common_page/smart_controller/setup_alarm/alarm_setup_activity.dart';
import 'package:common_page/smart_controller/setup_cooler/cooler_setup_activity.dart';
import 'package:common_page/smart_controller/setup_growth/growth_setup_activity.dart';
import 'package:common_page/smart_controller/setup_heater/heater_setup_activity.dart';
import 'package:common_page/smart_controller/setup_reset/reset_time_activity.dart';
import 'package:components/device_controller_status.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/list_card_smartcontroller/card_list_controller.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_controller_model.dart';
import 'package:model/device_model.dart';
import 'package:model/device_summary_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/detail_controller_response.dart';
import 'package:model/response/floor_list_response.dart';
import 'package:model/sensor_data_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 31/10/2023

class SmartControllerDashboardController extends GetxController {
    BuildContext context;
    SmartControllerDashboardController({required this.context});
    
    ScrollController scrollController = ScrollController();
    
    var isLoadMore = false.obs;
    var pageSmartMonitor = 1.obs;
    var pageSmartController = 1.obs;
    var pageSmartCamera = 1.obs;
    var limit = 10.obs;
    var deviceUpdatedName = "".obs;
    late DateTime timeStart;

    late Coop coop;
    late Device device;
    late String basePath;
    String? modifySmartMonitorPage;
    
    DeviceController? deviceController;
    ScrollController scrollMonitorController = ScrollController();

    Rx<CardListSmartController> monitorContainer = CardListSmartController(
        device: null,
        onTap: () {},
        isItemList: false,
    ).obs;

    scrollPurchaseListener() async {
        scrollMonitorController.addListener(() {
            if (scrollMonitorController.position.maxScrollExtent == scrollMonitorController.position.pixels) {
                isLoadMore.value = true;
                pageSmartMonitor++;
            }
        });
    }
    
    var isLoading = false.obs;
    late EditField efBuildingName = EditField(
        controller: GetXCreator.putEditFieldController("efBuildingName"),
        label: "Kandang",
        hint: "Ketik Disini",
        alertText: "Nama Kandang",
        textUnit: "",
        inputType: TextInputType.text,
        maxInput: 20,
        onTyping: (value, control) {}
    );
    late SpinnerField spBuildingType = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("spBuildingType"),
        label: "Jenis Kandang",
        hint: "Pilih Salah Satu",
        alertText: "Jenis Kandang harus dipilih!",
        items: const {"Open House": false, "Semi House": false, "Close House": false},
        onSpinnerSelected: (value) {}
    );

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        device = Get.arguments[1];
        basePath = Get.arguments[2];
        if (Get.arguments.length > 3) {
            modifySmartMonitorPage = Get.arguments[3];
        }

        getDetailSmartController();
    }

    void getDetailSmartController() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            timeStart = DateTime.now();

            Service.push(
                apiKey: 'smartControllerApi',
                service: ListApi.getDetailSmartController,
                context: context,
                body: ['Bearer ${auth.token}', auth.id, GlobalVar.xAppId ?? '', ListApi.pathDeviceData(
                    basePath,
                    'summary',
                    modifySmartMonitorPage != null ? device.deviceSummary!.coopCodeId! : device.coopId ?? '-',
                    modifySmartMonitorPage != null ? device.deviceSummary!.deviceId! : device.deviceId ?? '-'
                )],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        if((body as DetailControllerResponse).data != null) {
                            deviceController = (body).data;
                        }

                        DateTime timeEnd = DateTime.now();
                        GlobalVar.sendRenderTimeMixpanel("Open_smart_controller_page", timeStart, timeEnd);
                        isLoading.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet){
                        isLoading.value = false;
                        Get.snackbar(
                            "Pesan", "Terjadi Kesalahan, ${(body as ErrorResponse).error!.message}",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                        );
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        isLoading.value = false;
                        Get.snackbar(
                            "Pesan", "Terjadi Kesalahan Internal",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 5),
                            backgroundColor: Colors.red,
                        );
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );

            if (modifySmartMonitorPage == null) {
                Service.push(
                    apiKey: 'smartControllerApi',
                    service: ListApi.getFloorList,
                    context: Get.context!,
                    body: ['Bearer ${auth.token}', auth.id, coop.id],
                    listener: ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            if ((body as FloorListResponse).data != null) {
                                for (var floor in body.data!.floor) {
                                    if (floor != null && floor.deviceId == device.deviceId) {
                                        device.deviceSummary = DeviceSummary(
                                            temperature: SensorData(value: floor.temperature ?? 0.0, status: 'good', uom: '°C'),
                                            relativeHumidity: SensorData(value: floor.humidity ?? 0.0, status: 'bad', uom: '%')
                                        );

                                        monitorContainer.value = CardListSmartController(
                                            device: device,
                                            onTap: () {},
                                            isItemList: false,
                                        );
                                    }
                                }
                            }
                        },
                        onResponseFail: (code, message, body, id, packet) => Get.snackbar("Pesan", '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red),
                        onResponseError: (exception, stacktrace, id, packet) => Get.snackbar("Pesan", exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red),
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    )
                );
            }
        } else {
            GlobalVar.invalidResponse();
        }
    });

    /// The `itemGridview` function returns a GridView widget with a specified
    /// number of items per row and calculates the height based on the width of
    /// the screen.
    ///
    /// Args:
    ///   width (double): The `width` parameter is the width of the
    /// itemGridview. It is used to calculate the height of the itemGridview
    /// based on the number of items per row and the aspect ratio of the items.
    ///
    /// Returns:
    ///   The code is returning a widget called `itemGridview`.
    Widget itemGridview(double width) {
        const int count = 7;
        const int itemsPerRow = 2;
        const double ratio = 1 / 1;
        const double horizontalPadding = 0;
        final double calcHeight = ((width / itemsPerRow) - (horizontalPadding)) * (count / itemsPerRow).ceil() * (1 / ratio);

        return SizedBox(
            height: calcHeight,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: 7,
                itemBuilder: (_, index) {
                    return GestureDetector(
                        onTap: () {
                            if (index == 0 && deviceController!.growthDay != null) {
                                Get.to(const GrowthSetupActivity(), arguments: [device , deviceController!.growthDay, basePath, modifySmartMonitorPage != null])!.then((value) {
                                    isLoading.value = true;
                                    Timer(const Duration(milliseconds: 100), () => getDetailSmartController());
                                });
                            } else if(index == 1 && deviceController!.fan != null) {
                                Get.to(const DashboardFanActivity(), arguments: [device, deviceController!.fan, basePath, modifySmartMonitorPage != null])!.then((value) {
                                    isLoading.value = true;
                                    Timer(const Duration(milliseconds: 100), () => getDetailSmartController());
                                });
                            } else if(index == 2 && deviceController!.heater != null) {
                                Get.to(const HeaterSetupActivity(), arguments: [device, deviceController!.heater, basePath, modifySmartMonitorPage != null])!.then((value) {
                                    isLoading.value = true;
                                    Timer(const Duration(milliseconds: 100), () => getDetailSmartController());
                                });
                            } else if(index == 3 && deviceController!.cooler != null) {
                                Get.to(const CoolerSetupActivity(), arguments: [device, deviceController!.cooler, basePath, modifySmartMonitorPage != null])!.then((value) {
                                    isLoading.value = true;
                                    Timer(const Duration(milliseconds: 100), () => getDetailSmartController());
                                });
                            } else if(index == 4 && deviceController!.lamp != null) {
                                Get.to(const DashboardLamp(), arguments: [device, deviceController!.lamp, basePath, modifySmartMonitorPage != null])!.then((value) {
                                    isLoading.value = true;
                                    Timer(const Duration(milliseconds: 100), () => getDetailSmartController());
                                });
                            } else if(index == 5 && deviceController!.alarm != null) {
                                Get.to(const AlarmSetupActivity(), arguments: [device, deviceController!.alarm, basePath, modifySmartMonitorPage != null])!.then((value) {
                                    isLoading.value = true;
                                    Timer(const Duration(milliseconds: 100), () => getDetailSmartController());
                                });
                            } else if(index == 6 && deviceController!.resetTime != null) {
                                Get.to(const ResetTimeActivity(), arguments: [device, deviceController!.resetTime, basePath, modifySmartMonitorPage != null])!.then((value) {
                                    isLoading.value = true;
                                    Timer(const Duration(milliseconds: 100), () => getDetailSmartController());
                                });
                            }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: index == 0 && deviceController!.growthDay != null ? null :
                                           index == 0 && deviceController!.growthDay == null ?  const Color(0xFFFDDFD1) :
                                           index == 1 && deviceController!.fan != null ?  null :
                                           index == 1 && deviceController!.fan == null ?  const Color(0xFFFDDFD1) :
                                           index == 2 && deviceController!.heater != null ?  null :
                                           index == 2 && deviceController!.heater == null ?  const Color(0xFFFDDFD1) :
                                           index == 3 && deviceController!.cooler != null ?  null :
                                           index == 3 && deviceController!.cooler == null ?  const Color(0xFFFDDFD1) :
                                           index == 4 && deviceController!.lamp != null ?  null :
                                           index == 4 && deviceController!.lamp == null ?  const Color(0xFFFDDFD1) :
                                           index == 5 && deviceController!.alarm != null ?  null :
                                           index == 5 && deviceController!.alarm == null ?  const Color(0xFFFDDFD1) :
                                           index == 6 && deviceController!.resetTime != null ?  null :
                                           index == 6 && deviceController!.resetTime == null ?  const Color(0xFFFDDFD1) :
                                            null,
                                    border: Border.all(width: 1.4, color: GlobalVar.outlineColor),
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color:deviceController!.growthDay == null ? const Color(0xFFFBB8A4) : GlobalVar.iconHomeBg,
                                                        borderRadius: const BorderRadius.only(
                                                            topLeft: Radius.circular(4),
                                                            topRight: Radius.circular(4),
                                                            bottomRight: Radius.circular(4),
                                                            bottomLeft: Radius.circular(4)
                                                        )
                                                    ),
                                                    child: Center(
                                                        child:
                                                        index == 0 && (deviceController!.growthDay == null || deviceController!.growthDay!.status == false)  ? SvgPicture.asset("images/growth_icon.svg") :
                                                        index == 0 && deviceController!.growthDay != null && deviceController!.growthDay!.status! == true  ? SvgPicture.asset("images/growth_icon.svg") :
                                                        index == 1 && deviceController!.fan != null && deviceController!.fan!.status! == true  ? SvgPicture.asset("images/fan_icon.svg") :
                                                        index == 1 && (deviceController!.fan == null || deviceController!.fan!.status! == false) ? SvgPicture.asset("images/fan_error_icon.svg") :
                                                        index == 2 && deviceController!.heater != null && deviceController!.heater!.status! == true ? SvgPicture.asset("images/heater_icon.svg") :
                                                        index == 2 && (deviceController!.heater == null || deviceController!.heater!.status! == false) ? SvgPicture.asset("images/heater_warning_icon.svg") :
                                                        index == 3 && deviceController!.cooler != null && deviceController!.cooler!.status! == true ? SvgPicture.asset("images/cooler_icon.svg") :
                                                        index == 3 && (deviceController!.cooler == null || deviceController!.cooler!.status! == false) ? SvgPicture.asset("images/cooler_error_icon.svg") :
                                                        index == 4 && deviceController!.lamp != null && deviceController!.lamp!.status! == true ? SvgPicture.asset("images/lamp_icon.svg") :
                                                        index == 4 && (deviceController!.lamp == null || deviceController!.lamp!.status! == false) ? SvgPicture.asset("images/lamp_icon.svg") :
                                                        index == 5 && deviceController!.alarm != null ? SvgPicture.asset("images/alarm_icon.svg") :
                                                        index == 5 && (deviceController!.alarm == null )? SvgPicture.asset("images/alarm_error_icon.svg") :
                                                        index == 6 && deviceController!.resetTime != null ? SvgPicture.asset("images/timer_icon.svg") :
                                                        SvgPicture.asset("images/temperature_icon.svg"),
                                                    ),
                                                ),
                                                index == 0 ? DeviceStatus(status:  deviceController!.growthDay!.status!, activeString: "Aktif", inactiveString: "Non-Aktif"):
                                                index == 1 ? DeviceStatus(status:  deviceController!.fan!.status!, activeString: "Aktif", inactiveString: "Non-Aktif") :
                                                index == 2 ? DeviceStatus(status:  deviceController!.heater!.status!, activeString: "Nyala", inactiveString: "Mati"):
                                                index == 3 ? DeviceStatus(status:  deviceController!.cooler!.status!, activeString: "Nyala", inactiveString: "Mati"):
                                                index == 4 ? DeviceStatus(status:  deviceController!.lamp!.status!, activeString: "Nyala", inactiveString: "Mati") :
                                                index == 5 ? const DeviceStatus(status:  true, activeString: "Normal", inactiveString: "Error") :
                                                index == 6 ? const DeviceStatus(status:  true, activeString: "Default", inactiveString: "Default") :
                                                const SizedBox(height: 0),
                                            ],
                                        ),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text(
                                                    index == 0 ? "Masa Tumbuh" :
                                                    index == 1 ? "Kipas" :
                                                    index == 2 ? "Pemanas" :
                                                    index == 3 ? "Pendingin" :
                                                    index == 4 ? "Lampu" :
                                                    index == 5 ? "Alarm" :
                                                    index == 6 ? "Reset Waktu" :
                                                    "",
                                                    style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 14),
                                                ),
                                                Row(
                                                    children: [
                                                        Expanded(
                                                            child: index == 0 ? Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children :[
                                                                    const SizedBox(height: 4),
                                                                    Text('Target Suhu Hari Ini', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                    Text('${deviceController!.growthDay!.temperature} °C', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                    const SizedBox(height: 4),
                                                                    Text('Umur Pertumbuhan', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                    Text('${deviceController!.growthDay!.day} hari', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12))
                                                                ]
                                                            ) : index == 1 ? Text("Nyala ${deviceController!.fan!.online} - Mati ${deviceController!.fan!.offline} ", style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12))
                                                              : index == 2 ?  RichText(
                                                                text: TextSpan(style: const TextStyle(color: Colors.blue), //apply style to all
                                                                    children: [
                                                                        TextSpan(text: 'Suhu', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                        TextSpan(text: ' ${deviceController!.heater!.temperature} °C', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                    ]
                                                                )
                                                            ) : index == 3 ?  RichText(
                                                                text: TextSpan(style: const TextStyle(color: Colors.blue), //apply style to all
                                                                    children: [
                                                                        TextSpan(text: 'Suhu', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                        TextSpan(text: ' ${deviceController!.cooler!.temperature} °C', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                    ]
                                                                )
                                                            ) : index == 4 ?  Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    const SizedBox(height: 4),
                                                                    Text('${deviceController!.lamp!.name!} ', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                    Text('${deviceController!.lamp!.onlineTime} - ${deviceController!.lamp!.offlineTime}', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12))
                                                                ],
                                                            ) : index == 5 ? Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                    RichText(
                                                                        text: TextSpan(style: const TextStyle(color: Colors.blue), //apply style to all
                                                                            children: [
                                                                                TextSpan(text: 'Panas ', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                                TextSpan(text: '${deviceController!.alarm!.hot} °C', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                            ]
                                                                        )
                                                                    ),
                                                                    RichText(
                                                                        text: TextSpan(style: const TextStyle(color: Colors.blue), //apply style to all
                                                                            children: [
                                                                                TextSpan(text: 'Dingin ', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                                TextSpan(text: '${deviceController!.alarm!.cold} °C', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                            ]
                                                                        )
                                                                    )
                                                                ]
                                                            ): index == 6 ? RichText(
                                                                text: TextSpan(style: const TextStyle(color: Colors.blue), //apply style to all
                                                                    children: [
                                                                        TextSpan(text: 'Waktu Bawaan', style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12)),
                                                                        TextSpan(text: ' ${deviceController!.resetTime!.onlineTime}', style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.bold, fontSize: 12)),
                                                                    ]
                                                                )
                                                            ) : Container(),
                                                        )
                                                    ]
                                                ),
                                                const SizedBox(height: 8)
                                            ],
                                        )
                                    ]
                                )
                            )
                        )
                    );
                }
            )
        );
    }
}

class DetailSmartControllerBindings extends Bindings {
    BuildContext context;

    DetailSmartControllerBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => SmartControllerDashboardController(context: context));
    }
}

