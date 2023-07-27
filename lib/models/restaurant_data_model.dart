// To parse this JSON data, do
//
//     final restaurantData = restaurantDataFromJson(jsonString);

import 'dart:convert';

List<RestaurantData> restaurantDataFromJson(String str) => List<RestaurantData>.from(json.decode(str).map((x) => RestaurantData.fromJson(x)));

class RestaurantData {
  RestaurantData({
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.tableId,
    required this.tableName,
    required this.branchName,
    required this.nexturl,
    required this.tableMenuList,
  });

  String restaurantId;
  String restaurantName;
  String restaurantImage;
  String tableId;
  String tableName;
  String branchName;
  String nexturl;
  List<TableMenuList> tableMenuList;

  factory RestaurantData.fromJson(Map<String, dynamic> json) => RestaurantData(
    restaurantId: json["restaurant_id"],
    restaurantName: json["restaurant_name"],
    restaurantImage: json["restaurant_image"],
    tableId: json["table_id"],
    tableName: json["table_name"],
    branchName: json["branch_name"],
    nexturl: json["nexturl"],
    tableMenuList: List<TableMenuList>.from(json["table_menu_list"].map((x) => TableMenuList.fromJson(x))),
  );
}

class TableMenuList {
  TableMenuList({
    required this.menuCategory,
    required this.menuCategoryId,
    required this.menuCategoryImage,
    required this.nexturl,
    required this.categoryDishes,
  });

  String menuCategory;
  String menuCategoryId;
  String menuCategoryImage;
  String nexturl;
  List<CategoryDish> categoryDishes;

  factory TableMenuList.fromJson(Map<String, dynamic> json) => TableMenuList(
    menuCategory: json["menu_category"],
    menuCategoryId: json["menu_category_id"],
    menuCategoryImage: json["menu_category_image"],
    nexturl: json["nexturl"],
    categoryDishes: List<CategoryDish>.from(json["category_dishes"].map((x) => CategoryDish.fromJson(x))),
  );

}

class CategoryDish {
  CategoryDish({
    required this.dishId,
    required this.dishName,
    required this.dishPrice,
    required this.dishImage,
    required this.dishCurrency,
    required this.dishCalories,
    required this.dishDescription,
    required this.dishAvailability,
    required this.dishType,
    this.nexturl,
    this.addonCat,
  });

  String dishId;
  String dishName;
  double dishPrice;
  String dishImage;
  String dishCurrency;
  double dishCalories;
  String dishDescription;
  bool dishAvailability;
  int dishType;
  String? nexturl;
  List<AddonCat>? addonCat;

  factory CategoryDish.fromJson(Map<String, dynamic> json) => CategoryDish(
    dishId: json["dish_id"],
    dishName: json["dish_name"],
    dishPrice: json["dish_price"]?.toDouble(),
    dishImage: json["dish_image"],
    dishCurrency:   'INR',
    dishCalories: json["dish_calories"],
    dishDescription: json["dish_description"],
    dishAvailability: json["dish_Availability"],
    dishType: json["dish_Type"],
    nexturl: json["nexturl"],
    addonCat: json["addonCat"] == null ? [] : List<AddonCat>.from(json["addonCat"]!.map((x) => AddonCat.fromJson(x))),
  );
}

class AddonCat {
  AddonCat({
    required this.addonCategory,
    required this.addonCategoryId,
    required this.addonSelection,
    required this.nexturl,
    required this.addons,
  });

  String addonCategory;
  String addonCategoryId;
  int addonSelection;
  String nexturl;
  List<CategoryDish> addons;

  factory AddonCat.fromJson(Map<String, dynamic> json) => AddonCat(
    addonCategory: json["addon_category"],
    addonCategoryId: json["addon_category_id"],
    addonSelection: json["addon_selection"],
    nexturl: json["nexturl"],
    addons: List<CategoryDish>.from(json["addons"].map((x) => CategoryDish.fromJson(x))),
  );


}



