import 'package:components/global_var.dart';
import 'package:dao_impl/auth_impl.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/floor_list_response.dart';
import 'package:model/smart_controller/floor_model.dart';
import 'package:pitik_ppl_app/api_mapping/api_mapping.dart';
import 'package:pitik_ppl_app/route.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 01/11/2023

class SmartControllerListController extends GetxController {
    BuildContext context;
    SmartControllerListController({required this.context});

    late Coop coop;
    var isLoading = false.obs;
    RxList<Floor?> floorList = <Floor?>[].obs;

    @override
    void onInit() {
        super.onInit();
        coop = Get.arguments[0];
        getFloorList();
    }

    void getFloorList() => AuthImpl().get().then((auth) {
        if (auth != null) {
            isLoading.value = true;
            Service.push(
                apiKey: ApiMapping.smartControllerApi,
                service: ListApi.getFloorList,
                context: Get.context!,
                body: ['Bearer ${auth.token}', auth.id, coop.id ?? coop.coopId],
                listener: ResponseListener(
                    onResponseDone: (code, message, body, id, packet) {
                        floorList.value = (body as FloorListResponse).data!.floor;
                        isLoading.value = false;
                    },
                    onResponseFail: (code, message, body, id, packet) {
                        Get.snackbar("Pesan", '${(body as ErrorResponse).error!.message}', snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                        isLoading.value = false;
                    },
                    onResponseError: (exception, stacktrace, id, packet) {
                        Get.snackbar("Pesan", exception, snackPosition: SnackPosition.TOP, colorText: Colors.white, backgroundColor: Colors.red);
                        isLoading.value = false;
                    },
                    onTokenInvalid: () => GlobalVar.invalidResponse()
                )
            );
        } else {
            GlobalVar.invalidResponse();
        }
    });

    Widget createFloorCard({Floor? floor}) {
        if (floor != null) {
            return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                child: GestureDetector(
                    onTap: () {
                        Device device = Device(
                            id: floor.id,
                            deviceName: floor.floorName,
                            deviceId: floor.deviceId,
                            coopId: floor.coopId,
                        );
                        Get.toNamed(RoutePage.smartControllerDashboard, arguments: [coop, device, 'v2/controller/coop/', RoutePage.smartMonitorController])!.then((value) => getFloorList());
                    },
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: GlobalVar.primaryLight
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('${coop.coopName} ${floor.floorName ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: Colors.black)),
                                        Text('Hari ${floor.day ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: Colors.black)),
                                    ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Text('Periode ${floor.periode ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                        Text('Chick-in ${floor.chickinDate ?? '-'}', style: GlobalVar.subTextStyle.copyWith(fontSize: 12, fontWeight: GlobalVar.medium, color: Colors.black)),
                                    ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        border: Border.all(color: GlobalVar.outlineColor, width: 1),
                                        color: Colors.white
                                    ),
                                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Container(
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            color: GlobalVar.primaryLight
                                                        ),
                                                        child: SvgPicture.asset('images/temperature_icon.svg')
                                                    ),
                                                    Text('Temperatur', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: Colors.black)),
                                                ]
                                            ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text(floor.temperature == null ? '-' : floor.temperature!.toStringAsFixed(1), style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.green)),
                                                    Text(' \u00B0C', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                ]
                                            )
                                        ],
                                    )
                                ),
                                const SizedBox(height: 16),
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        border: Border.all(color: GlobalVar.outlineColor, width: 1),
                                        color: Colors.white
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Container(
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            color: GlobalVar.primaryLight
                                                        ),
                                                        child: SvgPicture.asset('images/humidity_icon.svg')
                                                    ),
                                                    Text('Kelembaban', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: Colors.black)),
                                                ]
                                            ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                    Text(floor.humidity == null ? '-' : floor.humidity!.toStringAsFixed(1), style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.bold, color: Colors.red)),
                                                    Text(' %', style: GlobalVar.subTextStyle.copyWith(fontSize: 14, fontWeight: GlobalVar.medium, color: GlobalVar.primaryOrange)),
                                                ]
                                            )
                                        ],
                                    )
                                ),
                            ]
                        )
                    ),
                ),
            );
        } else {
            return const SizedBox();
        }
    }
}

class SmartControllerListBinding extends Bindings {
    BuildContext context;
    SmartControllerListBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<SmartControllerListController>(() => SmartControllerListController(context: context));
    }
}