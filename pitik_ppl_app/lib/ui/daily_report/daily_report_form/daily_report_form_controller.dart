import 'package:components/button_fill/button_fill.dart';
import 'package:components/edit_field/edit_field.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:components/media_field/media_field.dart';
import 'package:components/multiple_form_field/multiple_form_field.dart';
import 'package:components/spinner_field/spinner_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:model/product_model.dart';

class DailyReportFormController extends GetxController with GetSingleTickerProviderStateMixin{
    BuildContext context;
    DailyReportFormController({required this.context});

    var isLoading = false.obs;
    late TabController tabController = TabController(length: 2, vsync: this);
    EditField efBobot = EditField(
        controller: GetXCreator.putEditFieldController("efBobot"),
        label: "Bobot",
        hint: "Ketik disini",
        alertText: "Bobot harus di isi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, edit) {});
    
    EditField efKematian = EditField(
        controller: GetXCreator.putEditFieldController("efKematian"),
        label: "Kematian",
        hint: "Ketik disini",
        alertText: "Kematian harus di isi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, edit) {});
    
    EditField efCulling = EditField(
        controller: GetXCreator.putEditFieldController("efCulling"),
        label: "Culling",
        hint: "Ketik disini",
        alertText: "Culling harus di isi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, edit) {});

    MediaField mfPhoto = MediaField(
        controller: GetXCreator.putMediaFieldController("mfPhoto"), 
        onMediaResult: (file){}, 
        label: "Upload Kartu Recording", 
        hint: "Upload Kartu Recording", 
        alertText: "Kartu Recording harus dikirim");

    SpinnerField sfMerkPakan = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("sfMerkPakan"), 
        label: "Merk Pakan", hint: "Pilih Salah Satu", 
        alertText: "Merk Pakan Harus Dipilih", items: const {}, 
        onSpinnerSelected: (value){});

    EditField efTotalPakan = EditField(
        controller: GetXCreator.putEditFieldController("efTotalPakan"),
        label: "Total",
        hint: "Ketik disini",
        alertText: "Total harus di isi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, edit) {});
    
    SpinnerField sfJenisOvk = SpinnerField(
        controller: GetXCreator.putSpinnerFieldController("sfJenisOvk"), 
        label: "Jenis OVK", hint: "Pilih Salah Satu", 
        alertText: "Jenis OVK Harus Dipilih", items: const {}, 
        onSpinnerSelected: (value){});

    EditField efTotalOvk = EditField(
        controller: GetXCreator.putEditFieldController("efTotalOvk"),
        label: "Total",
        hint: "Ketik disini",
        alertText: "Total harus di isi ",
        textUnit: "gr",
        maxInput: 20,
        inputType: TextInputType.number,
        onTyping: (value, edit) {});
        
    
    late MultipleFormField mffKonsumsiPakan = MultipleFormField(
        controller: GetXCreator.putMultipleFormFieldController("mffKonsumsiPakan"), 
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
        ), 
        childAdded: (){}, 
        increaseWhenDuplicate: (product){}, 
        labelButtonAdd: "Tambah Pakan", 
        selectedObject: (){}, 
        selectedObjectWhenIncreased: (pragma){},
        initInstance: Product(), 
        validationAdded: (){}, 
        keyData: (){},
        child: Column(
            children: [
                sfMerkPakan,
                efTotalPakan
            ],
        ));
    
    late MultipleFormField mffKonsumsiOVK = MultipleFormField(
        controller: GetXCreator.putMultipleFormFieldController("mffKonsumsiOVK"), 
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            border: Border.fromBorderSide(BorderSide(color: GlobalVar.grayBackground, width: 3))
        ), 
        childAdded: (){}, 
        increaseWhenDuplicate: (product){}, 
        labelButtonAdd: "Tambah OVK", 
        selectedObject: (){}, 
        selectedObjectWhenIncreased: (pragma){},
        initInstance: Product(), 
        validationAdded: (){}, 
        keyData: (){},
        child: Column(
            children: [
                sfJenisOvk,
                efTotalOvk
            ],
        ));

    ButtonFill bfSimpan = ButtonFill(controller: GetXCreator.putButtonFillController("btSimpan"), label: "Simpan", onClick: (){
        
    });

    
    // @override
    // void onInit() {
    //     super.onInit();
    // }
    // @override
    // void onReady() {
    //     super.onReady();
    // }
    // @override
    // void onClose() {
    //     super.onClose();
    // }
}

class DailyReportFormBindings extends Bindings {
    BuildContext context;
    DailyReportFormBindings({required this.context});
    @override
    void dependencies() {
        Get.lazyPut(() => DailyReportFormController(context: context));
    }
}
