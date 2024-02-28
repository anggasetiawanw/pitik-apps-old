import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:global_variable/global_variable.dart';

class SearchField extends StatelessWidget {
  final Function(String) onChanged;
  const SearchField({required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: AppColors.primaryOrange,
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 0,
        toolbarHeight: 95,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8))),
        title: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Customer',
                      style: AppTextStyle.whiteTextStyle.copyWith(fontSize: 16, fontWeight: AppTextStyle.medium),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 42,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    cursorColor: AppColors.primaryOrange,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFF9ED),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                      hintText: 'Cari Data',
                      hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset('images/search_icon.svg'),
                      ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(width: 1.0, color: AppColors.primaryOrange)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
