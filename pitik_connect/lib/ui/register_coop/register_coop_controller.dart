// ignore_for_file: constant_identifier_names

import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/card_floor/card_floor.dart';
import 'package:components/card_floor/card_floor_controller.dart';
import 'package:components/edit_field/edit_field.dart';
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
import 'package:model/room_model.dart';

import '../../route.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 13/07/23

class RegisterCoopController extends GetxController {
  BuildContext context;

  RegisterCoopController({required this.context});
  static const String CREATE_COOP = 'createCoop';
  static const String MODIFY_COOP = 'modifyCoop';
  static const String MODIFY_FLOOR = 'modifyFloor';
  ScrollController scrollController = ScrollController();
  Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});

  var isLoading = false.obs;
  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  late ButtonFill bfYesRegBuilding;
  late ButtonOutline boNoRegBuilding;
  late EditField efBuildingName =
      EditField(controller: GetXCreator.putEditFieldController('efBuildingName'), label: 'Kandang', hint: 'Ketik Disini', alertText: 'Nama Kandang', textUnit: '', inputType: TextInputType.text, maxInput: 50, onTyping: (value, control) {});

  late EditField efFloorName = EditField(
      controller: GetXCreator.putEditFieldController('efFloorName'), label: 'Nama Lantai', hint: 'Ketik Disini', alertText: 'Nama Lantai Tidak Boleh kosong', textUnit: '', inputType: TextInputType.text, maxInput: 50, onTyping: (value, control) {});
  late SpinnerField spBuildingType;
  late SpinnerField spCoopStatus;

  late CardFloor cardFloor;
  Rx<Coop> coop = Coop().obs;
  Rx<String> modifyType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    timeStart = DateTime.now();
    final Map<String, bool> mapList = {'Open House': false, 'Semi House': false, 'Closed House': false};
    final Map<String, bool> mapListStatus = {'Aktif': false, 'Non Aktif': false};

    spBuildingType = SpinnerField(controller: GetXCreator.putSpinnerFieldController('spBuildingType'), label: 'Jenis Kandang', hint: 'Pilih Salah Satu', alertText: 'Jenis Kandang harus dipilih!', items: mapList, onSpinnerSelected: (value) {});
    spBuildingType.controller.generateItems(mapList);

    spCoopStatus = SpinnerField(controller: GetXCreator.putSpinnerFieldController('spCoopStatus'), label: 'Status', hint: 'Pilih Salah Satu', alertText: 'Status harus dipilih !', items: mapListStatus, onSpinnerSelected: (value) {});
    spCoopStatus.controller.generateItems(mapListStatus);
    spCoopStatus.controller.invisibleSpinner();
    cardFloor = CardFloor(controller: GetXCreator.putCardFloorController('cardFloorController', context));
    boNoRegBuilding = ButtonOutline(
      controller: GetXCreator.putButtonOutlineController('boNoRegBuilding'),
      label: 'Tidak',
      onClick: () {
        Get.back();
      },
    );
    bfYesRegBuilding = ButtonFill(
      controller: GetXCreator.putButtonFillController('bfYesRegBuilding'),
      label: 'Ya',
      onClick: () {
        if (modifyType.value == MODIFY_COOP || modifyType.value == MODIFY_FLOOR) {
          modifyInfrastructure();
        } else {
          GlobalVar.track('Click_simpan_kandang');
          timeStart = DateTime.now();
          createCoops();
        }
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    Get.find<CardFloorController>(tag: 'cardFloorController').numberList.listen((p0) {});
    cardFloor.controller.visibleCard();

    final Map<String, bool> mapList = {'Open House': false, 'Semi House': false, 'Closed House': false};
    spBuildingType.controller.generateItems(mapList);

    if (Get.arguments != null) {
      modifyType.value = Get.arguments[0];
      if (modifyType.value == MODIFY_COOP) {
        coop.value = Get.arguments[1];
        cardFloor.controller.invisibleCard();
        spCoopStatus.controller.visibleSpinner();
        efBuildingName.setInput(coop.value.coopName!);
        efFloorName.controller.invisibleField();
        spCoopStatus.controller.textSelected(coop.value.coopStatus == 'active' ? 'Aktif' : 'Non Aktif');
        spBuildingType.controller.textSelected(coop.value.coopType);
        final DateTime timeEnd = DateTime.now();
        GlobalVar.sendRenderTimeMixpanel('Open_form_edit_coop', timeStart, timeEnd);
      } else if (modifyType.value == MODIFY_FLOOR) {
        coop.value = Get.arguments[1];
        cardFloor.controller.invisibleCard();
        spCoopStatus.controller.visibleSpinner();
        efFloorName.setInput(coop.value.room!.name!);
        efBuildingName.controller.invisibleField();
        spBuildingType.controller.invisibleSpinner();
        spCoopStatus.controller.textSelected(coop.value.room!.status == 'active' ? 'Aktif' : 'Non Aktif');
        final DateTime timeEnd = DateTime.now();
        GlobalVar.sendRenderTimeMixpanel('Open_form_edit_floor', timeStart, timeEnd);
      } else {
        efFloorName.controller.invisibleField();
        final DateTime timeEnd = DateTime.now();
        GlobalVar.sendRenderTimeMixpanel('Open_form_create_coop', timeStart, timeEnd);
      }
    }
  }

  /// The function `createCoops()` is responsible for creating coops and handling
  /// the response.
  void createCoops() {
    Get.back();
    final List ret = validation();
    if (ret[0]) {
      timeStart = DateTime.now();
      isLoading.value = true;
      try {
        final Coop payload = generatePayloadCreateCoop();
        Service.push(
          service: ListApi.createCoopInfrastructure,
          context: context,
          body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId, Mapper.asJsonString(payload)],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                Get.offAllNamed(RoutePage.homePage);
                final DateTime timeEnd = DateTime.now();
                GlobalVar.sendRenderTimeMixpanel('Create_coop', timeStart, timeEnd);
                isLoading.value = false;
              },
              onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                final DateTime timeEnd = DateTime.now();
                GlobalVar.sendRenderTimeMixpanel('Create_coop_failed', timeStart, timeEnd);
                Get.snackbar('Alert', (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              },
              onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                final DateTime timeEnd = DateTime.now();
                GlobalVar.sendRenderTimeMixpanel('Create_coop_failed', timeStart, timeEnd);
                Get.snackbar('Alert', 'Terjadi kesalahan internal', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              },
              onTokenInvalid: () => GlobalVar.invalidResponse()),
        );
      } catch (e, st) {
        Get.snackbar('ERROR', 'Error : $e \n Stacktrace->$st', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5), backgroundColor: const Color(0xFFFF0000), colorText: Colors.white);
      }
    }
  }

  /// The function `modifyInfrastructure` modifies the infrastructure based on
  /// certain conditions and handles different response scenarios.
  void modifyInfrastructure() {
    Get.back();
    final List ret = validation();
    if (ret[0]) {
      timeStart = DateTime.now();
      isLoading.value = true;
      try {
        final Coop payload = modifyType.value == MODIFY_COOP ? generatePayloadModifyCoop() : generatePayloadModifyFloor();
        Service.push(
          service: ListApi.modifyInfrastructure,
          context: context,
          body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId, ListApi.pathDetailRoom(coop.value.coopId!, coop.value.room!.id!), Mapper.asJsonString(payload)],
          listener: ResponseListener(
              onResponseDone: (code, message, body, id, packet) {
                final DateTime timeEnd = DateTime.now();
                GlobalVar.sendRenderTimeMixpanel(modifyType.value == MODIFY_COOP ? 'Edit_coop' : 'Edit_floor', timeStart, timeEnd);
                Get.back();
                isLoading.value = false;
              },
              onResponseFail: (code, message, body, id, packet) {
                isLoading.value = false;
                final DateTime timeEnd = DateTime.now();
                GlobalVar.sendRenderTimeMixpanel(modifyType.value == MODIFY_COOP ? 'Edit_coop_failed' : 'Edit_floor_faild', timeStart, timeEnd);
                Get.snackbar('Alert', (body as ErrorResponse).error!.message!, snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              },
              onResponseError: (exception, stacktrace, id, packet) {
                isLoading.value = false;
                final DateTime timeEnd = DateTime.now();
                GlobalVar.sendRenderTimeMixpanel(modifyType.value == MODIFY_COOP ? 'Edit_coop_failed' : 'Edit_floor_faild', timeStart, timeEnd);
                Get.snackbar('Alert', 'Terjadi kesalahan internal', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 5), backgroundColor: Colors.red, colorText: Colors.white);
              },
              onTokenInvalid: () => GlobalVar.invalidResponse()),
        );
      } catch (e, st) {
        Get.snackbar('ERROR', 'Error : $e \n Stacktrace->$st', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5), backgroundColor: const Color(0xFFFF0000), colorText: Colors.white);
      }
    }
  }

  List validation() {
    List ret = [true, ''];
    if (modifyType.value == MODIFY_COOP) {
      if (efBuildingName.getInput().isEmpty) {
        efBuildingName.controller.showAlert();
        Scrollable.ensureVisible(efBuildingName.controller.formKey.currentContext!);
        return ret = [false, ''];
      } else if (spBuildingType.controller.textSelected.value.isEmpty) {
        spBuildingType.controller.showAlert();
        Scrollable.ensureVisible(spBuildingType.controller.formKey.currentContext!);
        return ret = [false, ''];
      } else if (spCoopStatus.controller.textSelected.value.isEmpty) {
        spCoopStatus.controller.showAlert();
        Scrollable.ensureVisible(spCoopStatus.controller.formKey.currentContext!);
        return ret = [false, ''];
      }
    } else if (modifyType.value == MODIFY_FLOOR) {
      if (efFloorName.getInput().isEmpty) {
        efFloorName.controller.showAlert();
        Scrollable.ensureVisible(efFloorName.controller.formKey.currentContext!);
        return ret = [false, ''];
      } else if (spCoopStatus.controller.textSelected.value.isEmpty) {
        spCoopStatus.controller.showAlert();
        Scrollable.ensureVisible(spCoopStatus.controller.formKey.currentContext!);
        return ret = [false, ''];
      }
    } else {
      if (efBuildingName.getInput().isEmpty) {
        efBuildingName.controller.showAlert();
        Scrollable.ensureVisible(efBuildingName.controller.formKey.currentContext!);
        return ret = [false, ''];
      } else if (spBuildingType.controller.textSelected.value.isEmpty) {
        spBuildingType.controller.showAlert();
        Scrollable.ensureVisible(spBuildingType.controller.formKey.currentContext!);
        return ret = [false, ''];
      }
      ret = cardFloor.controller.validation();
    }
    return ret;
  }

  Coop generatePayloadCreateCoop() {
    final List<Room?> rooms = [];
    for (int i = 0; i < cardFloor.controller.itemCount.value; i++) {
      final int whichItem = cardFloor.controller.index.value[i];
      rooms.add(Room(name: cardFloor.controller.efFloorName.value[whichItem].getInput(), level: i + 1));
    }
    return Coop(coopName: efBuildingName.getInput(), coopType: spBuildingType.controller.textSelected.value, rooms: rooms, farmId: GlobalVar.farm!.id);
  }

  Coop generatePayloadModifyCoop() {
    return Coop(coopName: efBuildingName.getInput(), coopStatus: spCoopStatus.controller.textSelected.value == 'Aktif' ? 'active' : 'inactive', coopType: spBuildingType.controller.textSelected.value, room: coop.value.room);
  }

  Coop generatePayloadModifyFloor() {
    return Coop(
        coopName: coop.value.coopName,
        coopStatus: coop.value.coopStatus,
        coopType: coop.value.coopType,
        room: Room(name: efFloorName.getInput(), level: coop.value.room!.level!, status: spCoopStatus.controller.textSelected.value == 'Aktif' ? 'active' : 'inactive'));
  }
}

class RegisterCoopBindings extends Bindings {
  BuildContext context;

  RegisterCoopBindings({required this.context});

  @override
  void dependencies() {
    Get.lazyPut(() => RegisterCoopController(context: context));
  }
}
