import 'package:flutter/material.dart';

class StockStatus extends StatelessWidget {
    const StockStatus({super.key, required this.stockStatus});

    final String? stockStatus;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(                
                color: stockStatus == "DRAFT" ? const Color(0xFFFEEFD2) :
                       stockStatus == "CONFIRMED" ? const Color(0xFFD0F5FD) :
                       const Color(0xFFFDDFD1),
                borderRadius: BorderRadius.circular(6)
            ),
            child: Center(
                child: Text(stockStatus== "DRAFT" ?"Draft" :
                       stockStatus == "CONFIRMED" ? "Terkonfirmasi" :"Dibatalkan",
                style: stockStatus== "DRAFT" ? const TextStyle(color: Color(0xFFF47B20)) :
                       stockStatus == "CONFIRMED" ? const TextStyle(color: Color(0xFF198BDB)) :
                       const TextStyle(color: Color(0xFFDD1E25)),
                )
            ),
        );
    }
}
