import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../Models/Card/CreditCardFrave.dart';
import '../../Service/StripeService.dart';

// import 'package:stripe_payment/stripe_payment.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is OnSelectCard) {
      yield state.copyWith(
          cardActive: true, creditCardFrave: event.creditCardFrave);
    } else if (event is OnMakePayment) {
      try {
        yield LoadingPaymentState();



        final resp = await stripeService.makePayment(event.amount);

        if (resp) {
          yield SuccessPaymentState();
        } else {
          yield FailurePaymentState(err: resp.toString());
        }
      } catch (e) {
        yield FailurePaymentState(err: e.toString());
      }
    }
  }
}
