part of 'upload_bloc.dart';

@immutable
class UploadState {
  final String picture;

  UploadState({this.picture});

  UploadState copyWith({String picture}) => UploadState(
        picture: picture ?? this.picture,
      );
}

// -------------------------------------------------//

class LoadingImageState extends UploadState {}

class UploadSuccess extends UploadState {}

class FailureSaveImage extends UploadState {
  final String error;

  FailureSaveImage({this.error});
}
