
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class TermScreen extends StatelessWidget {
  const TermScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget appBar() {
      return AppBar(
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Text(
          "Syarat & Ketentuan",
          style: GlobalVar.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
        ),
      );
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: appBar(),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(children: [
                    Center(
                        child: Text("Syarat & Ketentuan\nPitik Digital Indonesia",style: GlobalVar.primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top:4),
                      child: Center(child: 
                      Text("Terakhir di perbarui 20 Des 2022 - 10:00", style: GlobalVar.greyTextStyle.copyWith(fontSize: 12),),),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: Html(data: GlobalVar.htmlTermsConditionsIndonesia),
                    )
              ],),
            ),
        ),
    );
  }
}