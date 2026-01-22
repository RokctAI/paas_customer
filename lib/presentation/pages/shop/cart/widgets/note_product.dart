import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/services.dart';

import 'package:foodyman/presentation/components/components.dart';

class NoteProduct extends StatefulWidget {
  final String? comment;
  final bool isSave;
  final ValueChanged<String> onTap;

  const NoteProduct({
    super.key,
    required this.onTap,
    this.comment,
    this.isSave = true,
  });

  @override
  State<NoteProduct> createState() => _NoteProductState();
}

class _NoteProductState extends State<NoteProduct> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.comment ?? '');
  }

  @override
  void didUpdateWidget(NoteProduct oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.comment != widget.comment) {
      controller.text = widget.comment ?? '';
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleAndIcon(
          title: AppHelpers.getTranslation(TrKeys.productNote),
          paddingHorizontalSize: 0,
        ),
        24.verticalSpace,
        OutlinedBorderTextField(
          readOnly: !widget.isSave,
          textController: controller,
          label: AppHelpers.getTranslation(TrKeys.comment).toUpperCase(),
        ),
        32.verticalSpace,
        if (widget.isSave)
          CustomButton(
            title: AppHelpers.getTranslation(TrKeys.save),
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                widget.onTap(text);
                Navigator.pop(context);
              }
            },
          ),
      ],
    );
  }
}
