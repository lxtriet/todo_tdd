import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

mixin BottomSheetMixin {
  Future<T?> showCustomBottomSheet<T>(BuildContext context, Widget child) async {
    final result = await showBarModalBottomSheet<T?>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (context) => child);
    return result;
  }
}
