class FirebaseRoute {
  static userRoute(String userUid) => 'users/$userUid';
  static sliders() => 'sliders/';
  static orders() => 'orders/';
  static ordersById(String orderid) => 'orders/$orderid';
}
