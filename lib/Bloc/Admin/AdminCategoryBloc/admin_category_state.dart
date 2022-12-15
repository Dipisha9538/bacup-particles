part of 'admin_category_bloc.dart';

@immutable
class AdminCategoryState {
  final String id;
  final String category;
  final String picture;

  AdminCategoryState({this.id, this.category, this.picture});

  AdminCategoryState copyWith({String id, String category, String picture}) =>
      AdminCategoryState(
        id: id ?? this.id,
        category: category ?? this.category,
        picture: id ?? this.picture,
      );
}

// --------------------------------------------------//
class AddCategoryState extends AdminCategoryState {}

class LoadingAddCategoryState extends AdminCategoryState {}

class AddCategorySuccessState extends AdminCategoryState {}

class FailureAddCategoryState extends AdminCategoryState {
  final String error;

  FailureAddCategoryState({this.error});
}

// -------------------------------------------------//
class LoadingUpdateCategoryState extends AdminCategoryState {}

class UpdateCategorySuccessState extends AdminCategoryState {}

class FailureUpdateCategoryState extends AdminCategoryState {
  final String error;

  FailureUpdateCategoryState({this.error});
}

// --------------- delete state -------------------
class DeleteCategoryLoadingState extends AdminCategoryState {}

class DeleteCategorySuccessState extends AdminCategoryState {}

class DeleteCategoryFailureState extends AdminCategoryState {
  final String error;

  DeleteCategoryFailureState({this.error});
}

// --------------- get category details by id state -------------------
class GetCategoryByIdLoadingState extends AdminCategoryState {}

class GetCategoryByIdSuccessState extends AdminCategoryState {}

class GetCategoryByIdFailureState extends AdminCategoryState {
  final String error;

  GetCategoryByIdFailureState({this.error});
}
