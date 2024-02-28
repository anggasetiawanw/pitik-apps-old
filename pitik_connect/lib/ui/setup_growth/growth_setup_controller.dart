
import 'package:components/button_fill/button_fill.dart';
import 'package:components/button_outline/button_outline.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/expandable/expandable.dart';
import 'package:components/expandable/expandable_controller.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/item_decrease_temp/item_decrease_temperature.dart';
import 'package:engine/request/service.dart';
import 'package:engine/request/transport/interface/response_listener.dart';
import 'package:engine/util/list_api.dart';
import 'package:engine/util/mapper/mapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/controller_data_model.dart';
import 'package:model/device_model.dart';
import 'package:model/error/error.dart';
import 'package:model/growth_day_model.dart';
import 'package:model/response/growth_day_response.dart';
import 'package:model/temperature_reduction_model.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 28/07/23

class GrowthSetupController extends GetxController {
    BuildContext context;

    GrowthSetupController({required this.context});

    ScrollController scrollController = ScrollController();
    Rx<Map<String, bool>> mapList = Rx<Map<String, bool>>({});
    Rx<List<TemperatureReduction>> list = Rx<List<TemperatureReduction>>([]);

    var isLoading = false.obs;
    var isEdit = false.obs;
    late Device device;
    late ControllerData controllerData;

    late ButtonFill bfYesEditGrowthDay;
    late ButtonOutline bfNoEditGrowthDay;
    late ButtonFill bfSaveGrowthDay;
    late ButtonFill bfEditGrowthDay;
    late EditField efTargetTemp = EditField(
        controller: GetXCreator.putEditFieldController(
            "efTargetTemp"),
        label: "Target Suhu Hari Ini",
        hint: "Ketik disini",
        alertText: "Target Suhu Hari Ini harus di isi",
        textUnit: "°C",
        inputType: TextInputType.number,
        maxInput: 4,
        onTyping: (value, control) {
        }
    );
    late EditField efAge = EditField(
        controller: GetXCreator.putEditFieldController(
            "efAge"),
        label: "Umur",
        hint: "Ketik disini",
        alertText: "Umur harus di isi",
        textUnit: "Hari",
        inputType: TextInputType.number,
        maxInput: 3,
        onTyping: (value, control) {
        }
    );
    late EditField efTempDayFirst = EditField(
        controller: GetXCreator.putEditFieldController(
            "efTempDayFirst"),
        label: "Suhu Hari 1",
        hint: "Ketik disini",
        alertText: "Suhu Hari 1 Ini harus di isi",
        textUnit: "°C",
        inputType: TextInputType.number,
        maxInput: 4,
        onTyping: (value, control) {
        }
    );
    late Expandable expandable = Expandable(
        controller: GetXCreator.putAccordionController("expandableReduceTemperature"),
        headerText: "Pengurangan Suhu",
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                itemDecreaseTemperture
            ],
        )
    );

    late ItemDecreaseTemperature itemDecreaseTemperture ;

    @override
    void onInit() {
        super.onInit();
        isLoading.value = true;
        device = Get.arguments[0];
        controllerData = Get.arguments[1];
        bfNoEditGrowthDay = ButtonOutline(
            controller: GetXCreator.putButtonOutlineController("bfNoEditGrowthDay"),
            label: "Tidak",
            onClick: () {
                Get.back();
            },
        );
        bfYesEditGrowthDay = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfYesEditGrowthDay"),
            label: "Ya",
            onClick: () {
                setGrowthDay();
            },
        );
        bfSaveGrowthDay = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfSaveGrowthDay"),
            label: "Simpan",
            onClick: () {
            },
        );
        bfEditGrowthDay = ButtonFill(
            controller: GetXCreator.putButtonFillController("bfEditGrowthDay"),
            label: "Edit",
            onClick: () {
            },
        );
        itemDecreaseTemperture = ItemDecreaseTemperature(controller: GetXCreator.putItemDecreaseController("itemDecreaseTemperature",context));
        getDetailGrowthDay();
    }

    @override
    void onClose() {
        super.onClose();
        Get.delete<ExpandableController>(tag: "expandableReduceTemperature");
    }

    @override
    void onReady() {
        super.onReady();
        WidgetsBinding.instance.addPostFrameCallback((_){
            // getDetailGrowthDay();
        });
        itemDecreaseTemperture = ItemDecreaseTemperature(controller: GetXCreator.putItemDecreaseController("itemDecreaseTemperature",context));
    }

    /// The function `loadData` populates a list and sets input values based on the
    /// provided `GrowthDay` object.
    ///
    /// Args:
    ///   growthDay (GrowthDay): The `growthDay` parameter is an object of type
    /// `GrowthDay`.
    void loadData(GrowthDay growthDay){
        list.value.clear();
        itemDecreaseTemperture.controller.removeAll();
        if(growthDay.temperatureReduction!.isNotEmpty) {
            for (var result in growthDay.temperatureReduction!) {
                list.value.add(result!);
            }
        }
        efAge.setInput("${growthDay.growthDay}");
        efTargetTemp.setInput("${growthDay.requestTemperature}");
        efTempDayFirst.setInput("${growthDay.temperature}");
        if(isEdit.isTrue){
            efAge.controller.enable();
            efTargetTemp.controller.enable();
            efTempDayFirst.controller.enable();
        }else{
            efAge.controller.disable();
            efTargetTemp.controller.disable();
            efTempDayFirst.controller.disable();
        }

        for(int i = 0 ; i < list.value.length - 1 ; i++){
            itemDecreaseTemperture.controller.addCard();
        }
        for(int i = 0 ; i < list.value.length ; i++){
            itemDecreaseTemperture.controller.efDayTotal.value[i].setInput("${list.value[i].day!}");
            itemDecreaseTemperture.controller.efDecreaseTemp.value[i].setInput("${list.value[i].reduction!}");
            if(isEdit.isTrue){
                itemDecreaseTemperture.controller.efDayTotal.value[i].controller.enable();
                itemDecreaseTemperture.controller.efDecreaseTemp.value[i].controller.enable();
            }else{
                itemDecreaseTemperture.controller.efDayTotal.value[i].controller.disable();
                itemDecreaseTemperture.controller.efDecreaseTemp.value[i].controller.disable();
            }

        }
        isLoading.value = false;
    }

    /// The function `getDetailGrowthDay` makes an API call to retrieve growth day
    /// data and handles the response accordingly.
    void getDetailGrowthDay(){
        isLoading.value = true;
        Service.push(
            service: ListApi.getDataGrowthDay,
            context: context,
            body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId!,
                ListApi.pathDeviceData('v2/b2b/iot-devices/smart-controller/coop/', 'growth-day', device.deviceSummary!.coopCodeId!, device.deviceSummary!.deviceId!)],
            listener: ResponseListener(
                onResponseDone: (code, message, body, id, packet){
                    loadData((body as GrowthDayResponse).data!);
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

    /// The function `setGrowthDay()` sends a request to the server to set the
    /// growth day and handles the response accordingly.
    void setGrowthDay() {
        Get.back();
        List ret = validationEdit();
        if (ret[0]) {
            isLoading.value = true;
            try {
                GrowthDay payload = generatePayloadSetGrowthDay();
                Service.push(
                    service: ListApi.setController,
                    context: context,
                    body: [GlobalVar.auth!.token, GlobalVar.auth!.id, GlobalVar.xAppId,
                        ListApi.pathSetController('v2/b2b/iot-devices/smart-controller/coop/', "growth-day",device.deviceSummary!.coopCodeId!),
                        Mapper.asJsonString(payload)],
                    listener:ResponseListener(
                        onResponseDone: (code, message, body, id, packet) {
                            Get.back();
                            isLoading.value = false;
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

        }
    }

    List validationEdit() {
        List ret = [true, ""];

        if (efTargetTemp.getInput().isEmpty) {
            efTargetTemp.controller.showAlert();
            Scrollable.ensureVisible(
                efTargetTemp.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (efAge.getInput().isEmpty) {
            efAge.controller.showAlert();
            Scrollable.ensureVisible(
                efAge.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        if (efTempDayFirst.getInput().isEmpty) {
            efTempDayFirst.controller.showAlert();
            Scrollable.ensureVisible(
                efTempDayFirst.controller.formKey.currentContext!);
            return ret = [false, ""];
        }
        ret = itemDecreaseTemperture.controller.validation();

        return ret;
    }

    GrowthDay generatePayloadSetGrowthDay(){
        List<TemperatureReduction?> temperatureReductions = [];
            for (int i = 0; i < itemDecreaseTemperture.controller.itemCount.value; i++) {
                int whichItem = itemDecreaseTemperture.controller.index.value[i];
                temperatureReductions.add(TemperatureReduction(
                    day: (itemDecreaseTemperture.controller.efDayTotal.value[whichItem].getInputNumber())!.toInt(),
                    reduction: itemDecreaseTemperture.controller.efDecreaseTemp.value[whichItem].getInputNumber(),
                    group: "${whichItem+1}"
                ));
        }
        return GrowthDay(deviceId: controllerData.deviceId, requestTemperature : efTargetTemp.getInputNumber(), growthDay: (efAge.getInputNumber())!.toInt(), temperature: efTempDayFirst.getInputNumber(), temperatureReduction: temperatureReductions);
    }



}

class GrowthSetupBindings extends Bindings {
    BuildContext context;

    GrowthSetupBindings({required this.context});

    @override
    void dependencies() {
        Get.lazyPut(() => GrowthSetupController(context: context));
    }
}

