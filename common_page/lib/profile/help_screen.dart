import 'package:components/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///@author DICKY
///@email <dicky.maulana@pitik.idd>
///@create date 06/10/2023

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        backgroundColor: GlobalVar.primaryOrange,
        centerTitle: true,
        title: Text(
          "Bantuan",
          style: GlobalVar.whiteTextStyle.copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
        ),
      );
    }

    Widget customWidget(double topMargin, String imagepath, String text) {
      return Container(
        margin: EdgeInsets.only(top: topMargin),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(imagepath),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Text(
              text,
              style: GlobalVar.blackTextStyle.copyWith(fontSize: 12),
            ))
          ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Bantuan\nPitik Digital Indonesia",
                  style: GlobalVar.primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              customWidget(27, "images/help_location.svg", "Icon 5 Business Park Blok G5 - G6, Jl. BSD Raya Utama, Sampora, Kec. Cisauk, Kabupaten Tangerang, Banten 15345"),
              customWidget(32, "images/help_call.svg", "(+62) 812 8070 9907"),
              customWidget(16, "images/help_email.svg", "info@pitik.id"),
              customWidget(16, "images/help_ig.svg", "@pitikdigital"),
              customWidget(16, "images/help_in.svg", "Pitik Digital Indonesia")
            ],
          ),
        ),
      ),
    );
  }
}
