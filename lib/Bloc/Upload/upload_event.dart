part of 'upload_bloc.dart';

@immutable
abstract class UploadEvent {}

// *----------------------------------------------*
class UploadPictureEvent extends UploadEvent {
  final String picture;
  UploadPictureEvent({this.picture});
}

// *----------------------------------------------*
class ResetUpload extends UploadEvent {
  ResetUpload();
}
