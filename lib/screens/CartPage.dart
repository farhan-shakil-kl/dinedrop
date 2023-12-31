import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/resources/databaseSQL.dart';
import 'package:food_delivery_app/screens/MyOrderPage.dart';
import 'package:food_delivery_app/screens/homepage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

enum PaymentMethodEnum { Cash, Card }

class _CartPageState extends State<CartPage> {
  AuthMethods _authMethods = AuthMethods();

  PaymentMethodEnum _paymentMethod = PaymentMethodEnum.Cash;
  String _paymentId;

  String locationButtonMessage = 'Capture Location';
  String locationField = "https://maps.google.com/?q=<lat>,<lng>";
  bool isLocationPressed = false;

  double latitude;
  double longitude;

  var paymentMethod = 'Cash';
  final TextEditingController nametextcontroller = TextEditingController();
  final TextEditingController addresstextcontroller = TextEditingController();

  List<Food> foodList = [];
  String totalPrice = "0";
  DatabaseSql databaseSql;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatabaseValue();
  }

  getDatabaseValue() async {
    databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    foodList = await databaseSql.getData();
    print("foodlist::");
    print(foodList[0].menuId);
    //calculating total price
    int price = 0;
    foodList.forEach((food) {
      int foodItemPrice = int.parse(food.price);
      price += foodItemPrice * int.parse(food.menuId);
    });
    setState(() {
      totalPrice = price.toString();
    });
  }

  Future<void> _getLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case where the user denies permission
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user has permanently denied permission
    }
  }

  Future<Position> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  void _captureLocation() async {
    await _getLocationPermission();

    Position position = await _getCurrentLocation();

    // Use the captured position data as needed
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    // double latitude = position.latitude;
    // double longitude = position.longitude;

    print('Latitude: $latitude');
    print('Longitude: $longitude');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 30.0, top: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Cart",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 35.0),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Divider(
                  thickness: 2.0,
                ),
              ),
              createListCart(),
              createTotalPriceWidget(),
            ],
          ),
        ),
      ),
    );
  }

  createTotalPriceWidget() {
    return Container(
      color: Colors.white30,
      padding: EdgeInsets.only(right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total :",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 25.0),
              ),
              Text(
                "Rs. $totalPrice",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30.0),
              ),
            ],
          ),
          Divider(
            thickness: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.14,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                // color: Colors.orange,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10)),
                onPressed: () => _showDialog(),
                child: Text(
                  "Place Order",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  set() {
    setState(() {});
  }

  createListCart() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 400,
      child: foodList.length == 0
          ? Center(
              child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Text(
                "Please Enter Items in Cart",
                style: TextStyle(fontSize: 25),
              ),
            ))
          // ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: foodList.length,
              itemBuilder: (_, index) {
                return CartItems(
                  foodList[index],
                );
              }),
    );
  }

  _showDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // return StatefulBuilder(builder: (context, StateSetter setState) {
        return handleOrderPlacement();
        // });
      },
      // child: handleOrderPlacement(),
    );
  }

  handleOrderPlacement() {
    //check if card is empty
    if (totalPrice == "0") {
      print("not order");
      return StatefulBuilder(builder: (context, StateSetter setState) {
        // return handleOrderPlacement();
        return AlertDialog(
          title: Text('Empty Cart !'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Cart Is Empty !'),
                Text('Add Some Product on Cart First'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
    } else {
      print("order");
      return StatefulBuilder(builder: (context, StateSetter setState) {
        final TextEditingController locationController =
            TextEditingController(text: locationField);
        return AlertDialog(
          title: Text('Payment'),
          content: SingleChildScrollView(
            // can be column
            // child: ListBody(
            child: ListBody(
              children: <Widget>[
                Text('Fill Details'),
                new SizedBox(
                  child: new TextField(
                    controller: nametextcontroller,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Name', hintText: 'eg. Aaliyan'),
                  ),
                ),
                new SizedBox(
                  child: new TextField(
                    controller: addresstextcontroller,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Address',
                        hintText: 'eg. Flat 34 Block A Centro Appartments'),
                  ),
                ),
                locationButtonMessage != 'Capture Location'
                    ? new SizedBox(
                        child: new TextField(
                          controller: locationController,
                          // enabled: false,
                          readOnly: true,
                          decoration: new InputDecoration(
                            labelText: 'Location',
                            suffixIcon: IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: locationField));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Copied to clipboard')),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : isLocationPressed
                        ? Center(child: CircularProgressIndicator())
                        : new SizedBox(),
                new SizedBox(
                  child: ElevatedButton(
                    child: Text(locationButtonMessage),
                    // child: Text('Current Location'),
                    onPressed: locationButtonMessage == 'Capture Location'
                        ? () async {
                            setState(() {
                              isLocationPressed = true;
                            });
                            await _captureLocation();
                            setState(() {
                              isLocationPressed = false;
                              locationField =
                                  "https://maps.google.com/?q=$latitude,$longitude";
                              locationButtonMessage = 'Location Captured!';
                            });
                          }
                        : null,
                  ),
                ),
                new SizedBox(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Cash'),
                        leading: Radio<PaymentMethodEnum>(
                          value: PaymentMethodEnum.Cash,
                          groupValue: _paymentMethod,
                          onChanged: (PaymentMethodEnum value) {
                            setState(() {
                              _paymentMethod = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Card'),
                        leading: Radio<PaymentMethodEnum>(
                          value: PaymentMethodEnum.Card,
                          groupValue: _paymentMethod,
                          onChanged: (PaymentMethodEnum value) {
                            setState(() {
                              _paymentMethod = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
                // new Expanded(
                //   child: Row(
                //     children: [
                //       new RadioListTile(
                //         value: 'Cash',
                //         onChanged: (value) => paymentMethod,
                //       ),
                //       new Radio(),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Order'),
              onPressed: nametextcontroller.text.length > 1 &&
                      addresstextcontroller.text.length > 1 &&
                      latitude != null &&
                      longitude != null
                  ? () async {
//              Navigator.of(context).pop(); code for ordering
                      await OrderPlaceToFirebase();
                    }
                  : null,
            ),
          ],
        );
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future OrderPlaceToFirebase() async {
    bool isOrderPressed = false;
    //getter user details
    String nametxt = nametextcontroller.text;
    String addresstxt = addresstextcontroller.text;
    User user = await _authMethods.getCurrentUser();
    print("current user::");
    print(user);
    String uidtxt = user.uid;
    DateTime statustxt = DateTime.now();
    String totaltxt = totalPrice;
    //creating model

    Map aux = new Map<String, dynamic>();
    Map statusMap = new Map<String, dynamic>();
    statusMap['placed'] = statustxt;
    foodList.forEach((food) {
      //Here you can set the key of the map to whatever you like
      aux[food.keys] = food.toMap(food);
    });

    var paymentIntent;
    displayPaymentSheet(BuildContext context) async {
      try {
        await Stripe.instance.presentPaymentSheet().then((value) async {
          Request request = Request(
            address: addresstxt,
            name: nametxt,
            userId: uidtxt,
            status: statusMap,
            total: totaltxt,
            foodItems: aux,
            paymentMethod: 'Card',
            paymentId: _paymentId,
            latitude: latitude,
            longitude: longitude,
          );

          //add order
          CollectionReference orderCollectionReference =
              FirebaseFirestore.instance.collection('Order');

          var res = await orderCollectionReference.add(request.toMap(request));
          print("response::");
          print(res.get().toString());
          // await ordersReference.child(request.uid).push().set(request.toMap(request));
          // print("response::");
          // print(response);

          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 100.0,
                        ),
                        SizedBox(height: 10.0),
                        Text("Payment Successful!"),
                      ],
                    ),
                  ));
          DatabaseSql databaseSql = DatabaseSql();
          await databaseSql.openDatabaseSql();
          bool isDeleted = await databaseSql.deleteAllData();
          if (isDeleted) {
            final snackBar = SnackBar(
              content: Text('Order Placed Successfully!'),
              action: SnackBarAction(
                label: 'Goto MyOrders',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyOrderPage()));
                },
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
            });
          }

          paymentIntent = null;
        }).onError((error, stackTrace) {
          throw Exception(error);
        });
      } on StripeException catch (e) {
        print('Error is:---> $e');
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
            ],
          ),
        );
      } catch (e) {
        print('$e');
      }
    }

    createPaymentIntent(String amount, String currency) async {
      try {
        //Request body
        Map<String, dynamic> body = {
          'amount': (int.parse(amount) * 100).toString(),
          'currency': currency,
        };

        //Make post request to Stripe
        var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization':
                'Bearer sk_test_51NFixQCVb0Rqd9taHtXjJT7XEmDrgpKzDwWgE3mwWVwSXJPTB3afwIMEP5nNCjtP4NOhZmRX6Q75gfRfbs0f5sZh00sDEf7WLM',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body,
        );

        // setState(() {
        //   var DATA = json.decode(response.body);
        //   _paymentId = DATA['id'];
        //   print("_paymentid::==" + _paymentId);
        // });

        print("json.decode(response.body):: " +
            json.decode(response.body).toString());

        return json.decode(response.body);
      } catch (err) {
        throw Exception(err.toString());
      }
    }

// pi_3NKeNZCVb0Rqd9ta0JEWPb5k
    Future<void> makePayment(BuildContext context, int amount) async {
      try {
        //STEP 1: Create Payment Intent
        paymentIntent = await createPaymentIntent('$amount', 'PKR');
        setState(() {
          _paymentId = paymentIntent['id'];
          print("_paymentid1::==" + _paymentId);
          print("paymentIntent::==" + paymentIntent.toString());
        });

        //STEP 2: Initialize Payment Sheet
        await Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                    paymentIntentClientSecret: paymentIntent[
                        'client_secret'], //Gotten from payment intent
                    style: ThemeMode.light,
                    merchantDisplayName: 'DineDrop'))
            .then((value) {
          // paymentIntent
          print("line 72 ");
        });

        //STEP 3: Display Payment sheet
        await displayPaymentSheet(context);
      } catch (err) {
        print("Expception ${err.toString()}");
        throw Exception(err);
      }
    }

    // print("payment id outside::" + _paymentId);

    //    bool isDone= await _authMethods.PlaceOrder(request);
    if (_paymentMethod == PaymentMethodEnum.Card) {
      await makePayment(context, int.parse(totalPrice));
    } else {
      Request request = Request(
        address: addresstxt,
        name: nametxt,
        userId: uidtxt,
        status: statusMap,
        total: totaltxt,
        foodItems: aux,
        paymentMethod: 'Cash',
        paymentId: _paymentId,
        latitude: latitude,
        longitude: longitude,
      );
      //add order
      CollectionReference orderCollectionReference =
          FirebaseFirestore.instance.collection('Order');

      var res = await orderCollectionReference.add(request.toMap(request));
      print("response::");
      print(res.get().toString());
      // await ordersReference.child(request.uid).push().set(request.toMap(request));
      // print("response::");
      // print(response);

      DatabaseSql databaseSql = DatabaseSql();
      await databaseSql.openDatabaseSql();
      bool isDeleted = await databaseSql.deleteAllData();
      if (isDeleted) {
        final snackBar = SnackBar(
          content: Text('Order Placed Successfully!'),
          action: SnackBarAction(
            label: 'Goto MyOrders',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyOrderPage()));
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        });
      }
    }
  }
}

class CartItems extends StatefulWidget {
  final Food fooddata;
  CartItems(this.fooddata);

  @override
  _CartItemsState createState() => _CartItemsState();
}

class _CartItemsState extends State<CartItems> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onLongPress: ()=>deleteItem(),
      child: Container(
          color: Colors.white10,
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
          child: ListTile(
            leading: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    widget.fooddata.image,
                    fit: BoxFit.cover,
                  )),
              height: 80.0,
              width: 80.0,
            ),
            title: Text(
              widget.fooddata.name,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            subtitle: Text(
              "Rs. ${widget.fooddata.price} x ${widget.fooddata.menuId}",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                size: 20.0,
              ),
              onPressed: () => deleteFoodFromCart(widget.fooddata.keys),
            ),
          )),
    );
  }

  deleteFoodFromCart(String keys) async {
    print(keys);
    DatabaseSql databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    bool isDeleted = await databaseSql.deleteData(keys);
    if (isDeleted) {
      final snackBar = SnackBar(
        content: Text('Removed Food Item'),
        // action: SnackBarAction(
        //   label: 'Undo',
        //   onPressed: () {
        //     // Some code to undo the change.
        //   },
        // ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => CartPage()));
      });
    }
  }
}
