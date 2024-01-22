// ignore_for_file: must_be_immutable

import 'package:components/button_fill/button_fill.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 21/10/2023

class TransactionSuccessActivity extends StatefulWidget {
    Function() onTapClose;
    Function() onTapHome;
    Function()? onTapShare;
    bool showButtonClose;
    bool showButtonHome;
    bool showButtonShare;
    Image? icon;
    String message;
    String keyPage;

    TransactionSuccessActivity({
        super.key,
        this.showButtonClose = true,
        this.showButtonHome = true,
        this.showButtonShare = false,
        required this.keyPage,
        required this.message,
        required this.onTapClose,
        required this.onTapHome,
        this.onTapShare,
        this.icon
    });

    @override
    State<StatefulWidget> createState() => TransactionSuccessState();
}

class TransactionSuccessState extends State<TransactionSuccessActivity> {

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Container(
                color: Colors.white,
                height: widget.showButtonHome && widget.showButtonClose && widget.showButtonShare ? 280 :
                        (widget.showButtonHome && widget.showButtonClose) || (widget.showButtonHome && widget.showButtonShare) || (widget.showButtonShare && widget.showButtonClose) ?  200 :
                        120,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                    children: [
                        widget.showButtonHome ? ButtonFill(controller: GetXCreator.putButtonFillController("transactionSuccessHome${widget.keyPage}"), label: "Beranda", onClick: () => widget.onTapHome()) : const SizedBox(),
                        widget.showButtonShare ? ButtonFill(
                            controller: GetXCreator.putButtonFillController("transactionSuccessShare${widget.keyPage}"),
                            label: "Bagikan",
                            isHaveIcon: true,
                            imageAsset: SvgPicture.asset('images/share_white_icon.svg'),
                            onClick: () => widget.onTapShare != null ? widget.onTapShare!() :{}
                        ) : const SizedBox(),
                        widget.showButtonClose ? ButtonFill(controller: GetXCreator.putButtonFillController("transactionSuccessClose${widget.keyPage}"), label: "Tutup", onClick: () => widget.onTapClose()) : const SizedBox(),
                    ],
                ),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        widget.icon == null ? Image.asset(
                            "images/check_orange_icon.gif",
                            height: 200,
                            width: 200,
                        ) : widget.icon!,
                        const SizedBox(height: 32),
                        Text(widget.message, style: GlobalVar.subTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.bold, color: GlobalVar.primaryOrange), textAlign: TextAlign.center)
                    ],
                ),
            ),
        );
	}
}