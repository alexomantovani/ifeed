import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../core/extensions/context_ext.dart';
import '../core/extensions/string_ext.dart';
import '../core/services/assets.dart';
import '../core/services/styles.dart';
import '../core/utils/constants.dart';
import 'footer_widget.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.title,
    required this.body,
    required this.userId,
    required this.id,
    this.footerWidget = false,
  });

  final String title;
  final String body;
  final int userId;
  final int id;
  final bool footerWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Styles.kPrimaryGrey,
          ),
        ),
      ),
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Styles.kPrimaryWhite),
            ),
            margin: EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              Assets.kIcUser + userId.toString() + Assets.kSvg,
              height: 64.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RepaintBoundary(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Constants.userNames[userId],
                        style: context.textTheme.titleLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset(
                          Assets.kIcVerified,
                          height: 24.0,
                          colorFilter: ColorFilter.mode(
                              Styles.kPrimaryBlue, BlendMode.srcIn),
                        ),
                      ),
                      Text(
                        '@${Constants.userNames[userId].toLowerCase()}',
                        style: context.textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.more_horiz_rounded,
                        color: Styles.kPrimaryGrey,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${title.firstToUpper}:',
                  style: context.textTheme.titleMedium!.copyWith(
                    color: Styles.kPrimaryGreyLight,
                  ),
                ),
                Text(
                  body,
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontSize: 18.0,
                  ),
                ),
                footerWidget
                    ? Container(
                        padding: const EdgeInsets.only(top: 8.0),
                        height: context.height / 20,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: Assets.kIcFooterIcons.length,
                          itemBuilder: (context, index) => FooterWidget(
                            icon: SvgPicture.asset(
                              Assets.kIcFooterIcons[index],
                              height: 24.0,
                              colorFilter: ColorFilter.mode(
                                Styles.kPrimaryGrey,
                                BlendMode.srcIn,
                              ),
                            ),
                            lastIcon: index == Assets.kIcFooterIcons.length - 1,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
