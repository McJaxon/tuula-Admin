import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FilePicker {
  FilePicker._();

  static Future getImage(String fileName, Function setter) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        // preferredCameraDevice: CameraDevice.front,
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 60);
    final imagePref = GetStorage();

    String dir = (await getApplicationDocumentsDirectory()).path;
    String newPath = path.join(dir, '$fileName.jpg');
    File newFile = await File(pickedFile!.path).copy(newPath);

    setter(() {
      imagePref.write(fileName, newFile.path);
      imagePref.write(
          '${fileName}Name', newFile.path.split('/').toList().last.toString());
    });
  }
}

// class GetImagePath {
//   GetImagePath._();

//   String _uploadedFileURL = '';
//   Future<String> uploadFile(File imageFile) async {
//     var preference = GetStorage();
//     var uid = preference.read('deviceUID');
//     firebase_storage.Reference storageReference = firebase_storage
//         .FirebaseStorage.instance
//         .ref()
//         .child('clientBase/$uid}');
//     firebase_storage.UploadTask uploadTask =
//         storageReference.putFile(imageFile);

//     storageReference.getDownloadURL().then((fileURL) {
//       // setState(() {
//       //   _uploadedFileURL = fileURL;
//       // });
//       _uploadedFileURL = fileURL;
//     });
//     return _uploadedFileURL;
//   }
// }
