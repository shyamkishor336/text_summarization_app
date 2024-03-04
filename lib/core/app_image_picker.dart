import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  final List<File> fileList = [];
  File? file;
  final ImagePicker picker = ImagePicker();

  Future<File?> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }

  Future<File?> pickSingleImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }
  Future<PlatformFile?> pickWebImage() async {
    final result = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    ))?.files;
    if (result != null) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<List<File>?> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      for (var i in result.files) {
        fileList.add(File(i.path!));
      }
      return fileList;
    } else {
      return null;
    }
  }
}
