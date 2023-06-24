import 'package:flutter/material.dart';

class EmptyChatMessage extends StatelessWidget {
  final String peerName;

  const EmptyChatMessage({Key? key, required this.peerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/images/messages.jpg',
                height: MediaQuery.of(context).size.height * 0.28,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
