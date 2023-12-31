import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/dummydata.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';

class MyOrderPage extends StatefulWidget {
  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  AuthMethods _authMethods = AuthMethods();

  List<Request> requestList = [
    Request(
        address: "test",
        foodItems: {},
        name: "test name",
        // status: "0",
        total: "345",
        userId: "sdfghjkllkjh")
  ];
  AuthMethods authMethods = AuthMethods();
  User currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /*getuser() async {
    currentUser = await authMethods.getCurrentUser();
    DatabaseReference foodReference =
        FirebaseDatabase.instance.ref().child("Orders").child(currentUser.uid);
    await foodReference.once().then((DataSnapshot snap) {
          // ignore: non_constant_identifier_names
          Map<String, dynamic> DATA = snap.value;
          List<String> KEYS = [];
          DATA.forEach((key, value) {
            KEYS.add(key);
          });
          // var KEYS = snap.value.keys;
          // ignore: non_constant_identifier_names
          // var DATA = snap.value;

          requestList.clear();
          for (var individualKey in KEYS) {
            Request request = Request(
              address: DATA[individualKey]['address'],
              name: DATA[individualKey]['name'],
              uid: DATA[individualKey]['uid'],
              status: DATA[individualKey]['status'],
              total: DATA[individualKey]['total'],
              foodList: DATA[individualKey]['foodList'],
            );
            requestList.add(request);
            print(request.uid);
          }
          setState(() {
            print("data");
          });
        } as FutureOr Function(DatabaseEvent value));
  }
  */
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getuser();
  }

  @override
  Widget build(BuildContext context) {
    //   getuser();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 0.0, left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, left: 18.0),
                child: Text(
                  "My Orders",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              createListOfOrder()
            ],
          ),
        ),
      ),
    );
  }

  createListOfOrder() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: FutureBuilder<QuerySnapshot>(
        future: MyOrdersFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final querySnapshot = snapshot.data;
            return ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (_, index) {
                  print("testtt::QWE");
                  print(snapshot.data.docs[index].data());
                  var data =
                      snapshot.data.docs[index].data() as Map<String, dynamic>;
                  var id = snapshot.data.docs[index].id;
                  return OrderWidget(id, Request.fromMap(data));
                });
          } else {
            return Text('No data found.');
          }
        },
      ),
      // child: requestList.length == -1
      //     ? Center(child: CircularProgressIndicator())
      //     : ListView.builder(
      //         physics: NeverScrollableScrollPhysics(),
      //         scrollDirection: Axis.vertical,
      //         itemCount: requestList.length,
      //         itemBuilder: (_, index) {
      //           return OrderWidget(
      //             requestList[index],
      //           );
      //         }),
    );
  }

  Future<QuerySnapshot> MyOrdersFromFirebase() async {
    try {
      User user = await _authMethods.getCurrentUser();
      print("current user::");
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
          .collection('Order')
          .where('userId', isEqualTo: user.uid)
          .orderBy(FieldPath(['status', 'placed']), descending: true)
          .get();
      // querySnapshot.docs.sort((a, b) =>
      //     DateTime.parse(a.data()['status']['placed'].toString())
      //         .millisecondsSinceEpoch -
      //     DateTime.parse(b.data()['status']['placed'].toString())
      //         .millisecondsSinceEpoch);
      if (querySnapshot.docs.isNotEmpty) {
        print("POPULAR FOOD::==");
        querySnapshot.docs.forEach((doc) {
          print(doc.data());
        });
        // print(querySnapshot.docs);
        return querySnapshot;
        // Data retrieved successfully
        // for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        //   // Access individual document data
        //   final data = documentSnapshot.data();
        //   print(data);
        // }
      } else {
        // No documents found
        print('No documents found in the collection.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}

class OrderWidget extends StatefulWidget {
  Request request;
  String id;
  OrderWidget(this.id, this.request);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  AuthMethods _authMethods = AuthMethods();
  Map<String, String> StatusLogos = {
    "placed": "assets/inProgress.png",
    "onTheWay": "assets/DineDrop.jpg",
    "completed": "assets/completed.png",
  };

  Map<String, int> StatusStepperMap = {
    "placed": 0,
    "onTheWay": 1,
    "completed": 2,
  };

  var status = 'assets/todo.svg';

  @override
  Widget build(BuildContext context) {
    status = widget.request.status['completed'] != null
        ? 'completed'
        : (widget.request.status['onTheWay'] != null ? 'onTheWay' : 'placed');
    print("STATUS::==  " + status);
    print("ORDER==");
    // steps.forEach(
    //   (element) {
    //     if (StatusStepperMap[element] <= StatusStepperMap[status]) {
    //       element.isActive = true;
    //     }
    //   },
    // );
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              widget.request.name,
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.request.address,
              style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.normal,
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: AssetImage(StatusLogos[status]),
              //   backgroundImage: NetworkImage(
              //       "https://www.pngitem.com/pimgs/m/252-2523515_delivery-clipart-delivery-order-frames-illustrations.png"),
            ),
            trailing: Text(
              "Rs. " + widget.request.total,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Order ID: ",
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.id != null ? widget.id : ""),
            ],
          ),
          Row(
            children: [
              Text(
                "Payment Method: ",
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.request.paymentMethod != null
                  ? widget.request.paymentMethod
                  : ""),
            ],
          ),
          Row(
            children: [
              Text(
                widget.request.paymentMethod == "Card" ? "Payment ID: " : "",
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(widget.request.paymentId != null
                  ? widget.request.paymentId
                  : ""),
            ],
          ),
          createSatusBar(),
          Container(
            padding: EdgeInsets.only(left: 20.0, top: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Items",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                createListOfFood(),
                const Divider(
                  height: 20,
                  thickness: 3,
                  // indent: 20,
                  endIndent: 20,
                  color: Colors.grey,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  createSatusBar() {
    List<Step> steps = [
      Step(
        content: Text('asd'),
        title: Text('Placed'),
        // subtitle: Text(widget.request.status['placed'].toString()),
        isActive: StatusStepperMap['placed'] <= StatusStepperMap[status],
      ),
      Step(
        title: Text('On The Way'),
        content: Text('asd'),
        isActive: StatusStepperMap['onTheWay'] <= StatusStepperMap[status],
      ),
      Step(
        content: Text('asd'),
        title: Text('Completed'),
        isActive: StatusStepperMap['completed'] <= StatusStepperMap[status],
      ),
    ];
    return Container(
      height: 100.0,
      child: Stepper(
        currentStep: StatusStepperMap[status],
        steps: steps,
        type: StepperType.horizontal,
        physics: NeverScrollableScrollPhysics(),
        // controlsBuilder:
        // (BuildContext context,
        //     {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
        //     Container(height: 0.0,),
      ),
    );
  }

  createListOfFood() {
    List<Food> foodList = [];
//    foodList=Food.fromMap(widget.request.foodList) as List<Food>;
    print("widget.request.foodItems");
    print(widget.request.foodItems);
    widget.request.foodItems.forEach((key, value) {
      print(key + "value");
      print(value);

      Food food = Food(
        name:
            "${value["name"]} x ${value["quantity"] != null ? value["quantity"] : "1"}",
        image: value["image"],
        keys: value["keys"],
        price: value["price"],
        description: value["description"],
        menuId: value["menuId"],
        discount: value["discount"],
        rating: value["rating"],
        id: key,
      );
      foodList.add(food);
    });

    return Container(
      height: 200.0,
      child: foodList.length == -1
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodList.length,
              itemBuilder: (_, index) {
                return FoodTitleWidget(
                  foodList[index],
                );
              }),
    );
  }
}
