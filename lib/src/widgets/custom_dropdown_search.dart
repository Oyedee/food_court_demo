import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:food_court_demo/src/constants/app_colors.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final String title;
  final bool isRequired;
  final List<T> items;
  final String hintText;
  final T? selectedItem;
  final bool Function(T, T)? compareFn;
  final Widget Function(BuildContext, T, bool)? itemBuilder;
  final void Function(T?)? onChanged;
  final String Function(T)? itemAsString;
  final Color? borderColor;
  final Future<List<T>> Function(String)? asyncItems;
  final bool showSearchBox;
  const CustomDropdownSearch(
      {Key? key,
      required this.title,
      required this.items,
      required this.hintText,
      this.selectedItem,
      this.compareFn,
      this.itemBuilder,
      this.onChanged,
      this.itemAsString,
      required this.isRequired,
      this.borderColor,
      this.asyncItems,
      this.showSearchBox = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownSearch<T>(
        compareFn: compareFn,
        asyncItems: asyncItems,
        popupProps: PopupProps.menu(
          itemBuilder: itemBuilder,
          showSearchBox: showSearchBox,
          showSelectedItems: true,
          searchFieldProps: const TextFieldProps(
              padding: EdgeInsets.only(left: 10, right: 10),
              cursorColor: AppColors.rainBlueLight,
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.white,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Search',
                suffixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: AppColors.rainBlueLight,
                ),
              )),
          loadingBuilder: (context, value) => const Center(
            child: CircularProgressIndicator(color: AppColors.accentColor),
          ),
        ),
        items: items,
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: const TextStyle(
            color: AppColors.rainBlueLight,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.rainBlueLight,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: borderColor ?? AppColors.rainBlueLight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: borderColor ?? AppColors.rainBlueLight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: borderColor ?? AppColors.rainBlueLight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        onChanged: onChanged,
        itemAsString: itemAsString,
        selectedItem: selectedItem,
      ),
    );
  }
}
