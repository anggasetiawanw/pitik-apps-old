// ignore_for_file: must_be_immutable

import 'package:common_page/library/component_library.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 21/10/2023

class TransactionSuccessActivity extends StatefulWidget {
    Function() onTapClose;
    Function() onTapHome;
    bool showButtonClose;
    bool showButtonHome;
    Image? icon;
    String message;
    String keyPage;

    TransactionSuccessActivity({super.key, this.showButtonClose = true, this.showButtonHome = true, required this.keyPage, required this.message, required this.onTapClose, required this.onTapHome, this.icon});

    @override
    State<StatefulWidget> createState() => TransactionSuccessState();
}

class TransactionSuccessState extends State<TransactionSuccessActivity> {

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                bottomNavigationBar: Container(
                    color: Colors.white,
                    height: widget.showButtonHome && widget.showButtonClose ?  200 : 120,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                        children: [
                            widget.showButtonHome ? ButtonFill(controller: GetXCreator.putButtonFillController("transactionSuccessHome${widget.keyPage}"), label: "Beranda", onClick: () => widget.onTapHome()) : const SizedBox(),
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
            )
        );
	}
}