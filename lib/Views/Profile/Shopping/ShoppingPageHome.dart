import '../../../Controller/CourseController.dart';
import '../../../Helpers/BaseServerUrl.dart';
import '../../../Models/Response/PurchasedCoursesResponse.dart';
import '../../../Widgets/BottomNavigationFrave.dart';
import '../../../Widgets/ShimmerFrave.dart';
import '../../../Widgets/CustomText.dart';
import 'package:flutter/material.dart';

class PurchasesPageHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'Purchased', color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          FutureBuilder<PurchasedCoursesResponse>(
            future: dbCourseController.getPurchasedCourses(),
            builder: (_, snapshot) {
              return (!snapshot.hasData)
                  ? ShimmerFrave()
                  : _DetailsCoursesBuy(purchased: snapshot.data);
            },
          ),
          Positioned(
            bottom: 20,
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Align(child: BottomNavigationFrave(index: 3))),
          ),
        ],
      ),
    );
  }
}

class _DetailsCoursesBuy extends StatelessWidget {
  final PurchasedCoursesResponse purchased;

  const _DetailsCoursesBuy({this.purchased});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      itemCount: purchased.orderDetails.length,
      itemBuilder: (_, i) => Container(
        height: 400,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        margin: EdgeInsets.only(bottom: 15.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child:
                    CustomText(text: purchased.orderBuy.receipt, fontSize: 21)),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'Date ', fontSize: 19, color: Colors.grey),
                CustomText(text: '${purchased.orderBuy.datee}', fontSize: 19),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: 'Amount ', fontSize: 19, color: Colors.grey),
                CustomText(
                    text: '\Rs ${purchased.orderBuy.amount}', fontSize: 19),
              ],
            ),
            SizedBox(height: 10.0),
            Divider(),
            SizedBox(height: 10.0),
            CustomText(text: 'Items', fontSize: 19),
            SizedBox(height: 10.0),
            Container(
              height: 220,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(15.0)),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: purchased.orderDetails.length,
                itemBuilder: (_, i) => Container(
                  margin: EdgeInsets.only(right: 10.0),
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Row(
                    children: [
                      Container(
                        height: 150,
                        width: 100,
                        child: Image.network(publicServerUrl +
                            purchased.orderDetails[i].courseId.picture),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        height: 150,
                        width: MediaQuery.of(context).size.width * .53,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              children: [
                                CustomText(
                                    text: purchased
                                        .orderDetails[i].courseId.nameCourse,
                                    fontSize: 17),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            CustomText(
                                text: '\Rs ${purchased.orderDetails[i].price}',
                                fontSize: 18),
                            SizedBox(height: 10.0),
                            Container(
                                alignment: Alignment.center,
                                height: 29,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Color(0xfff5f5f5),
                                    shape: BoxShape.circle),
                                child: CustomText(
                                    text:
                                        '${purchased.orderDetails[i].quantity}',
                                    fontSize: 19)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
