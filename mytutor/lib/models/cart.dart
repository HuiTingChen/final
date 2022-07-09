class Cart {
  String? cartId;
  String? subjectName;
  String? subjectSessions;
  String? subjectPrice;
  String? subjectId;
  String? cartQty;

  Cart(
      {this.cartId,
      this.subjectName,
      this.subjectSessions,
      this.subjectPrice,
      this.subjectId,
      this.cartQty});

  Cart.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    subjectName = json['subject_name'];
    subjectSessions = json['subject_sessions'];
    subjectPrice = json['subject_price'];
    subjectId = json['subject_id'];
    cartQty = json['cart_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['subject_name'] = subjectName;
    data['subject_sessions'] = subjectSessions;
    data['subject_price'] = subjectPrice;
    data['subject_id'] = subjectId;
    data['cart_qty'] = cartQty;
    return data;
  }
}