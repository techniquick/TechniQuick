import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../core/constant/constant.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/order_user.dart';
import '../../domain/usecases/mark_peer_messages_as_read.dart';
import '../provider/chat_provider.dart';
import 'empty_chat_message.dart';
import 'message_card_widget.dart';
import 'open_image_withloading_widget.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    Key? key,
    required this.chatGroupId,
    required this.user2,
    required this.userId,
    required this.scaffoldKey,
  }) : super(key: key);
  final String chatGroupId;
  final ChatUser user2;
  final String userId;

  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  void onSwipeMessage(Message message) {}
  @override
  Widget build(BuildContext context) {
    final listScrollController =
        Provider.of<ChatProvider>(context).listScrollController;
    final isSendingImages = Provider.of<ChatProvider>(context).isSendingImages;
    return StreamBuilder<List<Message>>(
      stream: Provider.of<ChatProvider>(context)
          .fgetAllMessages(chatGroupId: widget.chatGroupId),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor)),
          );
        }
        if (snapshot.data!.isEmpty) {
          return EmptyChatMessage(
            peerName: widget.user2.username,
          );
        }
        return ListView.builder(
          controller: listScrollController,
          reverse: true,
          itemCount: isSendingImages
              ? snapshot.data!.length + 1
              : snapshot.data!.length,
          itemBuilder: (ctx, index) {
            if (index == 0 && isSendingImages) {
              return _buildDummyMessage();
            }
            final lastMessage = snapshot.data!.first;
            Provider.of<ChatProvider>(context, listen: false)
                .fmarkPeerMessagesAsRead(
                    params: MarkPeerMessagesAsReadParams(
                      lastMessage: lastMessage,
                      chatGroupId: widget.chatGroupId,
                      userId2: widget.user2.id.toString(),
                    ),
                    scaffoldKey: widget.scaffoldKey);
            final message = snapshot.data![isSendingImages ? index - 1 : index];
            return Container(
              padding: const EdgeInsets.all(5.0),
              child: MessageWidget(
                message: message,
                onSwipeMessage: (message) {
                  Provider.of<ChatProvider>(context, listen: false)
                      .replayToMessage(message);
                },
                userId: widget.userId,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDummyMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 5.0,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.cached,
              color: Colors.grey[400],
              size: 20.0,
            ),
            const SizedBox(
              width: 5.0,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).cardColor,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {Key? key,
      required this.message,
      required this.userId,
      required this.onSwipeMessage})
      : super(key: key);
  final Message message;
  final String userId;
  final ValueChanged<Message> onSwipeMessage;
  bool _checkForArabicLetter(String text) {
    final arabicRegex = RegExp(r'[ء-ي-_ \.]*$');
    final englishRegex = RegExp(r'[a-zA-Z ]');
    return text.contains(arabicRegex) && !text.startsWith(englishRegex);
  }

  @override
  Widget build(BuildContext context) {
    switch (message.type) {
      case MessageType.text:
        return SwipeTo(
            onLeftSwipe: () => onSwipeMessage(message),
            onRightSwipe: () => onSwipeMessage(message),
            child: MessageCard(
              userId: userId,
              message: message,
              child: Container(
                alignment: message.replayMessage != null
                    ? AlignmentDirectional.centerStart
                    : null,
                child: Text(
                  message.content,
                  textAlign: _checkForArabicLetter(message.content)
                      ? TextAlign.right
                      : TextAlign.left,
                  textDirection: _checkForArabicLetter(message.content)
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ));
      case MessageType.image:
        return SwipeTo(
            onLeftSwipe: () => onSwipeMessage(message),
            child: MessageCard(
              userId: userId,
              isImage: true,
              message: message,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: ImageWithLoading(imageUrl: message.content),
              ),
            ));
    }
  }
}
