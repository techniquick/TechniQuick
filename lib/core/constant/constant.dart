import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const Color primaryColor = Color(0xFF10519A);

const Color primaryDarkColor = Color(0xFF0D2137);
const Color accentColor = Color(0xFF00B4D8);
const Color accentColorLight = Color(0xffDAE8F7);

Color fontGraylight = const Color(0xFF989a9e);
List<Color> colorGrediant = const [Color(0xFF1E7879), Color(0xFF043E49)];
// font color
// buttons
ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  shadowColor: Colors.transparent,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  ),
);
ButtonStyle getbuttonStyleRounded(Color color) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(color),
    shadowColor: MaterialStateProperty.all(Colors.transparent),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  );
}

double width(context) {
  return MediaQuery.of(context).size.width;
}

double height(context) {
  return MediaQuery.of(context).size.height;
}

void navigateToRep({
  required var routeName,
  required BuildContext context,
}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => routeName,
    ),
  );
}

Future<void> navigateTo({
  required var routeName,
  required BuildContext context,
}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => routeName,
    ),
  );
}

showToast({required String message, required Color color}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.black,
      fontSize: 16.0);
}

CircularProgressIndicator indicator({Color color = primaryColor}) =>
    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(color));

const TextStyle appBarTextStyle = TextStyle(
    color: primaryDarkColor,
    fontSize: 28,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold);

const TextStyle headLineTextStyle = TextStyle(
    color: primaryDarkColor,
    fontSize: 28,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold);
const TextStyle semieBoldTextStyle = TextStyle(
    color: primaryDarkColor,
    fontSize: 24,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600);
const TextStyle mediumTextStyle = TextStyle(
    color: primaryDarkColor,
    fontSize: 20,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500);
const TextStyle normalTextStyle = TextStyle(
    color: primaryColor,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500);
TextStyle bodyText3 = const TextStyle(
    fontSize: 14,
    fontFamily: "Quicksand",
    color: Colors.black,
    fontWeight: FontWeight.w300);

TextStyle bodyText2 = const TextStyle(
    fontSize: 16,
    fontFamily: "Quicksand",
    color: Colors.black,
    fontWeight: FontWeight.normal);

const kPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
const kPadding2 = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
const kPaddingGridView = EdgeInsets.all(8);
const kPaddingListTile = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
const kPaddingListTile2 = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
const kMargin = EdgeInsets.symmetric(vertical: 2);
const kMargin4 = EdgeInsets.symmetric(vertical: 4);
const kMargin8 = EdgeInsets.symmetric(vertical: 8);
const kMargin12 = EdgeInsets.symmetric(vertical: 12);
const kMargin16 = EdgeInsets.symmetric(vertical: 16);
