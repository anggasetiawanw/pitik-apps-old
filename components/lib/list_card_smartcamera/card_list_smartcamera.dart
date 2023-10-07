
// ignore_for_file: slash_for_doc_comments, depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:model/device_model.dart';

import '../global_var.dart';

/**
 * @author DICKY
 * @email <dicky.maulana@pitik.id>
 * @create date 14/09/2023
 */

class CardListSmartCamera extends StatelessWidget{
    const CardListSmartCamera({super.key, required this.device, required this.imagesPath, required this.onTap});

    final Device? device;
    final String? imagesPath;
    final Function() onTap;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onTap,
            child: Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: GlobalVar.outlineColor),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                            color:Color(0xFFFFF6ED),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4),
                                                topRight: Radius.circular(4),
                                                bottomRight: Radius.circular(4),
                                                bottomLeft: Radius.circular(4)
                                            )
                                        ),
                                        child: Center(child: SvgPicture.asset(imagesPath!)),
                                    ),
                                    Expanded(
                                        child: Container(
                                            margin: const EdgeInsets.only(left: 12),
                                            child:  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(
                                                        device!.deviceName!,
                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.clip),
                                                    ),
                                                    Container(
                                                        margin: const EdgeInsets.only(top: 6),
                                                        child:
                                                        Row(
                                                            children: [
                                                                Text(
                                                                    "Total Kamera : ",
                                                                    style: GlobalVar.greyTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 10)
                                                                ),
                                                                Text(
                                                                    "${device!.sensorCount!}",
                                                                    style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 10)
                                                                )
                                                            ]
                                                        )
                                                    )
                                                ]
                                            )
                                        )
                                    )
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}