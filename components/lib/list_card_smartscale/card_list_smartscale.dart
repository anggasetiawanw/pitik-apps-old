
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../global_var.dart';
import '../library/model_library.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class CardListSmartScale extends StatelessWidget {
    const CardListSmartScale({super.key, required this.device, required this.imagesPath, required this.onTap});

    final Device? device;
    final String? imagesPath;
    final Function() onTap;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(onTap: onTap,
            child: Container(
                margin: EdgeInsets.only(top: 16 ),
                padding: EdgeInsets.all(12),
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
                                        decoration: BoxDecoration(
                                            color:Color(0xFFFFF6ED),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(4),
                                                topRight: Radius.circular(4),
                                                bottomRight: Radius.circular(4),
                                                bottomLeft: Radius.circular(4))),
                                        child: Center(child: SvgPicture.asset(imagesPath!)),
                                    ),
                                    Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 12),
                                            child:  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Text(
                                                        "Smart Scale",
                                                        style: GlobalVar.blackTextStyle.copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.clip),
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