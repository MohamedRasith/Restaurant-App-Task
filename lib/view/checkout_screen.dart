import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zartek_task/providers/cart_provider.dart';

class ScreenCheckout extends StatelessWidget {
  const ScreenCheckout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: SafeArea(
        child: Consumer<CartProvider>(builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          ''
                          '${value.cartDishes.length} Dishes ${value.totalItemCount} Items',
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.sp),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 0.5.sh,
                      child: Visibility(
                          visible: value.cartDishes.isNotEmpty,
                          replacement: Center(
                            child: Lottie.asset(
                                'assets/lotties/empty-cart.json',
                                fit: BoxFit.contain,
                                height: 200.h,
                                width: 200.w),
                          ),
                          child: ListView.separated(
                            itemCount: value.cartDishes.length,
                            itemBuilder: (context, index) => SizedBox(
                              width: double.infinity,
                              height: 200.h,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.h, horizontal: 12.w),
                                child: Stack(
                                  children: [
                                    Positioned(top: 20.h,
                                      child: Image.network(
                                        'https://cdn-icons-png.flaticon.com/512/1971/1971034.png',
                                        width: 20.h,
                                        height: 20.w,
                                      ),
                                    ),
                                    Positioned(left: 25.w,top: 20.h,
                                      child: Text(
                                        value.cartDishes[index].dishName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Positioned(bottom: 0.04.sh,left: 25.w,
                                      child: Text(
                                        '${value.cartDishes[index].dishCurrency} ${value.cartDishes[index].dishPrice}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Positioned(bottom: 0.01.sh,right: 0.1.sw,
                                      child: Container(
                                        width: 130.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  value.removeItem(
                                                      value.cartDishes[index]);
                                                },
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                )),
                                            Text(
                                              '${value.itemCount(value.cartDishes[index])}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17.sp),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  value.addItem(
                                                      value.cartDishes[index]);
                                                },
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(top: 45.h,right: 0.02.sw,
                                      child: Text(
                                        'INR ${value.getDishTotalPrice(value.cartDishes[index])}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                    Positioned(left: 25.w,bottom: 0.01.sh,
                                      child: Text(
                                        '${value.cartDishes[index].dishCalories} calories',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                indent: 15.w,
                                endIndent: 15.w,
                              );
                            },
                          )),
                    ),
                    const Divider(),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'INR ${value.totalPrice}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 19),
                          ),
                          // Replace with your actual total amount
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                      minimumSize: Size(0.7.sw, 0.065.sh)),
                  onPressed: () {
                    showDialog(
                      //show confirm dialogue
                      //the return value will be from "Yes" or "No" options
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Order Status'),
                        content: const Text(
                          'Order successfully placed',
                          style: TextStyle(fontSize: 15),
                        ),
                        actions: [
                          Center(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                  minimumSize: Size(0.3.sw, 0.05.sh)),
                              onPressed: () {value.clear();
                              Navigator.pop(context);

                              },
                              //Todo: redirect the user to the homepage with all the selected products cleared.

                              child: const Text(
                                'OK',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
