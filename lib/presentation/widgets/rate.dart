import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:techni_quick/core/util/navigator.dart';
import 'package:techni_quick/injection.dart';

import '../../core/constant.dart';
import '../../core/util/styles.dart';

class AppDialog extends StatefulWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.function,
  });

  final String title;
  final Future Function() function;
  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  bool isLoading = false;
  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Column(
        children: [
          Text(widget.title, style: TextStyles.bodyText18),
          const SizedBox(height: 15),
          isLoading
              ? const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () async {
                        toggleIsLoading();
                        widget.function().whenComplete(() => toggleIsLoading());
                      },
                      child: Container(
                        width: 175,
                        height: 35,
                        decoration: BoxDecoration(
                            color: darkerColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            tr("yes"),
                            style: TextStyles.bodyText14.copyWith(color: white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  sl<AppNavigator>().pop();
                },
                child: Container(
                  width: 175,
                  height: 35,
                  decoration: BoxDecoration(
                      color: darkerColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      tr("back"),
                      style: TextStyles.bodyText14.copyWith(color: white),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
