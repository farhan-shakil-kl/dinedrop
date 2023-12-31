import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/screens/CartPage.dart';

class Request {
  String address;
  Map foodItems;
  String name;
  String userId;
  String paymentMethod;
  double latitude;
  double longitude;
  // String status;
  Map<String, dynamic> status;
  String paymentId;
  String total;

  Request(
      {this.address,
      this.foodItems,
      this.name,
      this.userId,
      this.status,
      this.total,
      this.paymentMethod,
      this.paymentId,
      this.latitude,
      this.longitude});

  Map toMap(Request request) {
    var data = Map<String, dynamic>();
    data['address'] = request.address;
    data['foodItems'] = request.foodItems;
    data['name'] = request.name;
    data['userId'] = request.userId;
    data['status'] = request.status;
    data['total'] = request.total;
    data['paymentMethod'] = request.paymentMethod;
    data['latitude'] = request.latitude;
    data['longitude'] = request.longitude;
    data['paymentId'] = request.paymentId;
    return data;
  }

  Request.fromMap(Map<dynamic, dynamic> mapData) {
    this.address = mapData['address'];
    this.foodItems = mapData['foodItems'];
    this.name = mapData['name'];
    this.userId = mapData["userId"];
    this.status = mapData["status"];
    this.total = mapData["total"];
    this.paymentMethod =
        mapData["paymentMethod"] != null ? mapData["paymentMethod"] : "";
    this.foodItems = mapData['foodItems'];
    this.paymentId = mapData['paymentId'] != null ? mapData['paymentId'] : "";
  }
}
