import 'dart:io';

import 'package:pasell/Models/Home/ProductHome.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Bloc/Admin/AdminProductBloc/admin_product_bloc.dart';
import '../../../Bloc/Upload/upload_bloc.dart';
import '../../../Controller/HomeController.dart';
import '../../../Helpers/Colors.dart';
import '../../../Helpers/LoadingUpload.dart';
import '../../../Helpers/ModalFrave.dart';
import '../../../Helpers/ModalLoading.dart';
import '../../../Models/Home/CategoriesCourses.dart';
import '../../../Widgets/CustomButton.dart';
import '../../../Widgets/CustomText.dart';

class AddAdminCourse extends StatefulWidget {
  Course course;
  bool isUpdate = false;
  AddAdminCourse({this.course, this.isUpdate});

  @override
  _AddAdminCoursestate createState() => _AddAdminCoursestate();
}

class _AddAdminCoursestate extends State<AddAdminCourse> {
  TextEditingController categoryController = TextEditingController();
  Course course = Course(
      id: "",
      categoryId: CategoryId(id: "", category: ""),
      codeCourse: "",
      description: "",
      nameCourse: "",
      picture: "",
      price: 0.0,
      status: "",
      stock: 0,
      v: 0);
  bool isUpdate = false;
  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.course?.id != null) {
      course = widget.course;
    }

    isUpdate = widget.isUpdate == null ? false : widget.isUpdate;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminCourseBloc = BlocProvider.of<AdminCourseBloc>(context);
    final uploadBloc = BlocProvider.of<UploadBloc>(context).state;

    return BlocListener<AdminCourseBloc, AdminCoursestate>(
      listener: (context, state) {
        if (state is LoadingAddCoursestate) {
          modalLoading(context, 'Adding Product...');
        } else if (state is AddCoursesuccessState) {
          Navigator.of(context).pop();
          modalFrave(context, 'Item Added Successfully');
        } else if (state is FailureAddCoursestate) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(text: 'Error adding Item'),
              backgroundColor: Colors.red));
        } else if (state is LoadingUpdateCoursestate) {
          modalLoading(context, 'Updating Product...');
        } else if (state is UpdateCoursesuccessState) {
          Navigator.of(context).pop();
          modalFrave(context, 'Product Updated Successfully');
        } else if (state is FailureUpdateCoursestate) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(text: 'Error Updating Item'),
              backgroundColor: Colors.red));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: CustomText(
                text: isUpdate ? "Update ${course.nameCourse}" : 'Add Product',
                color: Colors.black),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
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
              SizedBox(height: 30.0),
              CustomText(text: 'Product Details', fontSize: 18),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(hintText: "Enter Product Name"),
                initialValue: course.nameCourse,
                onChanged: (value) => course.nameCourse = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Product Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(hintText: "Enter Item Details"),
                initialValue: course.description,
                onChanged: (value) => course.description = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Item Details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(hintText: "Discount Cupon "),
                initialValue: course.codeCourse,
                keyboardType: TextInputType.number,
                onChanged: (value) => course.codeCourse = value,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter Discount Cupon';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration:
                    InputDecoration(hintText: "Enter Total Stock Quantity"),
                keyboardType: TextInputType.number,
                initialValue: course.stock.toString(),
                onChanged: (value) => course.stock = int.parse(value),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter stock';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(hintText: "Enter Price"),
                keyboardType: TextInputType.number,
                initialValue: course.price.toString(),
                onChanged: (value) => course.price = double.parse(value),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              FutureBuilder<List<Category>>(
                future: dbHomeController.getListCategories(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? DropdownSearch<Category>(
                          // selectedItem: snapshot.data[0],
                          items: snapshot.data,
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Select a Category",
                              labelText: "Select Category",
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                            ),
                          ),
                          // onFind: (String filter) => getData(filter),
                          itemAsString: (Category p) => p.category.toString(),
                          onChanged: (Category data) => course.categoryId =
                              CategoryId(category: data.category, id: data.id),
                        )
                      : Container();
                },
              ),
              SizedBox(height: 20.0),
              DropdownSearch<String>(
                // selectedItem: snapshot.data[0],
                items: ["Avaliable", "Not Avaliable"],
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    hintText: "Select a Status",
                    labelText: "Status",
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  ),
                ),
                itemAsString: (String p) => p,
                onChanged: (String data) => course.status = data,
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: BlocListener<UploadBloc, UploadState>(
                        listener: (context, state) {
                          if (state is LoadingImageState) {
                            loadinUploadFile(context);
                          } else if (state is UploadSuccess) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                                    text: 'Image Uploaded success',
                                    fontSize: 18),
                                backgroundColor: Colors.green));
                            setState(() {});
                          }
                        },
                        child: TextButton(
                          onPressed: () => changePicture(context),
                          child: CustomText(
                            text: 'Choose Product Image',
                            color: primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      )),
                  SizedBox(height: 15.0),
                ],
              ),
              SizedBox(height: 15.0),
              CustomButton(
                text: isUpdate ? "Update" : 'Save',
                fontSize: 22,
                fontWeight: FontWeight.w500,
                height: 55,
                onPressed: () {
                  print("This is uploaded image ${uploadBloc.picture}");
                  course.picture = uploadBloc.picture;

                  if (_keyForm.currentState.validate()) {
                    !isUpdate
                        ? adminCourseBloc.add(AddCourseEvent(
                            course: course,
                          ))
                        : adminCourseBloc.add(
                            UpdateCourseEvent(
                              course: course,
                            ),
                          );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  File image;
  String img;
  final picker = ImagePicker();

  Future getImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      img = pickedFile.path;

      BlocProvider.of<UploadBloc>(context)
          .add(UploadPictureEvent(picture: img));

      print("This is uploaded picture");
    }

    setState(() {});
  }

  Future getTakeFoto() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      img = pickedFile.path;
      BlocProvider.of<UploadBloc>(context)
          .add(UploadPictureEvent(picture: img));
    }
    setState(() {});
  }

  void changePicture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      enableDrag: false,
      builder: (context) {
        return Container(
            height: 190,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25.0, top: 25.0),
                  child: CustomText(
                      text: 'Change profile picture',
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 15.0),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 0,
                    child: InkWell(
                      onTap: () {
                        getImage();
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 22.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                                text: 'Select an image', fontSize: 18)),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 0,
                    child: InkWell(
                      onTap: () {
                        getTakeFoto();
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 22.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText(
                              text: 'Take a picture',
                              fontSize: 18,
                            )),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
