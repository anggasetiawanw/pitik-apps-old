
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'global_var.dart';

/**
 *@author DICKY
 *@email <dicky.maulana@pitik.idd>
 *@create date 11/09/2023
 */

class MenuBottomSheet extends StatelessWidget{
    const MenuBottomSheet({super.key, required this.title, required this.subTitle, required this.imagesPath, this.enable = true });

    final String? title;
    final String? subTitle;
    final String? imagesPath;
    final bool? enable;


    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(top: 12, left: 16, right: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: enable == true ? Color(0xFFFFFFFF) : Color(0xFFF0F0F0),
                border: Border.all(width: 1, color: GlobalVar.outlineColor),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: enable == true ? Color(0xFFFFF6ED) : GlobalVar.gray,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                                bottomLeft: Radius.circular(4))),
                        child: Center(
                            child: SvgPicture.asset(imagesPath!),
                        ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(
                                  title!,
                                  style: GlobalVar.blackTextStyle
                                      .copyWith(fontWeight: GlobalVar.medium, fontSize: 17, overflow: TextOverflow.clip),
                              ),
                              Text(
                                  subTitle!,
                                  style: GlobalVar.greyTextStyle
                                      .copyWith(fontWeight: GlobalVar.medium, fontSize: 10),
                              )
                          ],
                      ),
                    ),
                ],
            ),
        );
    }
}