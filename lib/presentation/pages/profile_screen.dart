import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/constant.dart';
import '../../core/util/navigator.dart';
import '../../core/util/styles.dart';
import '../../firebase/auth/auth_stream.dart';
import '../../injection.dart';
import '../../model/user.dart';
import '../widgets/rate.dart';
import 'my_orders.dart';

class ProfileScreen extends StatefulWidget {
  final BaseUser baseUser;

  const ProfileScreen({super.key, required this.baseUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: mainColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AppDialog(
                      title: tr("are_you_sure"),
                      function: () async {
                        sl<AppNavigator>().popToFrist();
                        await sl<FirebaseAuth>().signOut();
                      }),
                );
              },
              icon: const Icon(
                Icons.logout,
                color: white,
              )),
          IconButton(
              onPressed: () {
                final currentLocale = context.locale;
                final next = currentLocale.languageCode == "ar"
                    ? const Locale("en")
                    : const Locale("ar");

                Future.microtask(() =>
                    sl<FirebaseAuth>().setLanguageCode(next.languageCode));
                context.setLocale(next);
                setState(() {});
              },
              icon: const Icon(
                Icons.language,
                color: white,
              ))
        ],
      ),
      body: StreamBuilder<BaseUser>(
          stream: getUserData(widget.baseUser.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: mainColor,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              backgroundColor: white,
                              radius: 74,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(72),
                                child: Container(
                                  width: 186,
                                  height: 186,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      onError: (m, a) => const NetworkImage(
                                          "https://firebasestorage.googleapis.com/v0/b/techniquick-9b84c.appspot.com/o/1685806616251?alt=media&token=ae453332-5f34-4060-9fa6-ba6f1189da35"),
                                      image: NetworkImage(user.image.isEmpty
                                          ? "https://firebasestorage.googleapis.com/v0/b/techniquick-9b84c.appspot.com/o/1685806616251?alt=media&token=ae453332-5f34-4060-9fa6-ba6f1189da35"
                                          : user.image),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.name,
                                style:
                                    const TextStyle(fontSize: 24, color: white),
                              ),
                              Text(
                                tr(user.type.name),
                                style:
                                    const TextStyle(fontSize: 18, color: white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email,
                            style: TextStyles.bodyText16,
                          ),
                          Text(
                            user.phone,
                            style: TextStyles.bodyText16,
                          ),
                        ]),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (user is Technician) ...[
                          Text(tr("portfolios"), style: TextStyles.bodyText18),
                          if ((user).portfolios.isEmpty)
                            Center(
                              child: Text(tr("new_in_techni_quick"),
                                  style: TextStyles.bodyText20),
                            )
                          else
                            SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: (user).portfolios.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        Material(
                                          elevation: 3,
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          child: CircleAvatar(
                                            backgroundColor: white,
                                            radius: 50,
                                            child: CircleAvatar(
                                                radius: 48,
                                                backgroundColor: white,
                                                backgroundImage: NetworkImage(
                                                    (user)
                                                        .portfolios[index]
                                                        .image)),
                                          ),
                                        ),
                                        Text(
                                            (user)
                                                .portfolios[index]
                                                .orderDescription,
                                            style: TextStyles.bodyText14)
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          const Divider(height: 2),
                          Text(
                            tr("rate"),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            children: (user)
                                .rates
                                .map((rate) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              rate.comment,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ratingBar(
                                              startRate: rate.rate.toDouble()),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                          if (user is Supplier) ...[
                            const SizedBox(height: 8),
                            const Text(
                              "Supplies:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: (user as Supplier)
                                  .supplies
                                  .map((supply) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.shopping_cart,
                                                color: mainColor),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    supply.name,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text("${supply.price} EGP",
                                                      style: const TextStyle(
                                                          fontSize: 18)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
