import 'package:common_page/library/dao_impl_library.dart';
import 'package:components/global_var.dart';
import 'package:components/library/engine_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/coop_model.dart';
import 'package:model/response/sapronak_response.dart';
import 'package:model/sapronak_model.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 07/10/2023

class SapronakController extends GetxController {
    BuildContext context;
    SapronakController({required this.context});

    var isLoading = false.obs;

    Rx<Column> columnDateFeedWidget = (const Column()).obs;
    Rx<Column> columnTypeFeedWidget = (const Column()).obs;
    Rx<Column> columnQuantityFeedWidget = (const Column()).obs;

    Rx<Column> columnDateOvkWidget = (const Column()).obs;
    Rx<Column> columnTypeOvkWidget = (const Column()).obs;
    Rx<Column> columnQuantityOvkWidget = (const Column()).obs;

    RxList<Sapronak?> feedData = <Sapronak?>[].obs;
    RxList<Sapronak?> ovkData = <Sapronak?>[].obs;

    void generateData(Coop coop) {
        isLoading.value = true;
        AuthImpl().get().then((auth) {
           if (auth != null) {
               int apiDoneRunning = 0;

               // REQUEST FOR FEED
               Service.push(
                   apiKey: 'productReportApi',
                   service: ListApi.getSapronak,
                   context: context,
                   body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetSapronakByType(coop.farmingCycleId!, 'feed')],
                   listener: ResponseListener(
                       onResponseDone: (code, message, body, id, packet) {
                           feedData.value = (body as SapronakResponse).data;
                           feedData.refresh();

                           apiDoneRunning++;
                           if (apiDoneRunning == 2) {
                               isLoading.value = false;
                           }
                       },
                       onResponseFail: (code, message, body, id, packet) {
                           apiDoneRunning++;
                           if (apiDoneRunning == 2) {
                               isLoading.value = false;
                           }
                       },
                       onResponseError: (exception, stacktrace, id, packet) {
                           apiDoneRunning++;
                           if (apiDoneRunning == 2) {
                               isLoading.value = false;
                           }
                       },
                       onTokenInvalid: () => GlobalVar.invalidResponse()
                   )
               );

               // REQUEST FOR OVK
               Service.push(
                   apiKey: 'productReportApi',
                   service: ListApi.getSapronak,
                   context: context,
                   body: ['Bearer ${auth.token}', auth.id, ListApi.pathGetSapronakByType(coop.farmingCycleId!, 'ovk')],
                   listener: ResponseListener(
                       onResponseDone: (code, message, body, id, packet) {
                           ovkData.value = (body as SapronakResponse).data;
                           ovkData.refresh();

                           apiDoneRunning++;
                           if (apiDoneRunning == 2) {
                               isLoading.value = false;
                           }
                       },
                       onResponseFail: (code, message, body, id, packet) {
                           apiDoneRunning++;
                           if (apiDoneRunning == 2) {
                               isLoading.value = false;
                           }
                       },
                       onResponseError: (exception, stacktrace, id, packet) {
                           apiDoneRunning++;
                           if (apiDoneRunning == 2) {
                               isLoading.value = false;
                           }
                       },
                       onTokenInvalid: () => GlobalVar.invalidResponse()
                   )
               );
           } else {
               GlobalVar.invalidResponse();
           }
        });
    }
}

class SapronakBinding extends Bindings {
    BuildContext context;
    SapronakBinding({required this.context});

    @override
    void dependencies() {
        Get.lazyPut<SapronakController>(() => SapronakController(context: context));
    }
}