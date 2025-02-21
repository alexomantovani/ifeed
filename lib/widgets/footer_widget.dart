import 'dart:math';

import 'package:flutter/material.dart';

import '../core/extensions/context_ext.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({
    super.key,
    required this.icon,
    this.label,
    this.lastIcon = false,
  });

  final Widget icon;
  final String? label;
  final bool lastIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        lastIcon
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  label ?? Random().nextInt(3000).toString(),
                  style: context.textTheme.bodyLarge,
                ),
              ),
      ],
    );
  }
}
