import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/assets.dart';
import '../core/services/styles.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Styles.kPrimaryBlack,
      toolbarHeight: kTextTabBarHeight * 2,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Row(
              children: [
                RepaintBoundary(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Styles.kPrimaryWhite,
                      ),
                    ),
                    child: SvgPicture.asset(
                      Assets.kIcUser +
                          (Random().nextInt(10)).toString() +
                          Assets.kSvg,
                      height: 32.0,
                    ),
                  ),
                ),
                const SizedBox(width: 100.0),
                Text(
                  'ifeed',
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),
          ),
          TabBar(
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            dividerHeight: 0,
            labelColor: Styles.kPrimaryWhite,
            unselectedLabelColor: Styles.kPrimaryGrey,
            labelStyle: context.textTheme.titleMedium,
            unselectedLabelStyle: context.textTheme.bodyLarge,
            tabs: [
              Tab(text: "For you"),
              Tab(text: "Following"),
              Tab(text: "Subscribed"),
            ],
          ),
        ],
      ),
      shape: Border(
        bottom: BorderSide(
          color: Styles.kPrimaryGrey,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 2.0);
}
