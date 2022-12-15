import '../../Bloc/Auth/auth_bloc.dart';
import '../../Bloc/Personal/personal_bloc.dart';
import '../../Controller/PersonalController.dart';
import '../../Helpers/ModalFrave.dart';
import '../../Helpers/ModalLoading.dart';
import '../../Widgets/TextFormFrave.dart';
import '../../Widgets/CustomText.dart';
import '../../Widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InformationPage extends StatefulWidget {
  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  TextEditingController firstnameController;
  TextEditingController lastnameController;
  TextEditingController phoneController;
  TextEditingController addressController;
  TextEditingController referenceController;
  final _keyForm = GlobalKey<FormState>();

  getPersonalInformation() async {
    final information = await personalController.getPersonalInformation();

    firstnameController =
        TextEditingController(text: information.information.firstName);
    lastnameController =
        TextEditingController(text: information.information.lastName);
    phoneController =
        TextEditingController(text: information.information.phone);
    addressController =
        TextEditingController(text: information.information.address);
    referenceController =
        TextEditingController(text: information.information.reference);

    setState(() {});
  }

  @override
  void initState() {
    getPersonalInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = BlocProvider.of<AuthBloc>(context);
    final personalBloc = BlocProvider.of<PersonalBloc>(context);

    return BlocListener<PersonalBloc, PersonalState>(
      listener: (context, state) {
        if (state is LoadingPersonalState) {
          modalLoading(context, 'updating...');
        } else if (state is SuccessRegisterPersona) {
          Navigator.of(context).pop();
          modalFrave(context, 'Your Info has been Updated Successfully');
        } else if (state is FailureRegisterState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(text: 'Error adding user'),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: CustomText(text: 'My Profile', color: Colors.black),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Color.fromARGB(255, 12, 12, 12),
              ),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Form(
          key: _keyForm,
          child: ListView(
            physics: BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            children: [
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 51, 33, 191).withOpacity(.5),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: 'User :',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: auth.state.username,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Email :',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        CustomText(
                          text: auth.state.email,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CustomText(text: 'Personal Information', fontSize: 20),
              SizedBox(height: 10.0),
              TextFormFrave(
                controller: firstnameController,
                hintText: 'First Name',
                prefixIcon: Icons.person_outline_rounded,
                fontSize: 17,
              ),
              SizedBox(height: 20.0),
              TextFormFrave(
                controller: lastnameController,
                hintText: 'Last Name',
                prefixIcon: Icons.person_outline_rounded,
                fontSize: 17,
              ),
              SizedBox(height: 20.0),
              TextFormFrave(
                controller: phoneController,
                hintText: 'Contact Number',
                prefixIcon: Icons.phone_android_rounded,
                type: TextInputType.phone,
                fontSize: 17,
              ),
              SizedBox(height: 20.0),
              TextFormFrave(
                controller: addressController,
                hintText: 'Street Address',
                prefixIcon: Icons.home_outlined,
                type: TextInputType.streetAddress,
                fontSize: 17,
              ),
              SizedBox(height: 20.0),
              TextFormFrave(
                controller: referenceController,
                hintText: 'Country',
                prefixIcon: Icons.home_outlined,
                type: TextInputType.streetAddress,
                fontSize: 17,
              ),
              SizedBox(height: 35.0),
              CustomButton(
                text: 'Update Info',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 55,
                onPressed: () {
                  if (_keyForm.currentState.validate()) {
                    personalBloc.add(RegisterPersonalInformationEvent(
                        name: firstnameController.text,
                        lastName: lastnameController.text,
                        phone: phoneController.text,
                        address: addressController.text,
                        reference: referenceController.text));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
