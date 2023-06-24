import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/constant/constant.dart';
import '../../domain/entities/message.dart';
import 'message_input_widget.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({
    Key? key,
    required this.userId,
    required this.child,
    required this.message,
    this.isImage = false,
  }) : super(key: key);
  final String userId;
  final Widget child;
  final Message message;
  final bool isImage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 5.0,
      ),
      constraints: BoxConstraints(maxWidth: width(context) * .75),
      child: Align(
        alignment: message.idFrom == userId
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Column(
          crossAxisAlignment: message.idFrom != userId
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: userId != message.idFrom
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: width(context) * .75),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: !isImage
                          ? Border.all(width: 0.0, color: Colors.transparent)
                          : Border.all(
                              width: 2.0,
                              color: message.idFrom == userId
                                  ? primaryColor
                                  : Colors.transparent),
                      color: message.idFrom == userId
                          ? isImage
                              ? Colors.grey[200]
                              : primaryDarkColor
                          : primaryColor),
                  padding: isImage
                      ? const EdgeInsets.all(0.0)
                      : const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 6.0,
                        ),
                  child: Column(
                    children: [
                      if (message.replayMessage != null)
                        GestureDetector(
                          onTap: () {
                            Scrollable.ensureVisible(context,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOutCirc);
                          },
                          child: ReplayWidget(
                            replayMessage: message.replayMessage!,
                            isView: true,
                          ),
                        ),
                      child,
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                userId == message.idFrom
                    ? Icon(
                        Icons.done_all,
                        color: message.isRead ? primaryColor : Colors.grey[400],
                        size: 20.0,
                      )
                    : Container(),
              ],
            ),
            RichText(
                text: TextSpan(
              style: TextStyle(
                fontFamily: "Almarai",
                fontSize: 13.0,
                color: Colors.grey[500],
              ),
              text: intl.DateFormat.yMd()
                  .add_jm()
                  .format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(message.timestamp),
                  )),
            )),
          ],
        ),
      ),
    );
  }
}

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(primaryColor)),
      ),
    );
  }
}
