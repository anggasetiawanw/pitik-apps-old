
import 'package:components/expandable/expandable.dart';
import 'package:components/get_x_creator.dart';
import 'package:components/global_var.dart';
import 'package:flutter/material.dart';

///@author Robertus Mahardhi Kuncoro
///@email <robert.kuncoro@pitik.id>
///@create date 02/08/23

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const String text = "Pitik Digital Indonesia adalah perusahaan berbasis teknologi yang hadir untuk memajukan dan mensejahterakan peternak ayam di Indonesia. Kami percaya bahwa inovasi teknologi yang kami kembangkan dapat meningkatkan produktivitas dan efisiensi operasi peternakan di Indonesia. Selain itu, kami juga membantu para peternak untuk mendapatkan pasokan sapronak yang lebih baik dengan harga kompetitif, memberikan akses permodalan, dan memberikan dukungan penjualan agar pada akhirnya masyarakat Indonesia dapat mengkonsumsi daging ayam dengan kualitas yang lebih baik dan harga yang lebih terjangkau.";
    const String visi = "Meningkatkan kesejahteraan dan memajukan peternak ayam di Indonesia melalui penyediaan teknologi yang unggul dan model bisnis yang transparan dan saling menguntungkan";
    const String misi = "Memberikan dukungan kepada peternak Indonesia untuk seluruh aktivitas produksi ayam, mulai dari penyediaan sapronak berkualitas, mendorong inovasi teknologi produksi, dan juga membantu penjualan hasil panen dengan skema yang lebih transparan dan harga yang lebih kompetitif";
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
          "Tentang Kami",
          style: GlobalVar.whiteTextStyle
              .copyWith(fontSize: 16, fontWeight: GlobalVar.medium),
        ),
      );
    }

    Widget customExpandable(String title, String text){
        return Container(
            margin: const EdgeInsets.only(top: 24),
            child: Expandable(controller: GetXCreator.putAccordionController(title), headerText: title,
            child: RichText(text: TextSpan(children: [
                TextSpan(text: "$text\n", style: GlobalVar.blackTextStyle),
                
            ]))),
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
                        child: Text("Tentang Kami\nPitik Digital Indonesia",style: GlobalVar.primaryTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: Text(text, style: GlobalVar.blackTextStyle.copyWith(fontSize: 12),),
                    ),
                    customExpandable("Visi Kami", visi),
                    customExpandable("Misi Kami", misi),
              ],),
            ),
        ),
    );
  }
}