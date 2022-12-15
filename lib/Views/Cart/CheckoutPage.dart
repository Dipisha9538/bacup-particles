import 'dart:convert';

import '../../Bloc/bloc/product_bloc.dart';
import '../../Helpers/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Bloc/Cart/cart_bloc.dart';
import '../../Bloc/Personal/personal_bloc.dart';
import '../../Helpers/modalPayment.dart';
import 'DeliveryPage.dart';
import 'PaymentPage.dart';
import '../../Widgets/AnimationRoute.dart';
import '../../Widgets/CustomButton.dart';
import '../../Widgets/CustomText.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';

class CheckOutPagePage extends StatefulWidget {
  @override
  State<CheckOutPagePage> createState() => _CheckOutPagePageState();
}

class _CheckOutPagePageState extends State<CheckOutPagePage> {
  // init state
  @override
  void initState() {
    _paymentIntentData = {};
    AwesomeNotifications().initialize(
      "resource://drawable/logo", // icon for your app notification
      [
        NotificationChannel(
          channelGroupKey: 'basic_tests',
          channelKey: 'basic_channel',
          channelName: 'Payment Successful',
          channelDescription: 'Your order is successfully placed',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_tests', channelGroupName: 'Basic tests'),
      ],
    );

    super.initState();
  }

  String _paymentApiUrl = "https://api.stripe.com/v1/payment_intents";

  String _secretKey =
      "sk_test_51Ih5GzHmsIXlXA5BXcXB2pu9zIPUO4m3AI1aJ7alTbGsvE4tquIosr7ujx079Bo88JtGKz7JkeEJLBsOZFeJnBm000HB1PVyYk";

  String publishableKey =
      "pk_test_51Ih5GzHmsIXlXA5B2yqi16ahSis9qPIV9w1dX3M9nsdesNiEIaj7EgqByz8eN0TJlyRZrD8kDKaKdyifNybdZtue00w4N0rVya";

  Map<String, dynamic> _paymentIntentData;

  // ============= notification =====================

  //  Notification check
  void notify({String title, String description, String image}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: title,
          body: description,
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: image),
    );
  }

  Future<void> makePayment(double amount) async {
    try {
      _paymentIntentData = await createPaymentIntent(amount, "USD");
      print(_paymentIntentData);
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: _paymentIntentData["client_secret"],

        // style: ThemeMode.system,
        merchantDisplayName: "Aims Digital ",
      ));
      await displayPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      // await Stripe.instance.presentPaymentSheet();

      await Stripe.instance.presentPaymentSheet().then((newValue) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("paid successfully")));

        _paymentIntentData = null;
      });
      // return true;
    } on StripeException catch (e) {
      print(e);
      // return false;
    }
  }

  createPaymentIntent(double amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount),
        "currency": currency,
        "payment_method_types[]": "card"
      };

      var response = await http.post(Uri.parse(_paymentApiUrl),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Bearer $_secretKey"
          },
          body: body);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
  }

  String calculateAmount(double amount) {
    final price = amount.toInt();
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    // new StripeService()
    //   ..init();

    final courseBloc = BlocProvider.of<CourseBloc>(context);
    final personalBloc = BlocProvider.of<PersonalBloc>(context);
    final cartBloc = BlocProvider.of<CartBloc>(context);

    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is LoadingPaymentState) {
          // modalLoading(context, 'Making payment...');

        } else if (state is SuccessPaymentState) {
          notify(
              title: "Payment successful",
              description: "Your order is Successfully placed",
              image:
                  "https://cdn1.vectorstock.com/i/1000x1000/63/65/green-check-mark-icon-in-a-circle-tick-symbol-vector-37776365.jpg");
          Navigator.pop(context);
          courseBloc.add(SaveCoursesBuy(
              date: DateTime.now().toString(),
              amount: '${courseBloc.state.total}',
              course: courseBloc.course));
          courseBloc.add(ClearCoursesEvent());
          modalPayment(context);
        } else if (state is FailurePaymentState) {
          notify(
            title: "Payment unsuccessful",
            description: "Your order is canceled or failed",
            image:
                "https://thumbs.dreamstime.com/b/red-cross-symbol-icon-as-delete-remove-fail-failure-incorr-incorrect-answer-89999776.jpg",
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: CustomText(
                    text: "Payment failed or canceled", fontSize: 17),
                backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfff3f4f8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title:
              CustomText(text: 'Checkout', color: Colors.black, fontSize: 21),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
              color: Colors.white,
              height: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: 'Shipping address',
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                      GestureDetector(
                        child: CustomText(
                            text: personalBloc.state.address == null
                                ? 'Add'
                                : 'Change',
                            color: primaryColor,
                            fontSize: 18),
                        onTap: () => Navigator.of(context).push(customRoute(
                            page: DeliveryPage(), curved: Curves.easeInOut)),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 5.0),
                  BlocBuilder<PersonalBloc, PersonalState>(
                      builder: (context, state) => (state.address == null)
                          ? CustomText(
                              text: 'Without Street Address', fontSize: 18)
                          : CustomText(
                              text: '${personalBloc.state.address}',
                              fontSize: 18))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              height: 113,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: 'Payment',
                          fontSize: 19,
                          fontWeight: FontWeight.w600),
                      GestureDetector(
                          child: BlocBuilder<CartBloc, CartState>(
                              builder: (context, state) => (!state.cardActive)
                                  ? CustomText(
                                      text: 'Add',
                                      color: primaryColor,
                                      fontSize: 18)
                                  : CustomText(
                                      text: 'Change',
                                      color: primaryColor,
                                      fontSize: 18)),
                          onTap: () => Navigator.of(context).push(customRoute(
                              page: PaymentPage(), curved: Curves.easeInOut)))
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 5.0),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) => (!state.cardActive)
                        ? CustomText(text: 'Without Credit Card', fontSize: 18)
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            color: Color(0xfff5f5f5),
                            child: Row(
                              children: [
                                Container(
                                    height: 50,
                                    width: 50,
                                    child: SvgPicture.asset(
                                        'Assets/${state.creditCardFrave.brand}.svg')),
                                SizedBox(width: 15.0),
                                CustomText(
                                  text:
                                      '**** **** **** ${state.creditCardFrave.cardNumberHidden}',
                                  fontSize: 18,
                                )
                              ],
                            ),
                          ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(15.0),
              height: 100,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                      text: 'Delivery Details',
                      fontSize: 19,
                      fontWeight: FontWeight.w600),
                  Divider(),
                  CustomText(text: 'Stander Delivery (3-4 days)', fontSize: 18),
                ],
              ),
            ),
            _PromoCode(),
            _OrderDetails(),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              height: 60,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Total',
                    fontSize: 19,
                  ),
                  CustomText(
                    text: '\$ ${courseBloc.state.total}',
                    fontSize: 19,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                text: 'Pay Now',
                height: 55,
                fontSize: 22,
                onPressed: () async {
                  // await makePayment(CourseBloc.state.total * 100);
                  // await Stripe.instance.presentPaymentSheet();
                  cartBloc.add(
                    OnMakePayment(amount: courseBloc.state.total * 100),
                  );

                  // Notification new
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _OrderDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courseBloc = BlocProvider.of<CourseBloc>(context);

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      height: 130,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Order',
                fontSize: 19,
              ),
              CustomText(
                text: '\$ ${courseBloc.state.total}',
                fontSize: 19,
              )
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Delivery',
                fontSize: 19,
              ),
              CustomText(
                text: '\$ ${courseBloc.state.delivery}',
                fontSize: 19,
              )
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Insurance',
                fontSize: 19,
              ),
              CustomText(
                text: '\$ ${courseBloc.state.insurance}',
                fontSize: 19,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _PromoCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Promo',
            fontSize: 19,
          ),
          SizedBox(height: 10.0),
          Row(
            children: [
              Container(
                  // width: 250,
                  child: Flexible(
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Roboto', fontSize: 19),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Color(0xffF5F5F5))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              )),
              SizedBox(width: 10.0),
              Container(
                height: 48,
                width: 200,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Center(
                    child: CustomText(
                  text: 'Use Code',
                  color: Colors.white,
                  fontSize: 18,
                )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
