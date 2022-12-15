import 'package:flutter/material.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: TabBar(
            unselectedLabelColor: Color.fromARGB(255, 11, 11, 11),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color.fromRGBO(85, 83, 177, 1),
            ),
            tabs: [
              Tab(
                // text: "hii",
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: Color.fromRGBO(85, 83, 177, 1), width: 1)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Product Details"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border:
                          Border.all(color: Color.fromRGBO(85, 83, 177, 1))),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Comment"),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
