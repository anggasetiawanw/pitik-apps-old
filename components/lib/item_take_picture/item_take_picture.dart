
import 'package:flutter/material.dart';

import '../global_var.dart';
import '../library/engine_library.dart';
import '../library/model_library.dart';
import 'item_take_picture_controller.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class ItemTakePictureCamera extends StatelessWidget{
    final ItemTakePictureCameraController controller;
    const ItemTakePictureCamera({super.key, required this.recordCamera, required this.onOptionTap, required this.controller, required this.index});

    final RecordCamera? recordCamera;
    final Function() onOptionTap;
    final int index;

    @override
    Widget build(BuildContext context) {
        final DateTime takePictureDate = Convert.getDatetime(recordCamera!.createdAt!);
        return Container(
          child: Column(
              children: [
                  SizedBox(
                    height: 16,
                  ),
                  Stack(
                      children: [
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8)
                              ),
                              child: Container(
                                  // margin: EdgeInsets.only(right: 10),// not here
                                  color: GlobalVar.gray,
                                  child:
                                  Image.network(
                                      "${recordCamera!.link!}",
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context, Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                              child: CircularProgressIndicator(
                                                  color: GlobalVar.primaryOrange,
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                      : null,
                                              ),
                                          );
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return Container(
                                              width: double.infinity,
                                              height: 210,
                                              // child: Center(
                                              //     child: CircularProgressIndicator(
                                              //         color: GlobalVar.primaryOrange,
                                              //         // value: loadingProgress.expectedTotalBytes != null
                                              //         //     ? loadingProgress.cumulativeBytesLoaded /
                                              //         //     loadingProgress.expectedTotalBytes!
                                              //         //     : null,
                                              //     ),
                                              //
                                              // ),
                                          );
                                      }
                                  )
                              ),
                          ),
                          GestureDetector(
                              onTap: (){
                                  if(controller.isShow.value){
                                      controller.isShow.value = false;
                                  }else{
                                      controller.isShow.value = true;
                                  }
                                  // _showButtonDialog(context);
                              },
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Container()
                            ),
                          ),
                      ],
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 8, bottom: 16, right: 16, left: 16 ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: GlobalVar.outlineColor),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8)
                          )),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Expanded(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                          Expanded(
                                              child: Container(
                                                  child:  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                          SizedBox(height: 8,),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                  Expanded(
                                                                      child: Text("Kamera - ${recordCamera!.sensor!.room!.roomType!.name!}",
                                                                          style: GlobalVar.blackTextStyle
                                                                              .copyWith(fontWeight: GlobalVar.medium, fontSize: 16, overflow: TextOverflow.clip),
                                                                      ),
                                                                  ),
                                                              ],
                                                          ),
                                                          SizedBox(height: 16,),
                                                          Text("${recordCamera!.sensor!.room!.building!.name!} - ${recordCamera!.sensor!.room!.roomType!.name!}",
                                                              style: GlobalVar.blackTextStyle
                                                                  .copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip),
                                                          ),
                                                          SizedBox(height: 16,),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                  Expanded(
                                                                      child: Text(
                                                                          "Jam Ambil Gambar",
                                                                          style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip,),),
                                                                  ),
                                                                  Expanded(
                                                                      child: Text(
                                                                          "${takePictureDate.day}/${takePictureDate.month}/${takePictureDate.year} ${takePictureDate.hour}:${takePictureDate.minute}",
                                                                          textAlign: TextAlign.end,
                                                                          style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip),),
                                                                  )
                                                              ],
                                                          ),
                                                          SizedBox(height: 8,),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                  Expanded(
                                                                      child: Text(
                                                                          "Temperature",
                                                                          style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip,),),
                                                                  ),
                                                                  Expanded(
                                                                      child: Text(
                                                                          recordCamera!.temperature == null ? " - °C" : "${recordCamera!.temperature!} °C",
                                                                          textAlign: TextAlign.end,
                                                                          style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip),),
                                                                  )
                                                              ],
                                                          ),
                                                          SizedBox(height: 8,),
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                  Expanded(
                                                                      child: Text(
                                                                          "Kelembaban",
                                                                          style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip,),),
                                                                  ),
                                                                  Expanded(
                                                                      child: Text(
                                                                          recordCamera!.humidity == null ? " - %" : "${recordCamera!.humidity!} %",
                                                                          textAlign: TextAlign.end,
                                                                          style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 12, overflow: TextOverflow.clip),),
                                                                  )
                                                              ],
                                                          )
                                                      ],
                                                  )
                                              )
                                          )
                                      ],
                                  ))
                          ],
                      ),
                  )
              ],
          ),
        );
    }
}