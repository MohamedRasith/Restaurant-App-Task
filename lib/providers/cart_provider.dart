import 'package:flutter/material.dart';
import 'package:zartek_task/models/restaurant_data_model.dart';




class CartProvider extends ChangeNotifier {


  Map<String, int> _cartItems = {};

  List<CategoryDish> _cartDishes = [];

  List<CategoryDish> get cartDishes => _cartDishes;

  void addItem(CategoryDish dish) {
    if (_cartItems.containsKey(dish.dishId)) {
      _cartItems.update(dish.dishId, (value) => value + 1);
    } else {
      _cartItems[dish.dishId] = 1;
      _cartDishes.add(dish);
    }
    notifyListeners();
  }

  void removeItem(CategoryDish dish) {
    if (_cartItems.containsKey(dish.dishId)) {
      if (_cartItems[dish.dishId] == 1) {
        _cartItems.remove(dish.dishId);
        _cartDishes.remove(dish);
      } else {
        _cartItems.update(dish.dishId, (value) => value - 1);
      }
    }
    notifyListeners();
  }

  int itemCount(CategoryDish dish) {
    return _cartItems[dish.dishId] ?? 0;
  }

  double get totalPrice {
    double total = 0.0;
    for (var dish in _cartDishes) {
      total += dish.dishPrice * (_cartItems[dish.dishId] ?? 0);
    }
    return total;
  }
  double getDishTotalPrice(CategoryDish dish) {
    int count = _cartItems[dish.dishId] ?? 0;
    return dish.dishPrice * count;
  }



  int get totalItemCount {
    int count = 0;
    _cartItems.forEach((dishId, quantity) {
      count += quantity;
    });
    return count;
  }

  void clear() {
    _cartItems = {};
    _cartDishes = [];
    notifyListeners();
  }
}





