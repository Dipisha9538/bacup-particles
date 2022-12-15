part of 'admin_category_bloc.dart';

@immutable
abstract class AdminCategoryEvent {}

class AddCategoryEvent extends AdminCategoryEvent {
  final String category;
  final String picture;

  AddCategoryEvent({this.category, this.picture});
}


class UpdateCategoryEvent extends AdminCategoryEvent {
  final String category;
  final String picture;
  final String id;

  UpdateCategoryEvent({this.category, this.picture, this.id});
}

// delete category
class DeleteCategoryEvent extends AdminCategoryEvent {
  final String id;
  DeleteCategoryEvent({this.id});
}
// get category details by id
class GetCategoryDetailsByIdEvent extends AdminCategoryEvent {
  final String id;
  GetCategoryDetailsByIdEvent({this.id});
}