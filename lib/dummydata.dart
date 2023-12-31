import 'models/Category.dart';
import 'models/Food.dart';

List<Food> popularFoodList = [
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6"),
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/216054.jpg",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6"),
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://static.toiimg.com/thumb/54659021.cms?width=1200&height=1200",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6"),
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://i.pinimg.com/originals/3b/b4/ea/3bb4ea708b73c60a11ccd4a7bdbb1524.jpg",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6")
];

//for recently added food
Category recentlyCategory = Category(
    image:
        "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
    name: "burger",
    keys: "08");
Category recentlyCategory2 = Category(
    image:
        "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/216054.jpg",
    name: "Pizza",
    keys: "04");
Category recentlyCategory3 = Category(
    image:
        "https://static.toiimg.com/thumb/54659021.cms?width=1200&height=1200",
    name: "french fries",
    keys: "07");
Category recentlyCategory4 = Category(
    image:
        "https://i.pinimg.com/originals/3b/b4/ea/3bb4ea708b73c60a11ccd4a7bdbb1524.jpg",
    name: "kfc chicken",
    keys: "09");

List<Category> categoryList = [
  recentlyCategory,
  recentlyCategory2,
  recentlyCategory3,
  recentlyCategory4
];
// TODO: implement initState

List<Food> foodList = [
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6"),
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/216054.jpg",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6"),
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://static.toiimg.com/thumb/54659021.cms?width=1200&height=1200",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6"),
  Food(
      description: "",
      discount: "test desc",
      image:
          "https://i.pinimg.com/originals/3b/b4/ea/3bb4ea708b73c60a11ccd4a7bdbb1524.jpg",
      menuId: "5",
      name: "test name",
      price: "456",
      keys: "6")
];
