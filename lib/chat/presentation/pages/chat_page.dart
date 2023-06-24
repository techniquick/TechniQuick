import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../core/constant.dart';
import '../../../core/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/order_user.dart';
import '../../domain/usecases/set_chatting_Id_for_users.dart';
import '../provider/chat_provider.dart';
import '../widgets/message_input_widget.dart';
import '../widgets/message_list_widget.dart';

class ChatPage extends StatefulWidget {
  static const String routeName = '/chat-page';
  final ChatUser user2;
  final ChatUser user1;

  const ChatPage({Key? key, required this.user2, required this.user1})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final String chatGroupId;

  late final String userId;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    // _focusNode.addListener(_onFocusChanged);
    _readUserData();
    userId = widget.user1.id.toString();
    // _setChattingWithValue();
    Future.microtask(() => Provider.of<ChatProvider>(context, listen: false)
        .fsetChattingIdForUsers(
            params: SetChattingIdForUsersParams(
              user1: widget.user1,
              user2: widget.user2,
              userId1: widget.user1.id.toString(),
              userId2: widget.user2.id.toString(),
            ),
            scaffoldKey: scaffoldKey));
  }

  _readUserData() {
    if (widget.user1.id.hashCode > widget.user2.id.hashCode) {
      chatGroupId = '${widget.user1.id}-${widget.user2.id}';
    } else {
      chatGroupId = '${widget.user2.id}-${widget.user1.id}';
    }
  }

  // widget and ui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: mainColor,
          centerTitle: true,
          title: Text(
            widget.user2.username.toString(),
            style: TextStyles.bodyText18.copyWith(color: white),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final Uri phoneUri =
                      Uri(scheme: "tel", path: widget.user2.phone);
                  try {
                    if (await canLaunchUrl(phoneUri)) {
                      await launchUrl(phoneUri);
                    }
                  } catch (error) {
                    throw ("Cannot dial");
                  }
                },
                icon: const Icon(
                  Icons.call,
                  color: Colors.white,
                ))
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: MessagesList(
                scaffoldKey: scaffoldKey,
                userId: userId,
                chatGroupId: chatGroupId,
                user2: widget.user2,
              ),
            ),
            MessageInput(
              onCancelReplay: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .cancelReplay();
              },
              scaffoldKey: scaffoldKey,
              chatGroupId: chatGroupId,
              user1: widget.user1,
              user2: widget.user2,
            ),
          ],
        ));
  }
}
