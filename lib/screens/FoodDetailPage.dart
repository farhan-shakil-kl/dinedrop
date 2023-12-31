import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resources/databaseSQL.dart';
import 'package:food_delivery_app/screens/CartPage.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';
import 'package:toast/toast.dart';

import '../dummydata.dart';

class FoodDetailPage extends StatefulWidget {
  final Food fooddata;
  FoodDetailPage(this.fooddata);
  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // String sampleDescription =
  // "The existence of the Positioned forces the Container to the left, instead of centering. Removing the Positioned, however, puts the Container in the middle-center";

  //no of items add to list
  int _itemCount = 1;

  /*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getting food list
    DatabaseReference foodReference =
        FirebaseDatabase.instance.reference().child("Foods");
    foodReference.once().then((DataSnapshot snap) {
          // ignore: non_constant_identifier_names
          Map<String, dynamic> DATA = snap.value;
          List<String> KEYS = [];
          DATA.forEach((key, value) {
            KEYS.add(key);
          });
          // var KEYS = snap.value.keys;
          // ignore: non_constant_identifier_names
          // var DATA = snap.value;
          foodList.clear();
          for (var individualKey in KEYS) {
            Food food = new Food(
                description: DATA[individualKey]['description'],
                discount: DATA[individualKey]['discount'],
                image: DATA[individualKey]['image'],
                menuId: DATA[individualKey]['menuId'],
                name: DATA[individualKey]['name'],
                price: DATA[individualKey]['price'],
                keys: individualKey.toString());
            if (food.menuId == "06") {
              foodList.add(food);
            }
          }
          setState(() {
            print("data");
          });
        } as FutureOr Function(DatabaseEvent value));
  }
  */
  @override
  Widget build(BuildContext context) {
    int star = 0;
    var random = new Random();
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(0.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0.0),
                              bottomRight: Radius.circular(80.0)),
                          gradient: LinearGradient(
                              colors: [Colors.black45, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.fooddata.rating != null
                              ? widget.fooddata.rating
                              : "" + " ★",
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.bottomLeft,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                        bottomRight: Radius.circular(80.0)),
                    image: DecorationImage(
                        image: NetworkImage(widget.fooddata.image),
                        fit: BoxFit.cover),
                  ),
                ),
                createdetails(),
                createPopularFoodList(),
              ],
            ),
          ),
        ));
  }

  createdetails() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            widget.fooddata.name,
            style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700]),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, top: 10.0, bottom: 10.0),
                child: Text(
                  "Rs." + widget.fooddata.price,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              //widget of counter
              Container(
                margin: EdgeInsets.only(right: 18.0),
//                height: 40.0,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(50.0))),
                child: Row(
                  children: <Widget>[
                    _itemCount != 1
                        ? new IconButton(
                            icon: new Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () => setState(() => _itemCount--),
                          )
                        : new IconButton(
                            icon: new Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () => null),
                    new Text(
                      _itemCount.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    new IconButton(
                        icon: new Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () => setState(() => _itemCount++))
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.fooddata.description,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38),
              )),
          SizedBox(
            height: 30.0,
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: RatingBar(
          //     initialRating: 3,
          //     minRating: 1,
          //     direction: Axis.horizontal,
          //     allowHalfRating: true,
          //     itemCount: 5,
          //     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          //     // itemBuilder: (context, _) => Icon(
          //     //   Icons.star,
          //     //   color: Colors.amber,
          //     // ),
          //     onRatingUpdate: (rating) {
          //       print(rating);
          //     },
          //   ),
          // ),
          SizedBox(
            height: 30.0,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.15,
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => addToCart(widget.fooddata.keys),
              child: Text(
                "Add To Cart",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  createPopularFoodList() {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              "Popular Food ",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 200.0,
            child: FutureBuilder<QuerySnapshot>(
              future: fetchPopularFood(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final querySnapshot = snapshot.data;
                  print("data in comp:::");
                  print(snapshot.data.docs);
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (_, index) {
                        var data = snapshot.data.docs[index].data()
                            as Map<String, dynamic>;
                        String imageLink = data['image'];
                        print("iamgelink3");
                        print(imageLink);
                        return FoodTitleWidget(
                          Food(
                            description: data['description'],
                            discount: "test desc",
                            image: data['image'],
                            menuId: "5",
                            name: data['name'],
                            price: data['price'],
                            rating: data['rating'],
                          ),
                        );
                      });
                } else {
                  return Text('No data found.');
                }
              },
            ),
            // child: popularFoodList.length == -1
            //     ? Center(child: Center(child: CircularProgressIndicator()))
            //     : ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: popularFoodList.length,
            //         itemBuilder: (_, index) {
            //           return FoodTitleWidget(
            //             popularFoodList[index],
            //           );
            //         }),
          ),
        ],
      ),
    );
  }

  addToCart(String keys) async {
    DatabaseSql databaseSql = DatabaseSql();
    await databaseSql.openDatabaseSql();
    var foodData = widget.fooddata;
    foodData.quantity = _itemCount.toString();
    // foodData.quantity = _itemCount.toString();
    // for (int i = 0; i < _itemCount; i++) {
    bool isInserted = await databaseSql.insertData(foodData);
    // }
    await databaseSql.getData();
    final snackBar = SnackBar(
      content: Text('Food Added To Cart'),
      action: SnackBarAction(
        label: 'Goto Cart',
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartPage()));
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Toast.show("Toast plugin app", context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  Future<QuerySnapshot> fetchPopularFood() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Food')
          .orderBy('rating', descending: true)
          .limit(4)
          .get();
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
      // Handle errors
      print('Error fetching data: $e');
    }
  }

  //we are generating random rating for now
  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
