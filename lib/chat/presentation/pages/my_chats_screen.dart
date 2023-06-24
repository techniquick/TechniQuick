import 'package:flutter/material.dart';

import '../../../core/constant/constant.dart';

class MyChatsScreen extends StatelessWidget {
  const MyChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this page should come with api store the all user past chats
    return Padding(
        padding: kPadding,
        child: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemBuilder: (ctx, i) => const ChatItem(), itemCount: 4))
        ]));
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: kPadding,
        margin: kMargin,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(color: accentColor, width: 1)),
        child: ListTile(
          onTap: () {},
          trailing: Text("10-10-2021\n09:00 am", style: bodyText3),
          title: Text(
            "Techer name",
            style: bodyText2,
          ),
          subtitle: Text(
            "message message",
            style: bodyText3,
          ),
          leading: Container(
              padding: kPaddingListTile,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                // border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.fill,
                  ))),
        ));
  }
}
