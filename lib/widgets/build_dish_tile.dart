import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:zartek_task/models/restaurant_data_model.dart';
import 'package:zartek_task/providers/cart_provider.dart';

class BuildDishTiles extends StatelessWidget {
  const BuildDishTiles({super.key, required this.menuCategory});

  final List<TableMenuList> menuCategory;


  @override
  Widget build(BuildContext context) {
    final cartProvider=Provider.of<CartProvider>(context,listen: false);
    return ListView.separated(
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          height: 255.h,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 12.w),
              child: Stack(
                children: [
                  Positioned(
                    top: 2.h,
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/1971/1971034.png',
                      width: 20.h,
                      height: 20.w,
                    ),
                  ),
                  Positioned(
                    left: 30.w,
                    child: Text(
                      menuCategory[0].categoryDishes[index].dishName,
                      maxLines: 3,
                      style:
                            TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: 30.w,
                    top: 35.h,
                    child: Text(
                      '${menuCategory[0].categoryDishes[index].dishCurrency} '
                      '${menuCategory[0].categoryDishes[index].dishPrice}',
                      style: TextStyle(fontSize: 17.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, top: 80.h),
                    child: Row(children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                            menuCategory[0].categoryDishes[index].dishDescription),
                      )
                    ]),
                  ),
                  Positioned(
                      top: 35.h,
                      left: 0.5.sw,
                      child: Text(
                        '${menuCategory[0].categoryDishes[index].dishCalories} calories',
                        style:   TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500),
                      )),
                  Visibility(
                      visible:
                          menuCategory[0].categoryDishes[index].addonCat!.isNotEmpty,
                      child: Positioned(
                          right: 10.w,
                          top: 0.21.sh,
                          child:   Text(textAlign: TextAlign.center,
                            'Customisation\n Available',
                            style: TextStyle(color: Colors.pink, fontSize: 17.sp,),
                          ))),
                  Positioned(
                      left: 30.w,
                      top: 180.h,
                      child: Container(
                        width: 130.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Theme.of(context).primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                                onTap: () {
                               cartProvider.removeItem( menuCategory[0].categoryDishes[index]);
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                )),
                            Text(
                              '${cartProvider.itemCount(menuCategory[0].categoryDishes[index])}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.sp),
                            ),
                            InkWell(
                                onTap: () {
                                  cartProvider.addItem(menuCategory[0].categoryDishes[index]);
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      )),
                  Positioned(
                      left: 0.76.sw,
                      top: 20.h,
                      child: Image.asset(
                        'assets/diet.png',
                        height: 60.h,
                        width: 60.w,
                      ))
                ],
              )),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: menuCategory[0].categoryDishes.length,
    );
  }
}
