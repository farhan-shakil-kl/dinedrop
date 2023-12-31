import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/screens/CategoryListPage.dart';
import 'package:food_delivery_app/screens/FoodDetailPage.dart';

class CategoryWidget extends StatelessWidget {
  final Food food;
//  final String imageUrl,name,keys;
  CategoryWidget(this.food);

  @override
  Widget build(BuildContext context) {
    gotoFoodDetail() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => FoodDetailPage(food)));
    }

    print("category in category widget");
    print(food.id);
    String price = food.price;
    return GestureDetector(
      onTap: () => gotoFoodDetail(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              width: 300.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  food.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              food.name,
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Row(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                ),
                Text(
                  food.rating,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Rs. $price",
                  style: TextStyle(color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
