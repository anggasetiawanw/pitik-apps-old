import 'dart:async';

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/card_floor/card_floor.dart';
import 'package:components/card_floor/card_floor_controller.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/error/error.dart';
import 'package:model/response/coop_detail_response.dart';
import 'package:model/response/coop_list_response.dart';
import 'package:model/room_model.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/07/23

class RegisterFloorController extends GetxController {
    BuildContext context;

    RegisterFloorController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

    Rx<List<Coop>> coops = Rx<List<Coop>>([]);
    Rx<List<Room>> rooms = Rx<List<Room>>([]);

    var isLoading = false.obs;
    late Coop detailCoop;
    late DateTime timeStart ;

    late ButtonFill bfYesRegBuilding;
    late ButtonOutline boNoRegBuilding;
    late SpinnerField spBuilding = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("spBuilding"),
        label: "Kandang",
        hint: "Pilih Salah Satu",
        alertText: "Kandang harus dipilih!",
        items: const {},
        onSpinnerSelected: (value) {
            if(value != ""){
                Coop? selectedCoop = coops.value.firstWhere((element) => element.name! == value);
                getDetailCoop(selectedCoop);
            }
        }
    );

    late CardFloor cardFloor ;

    @override
    void onInit() {
        super.onInit();
        timeStart = DateTime.now();
        GlobalVar.track("Open_form_lantai_page");
        cardFloor = CardFloor(
            controller: GetXCreator.putCardFloorController("cardFloorController",context)
        );
        boNoRegBuilding = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("boNoRegBuilding"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        bfYesRegBuilding = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesRegBuilding"),
            label: "Ya",
            onClick: () {
                addRooms();
            },
        );
        getCoops();
    }


    @override
    void onReady() {
        super.onReady();
        Get.find<CardFloorController>(tag: "cardFloorController").numberList.listen((p0) {
            // generateListProduct(p0);
        });
        cardFloor.controller.visibleCard();
    }

    void generateListProduct(int idx) {
        Timer(const Duration(milliseconds: 500), () {
            idx = idx - 1;
            cardFloor.controller.efFloorName.value[idx].controller.addListener(() {
            });

        });

    }

    /// The function `getCoops()` makes an API call to retrieve a list of coops and
    /// handles the response accordingly.
    void getCoops(){
        Service.push(
            service: ListApi.getCoops,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathListCoops()],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                    if ((body as CoopListResponse).data.isNotEmpty){
                        for (var result in body.data){
                            coops.value.add(result as Coop);
                        }
                    }
                    Map<String, bool> mapList = {};
                    for (var product in body.data) {
                      mapList[product!.name!] = false;
                    }
                    spBuilding.controller.generateItems(mapList);
                    isLoading.value = false;
                    DateTime timeEnd = DateTime.now();
                    GlobalVar.sendRenderTimeMixpanel("Open_create_floor", timeStart, timeEnd);
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

                }, onTokenInvalid: () => GlobalVar.invalidResponse())
        );
    }

    /// The function `getDetailCoop` retrieves detailed information about a selected
    /// coop and updates the `detailCoop` variable, as well as the `rooms` variable
    /// if there are any rooms available.
    ///
    /// Args:
    ///   selectedCoop (Coop): The parameter `selectedCoop` is of type `Coop`, which
    /// represents a selected cooperative.
    void getDetailCoop(Coop selectedCoop){
        Service.push(
            service: ListApi.getDetailCoop,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathDetailCoop(selectedCoop.id!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                    detailCoop = (body as CoopDetailResponse).data!;
                    if ((body).data!.rooms!.isNotEmpty){
                        rooms.value.clear();
                        for (var result in body.data!.rooms!){
                            rooms.value.add(result as Room);
                        }
                        loadData(rooms);
                    }

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

                }, onTokenInvalid: () => GlobalVar.invalidResponse())
        );
    }

    void loadData(Rx<List<Room>> list){
        cardFloor.controller.removeAll();
        if(list.value.isNotEmpty) {
            for (int i = 0; i < list.value.length; i++) {
                cardFloor.controller.addCard();
            }
            for (int i = 0; i < list.value.length; i++) {
                cardFloor.controller.efFloorName.value[i].setInput(
                    list.value[i].name!);
            }
        }else{
            cardFloor.controller.addCard();
        }
    }

    /// The function `addRooms()` performs validation on a payload, sends a request
    /// to modify infrastructure, and handles the response accordingly.
    void addRooms() {
        Get.back();
        List ret = validation();
        if (ret[0]) {
            isLoading.value = true;
            timeStart = DateTime.now();
            try {
                Coop payload = generatePayload();
                Service.push(
                    service: ListApi.modifyInfrastructure,
                    context: context,
                    body: [GlobalVar.auth!.token,
                        GlobalVar.auth!.id,
                        GlobalVar.xAppId,
                        ListApi.pathModifyInfrastructure(detailCoop.id!),
                        Mapper.asJsonString(payload)],
                    listener:ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.offAllNamed(RoutePage.homePage);
                            isLoading.value = false;
                            DateTime timeEnd = DateTime.now();
                            GlobalVar.sendRenderTimeMixpanel("Create_floor", timeStart, timeEnd);
                        },
                        onResponseFail: (code, message, body, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert", (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onResponseError: (exception, stacktrace, id, packet) {
                            isLoading.value = false;
                            Get.snackbar("Alert","Terjadi kesalahan internal", snackPosition: SnackPosition.TOP,
                                duration: const Duration(seconds: 5),
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                        },
                        onTokenInvalid: () => GlobalVar.invalidResponse()
                    ),
                );
            } catch (e,st) {
                Get.snackbar("ERROR", "Error : $e \n Stacktrace->$st",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 5),
                    backgroundColor: const Color(0xFFFF0000),
                    colorText: Colors.white);
            }

        } else {
            if (ret[1] != null) {
                if ((ret[1] as String).isNotEmpty) {
                    Get.snackbar("Pesan", "Duplikat Item Produk, ${ret[1]}",
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 5),
                        backgroundColor: const Color(0xFFFF0000),
                        colorText: Colors.white);
                }
            }
        }
    }

    List validation() {
        List ret = [true, ""];

       if (spBuilding.controller.textSelected.value.isEmpty) {
           spBuilding.controller.showAlert();
            Scrollable.ensureVisible(spBuilding.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        ret = cardFloor.controller.validation();
        return ret;
    }

    Coop generatePayload(){
        List<Room?> rooms = [];
        for (int i = 0; i < cardFloor.controller.itemCount.value; i++) {
            int whichItem = cardFloor.controller.index.value[i];
            rooms.add(Room(name :cardFloor.controller.efFloorName.value[whichItem].getInput(), level: (i + 1)));
        }
        return Coop(coopName: spBuilding.controller.textSelected.value,coopType: detailCoop.coopType, rooms: rooms,farmId: GlobalVar.farm!.id);
    }

}

class RegisterFloorBindings extends Bindings {
    BuildContext context;

    RegisterFloorBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => RegisterFloorController(context: context));
    }
}

