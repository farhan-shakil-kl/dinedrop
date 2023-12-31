import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/resources/auth_methods.dart';
import 'package:food_delivery_app/widgets/foodTitleWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchCtrl = TextEditingController();
  final AuthMethods authMethods = AuthMethods();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Food> foodList = [];

  //searched text by user
  String query = "";

  @override
  void didChangeDependencies() async {
    // TODO: implement initState
    // super.initState();
    //getting food list
    DatabaseReference foodReference =
        FirebaseDatabase.instance.ref().child("Food");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firestore.collection('Food').get();

    if (querySnapshot.docs.isNotEmpty) {
      print("SEARCHING FOOD::==");
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
        Food foodItem = new Food.fromMap(doc.data());
        foodList.add(foodItem);
      });
      // print(querySnapshot.docs);
      // return querySnapshot;
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

    // foodReference.once().then((DatabaseEvent snap) {
    //   // ignore: non_constant_identifier_names
    //   Map<String, dynamic> DATA = snap.snapshot.value;
    //   print("DATA::== " + DATA.toString());
    //   List<String> KEYS = [];
    //   DATA.forEach((key, value) {
    //     KEYS.add(key);
    //   });
    //   // var KEYS = snap.value.keys;
    //   // ignore: non_constant_identifier_names
    //   // var DATA = snap.value;

    //   foodList.clear();
    //   for (var individualKey in KEYS) {
    //     print("foodlist in search ++ " + foodList.toString());
    //     Food food = new Food(
    //         description: DATA[individualKey]['description'],
    //         discount: DATA[individualKey]['discount'],
    //         image: DATA[individualKey]['image'],
    //         menuId: DATA[individualKey]['menuId'],
    //         name: DATA[individualKey]['name'],
    //         price: DATA[individualKey]['price'],
    //         keys: individualKey.toString());
    //     foodList.add(food);
    //   }
    //   setState(() {});
    // });
//    authMethods.fetchAllFood().then((List<Food> foods) {
//      setState(() {
//        foodList=foods;
//        print(foodList);
//      });
//    });
  }

  getdata() async {
    foodList = await authMethods.fetchAllFood();
    setState(() {
      print(foodList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white10,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              createSearchBar(),
              new Expanded(
                child: Container(
                  color: Colors.white10,
                  child: buildSuggestions(query),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<Food> suggestionList = query.isEmpty
        ? []
        : foodList.where((Food food) {
            String _foodName = food.name.toLowerCase();
            String _query = query.toLowerCase();

            bool isMatch = _foodName.contains(_query);
            return (isMatch);
          }).toList();
    print("suddestion list ::" + suggestionList.toString());
    return Container(
      child: suggestionList.length == -1
          ? Center(
              child: Center(child: Center(child: CircularProgressIndicator())))
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: suggestionList.length,
              itemBuilder: (_, index) {
                return FoodTitleWidget(
                  suggestionList[index],
                );
              }),
    );
  }

  createSearchBar() {
    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Row(
        children: <Widget>[
          new Expanded(
            child: TextField(
              onChanged: (val) {
                setState(() {
                  print("query string  ::  " + val);
                  query = val;
                });
              },
              controller: searchCtrl,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search..."),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.orange,
                ),
                onPressed: () => null),
          ),
        ],
      ),
    );
  }
}
