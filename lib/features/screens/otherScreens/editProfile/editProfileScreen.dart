import 'dart:io';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/provider/userProfileProvider.dart';
import 'package:egrocer/core/utils/styles/colorsRes.dart';
import 'package:egrocer/core/utils/styles/designConfig.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:egrocer/core/widgets/sessionManager.dart';
import 'package:egrocer/core/widgets/widgets.dart';
import 'package:egrocer/features/screens/otherScreens/editProfile/ui/proceedbtn.dart';
import 'package:egrocer/features/screens/otherScreens/editProfile/ui/userInfo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final String? from;

  const EditProfile({Key? key, this.from}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController edtUsername = TextEditingController();
  late TextEditingController edtEmail = TextEditingController();
  late TextEditingController edtMobile = TextEditingController();
  bool isLoading = false;
  String tempName = "";
  String tempEmail = "";
  String selectedImagePath = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      tempName = context.read<UserProfileProvider>().getUserDetailBySessionKey(
          isBool: false, key: SessionManager.keyUserName);
      tempEmail = context.read<UserProfileProvider>().getUserDetailBySessionKey(
          isBool: false, key: SessionManager.keyEmail);

      edtUsername = TextEditingController(text: tempName);
      edtEmail = TextEditingController(text: tempEmail);
      edtMobile = TextEditingController(
          text: Constant.session.getData(SessionManager.keyPhone));
      selectedImagePath = "";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          context: context,
          title: Text(
            widget.from == "register"
                ? getTranslatedValue(
                    context,
                    "lblRegister",
                  )
                : getTranslatedValue(
                    context,
                    "lblEditProfile",
                  ),
           // style: TextStyle(color: ColorsRes.mainTextColor),
          )),
      body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size15),
          children: [
            //imgWidget(),
            Card(
              margin: const EdgeInsets.only(top: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.size10, vertical: Constant.size15),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  EditProfileUserInfo(
                      edtUsername: edtUsername,
                      edtEmail: edtEmail,
                      edtMobile: edtMobile,
                      formKey: _formKey),
                  const SizedBox(height: 50),
                  EditProfileProceedBtn(
                      edtUsername: edtUsername,
                      edtEmail: edtEmail,
                      edtMobile: edtMobile,
                      tempName: tempName,
                      tempEmail: tempEmail,
                      selectedImagePath: selectedImagePath,
                      from: widget.from,
                      formKey: _formKey)
                ]),
              ),
            ),
          ]),
    );
  }

  imgWidget() {
    return Center(
      child: Stack(children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 15, end: 15),
          child: ClipRRect(
            borderRadius: Constant.borderRadius10,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: selectedImagePath.isEmpty
                ? Widgets.setNetworkImg(
                height: 100,
                width: 100,
                boxFit: BoxFit.fill,
                image: Constant.session
                    .getData(SessionManager.keyUserImage))
                : Image(
              image: FileImage(File(selectedImagePath)),
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: ()  {
              _pickImage();
            },
            child: Container(
              decoration: DesignConfig.boxGradient(5),
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsetsDirectional.only(end: 8, top: 8),
              child: Widgets.defaultImg(
                image: "edit_icon",
                iconColor: ColorsRes.mainIconColor,
                height: 15,
                width: 15,
              ),
            ),
          ),
        ),
      ]),
    );
  }


// Example function to get a temporary directory
  Future<String> getTempDirectoryPath() async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

// Modify your FilePicker usage to use the temporary directory
  Future<void> _pickImage() async {
    // Permission handling as above

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: true,
        type: FileType.image,
        lockParentWindow: true,
      );

      if (result != null && result.files.isNotEmpty) {
        String? path = result.files.first.path;
        if (path != null) {
          // Optionally copy the file to a temporary directory
          final tempDir = await getTempDirectoryPath();
          final fileName = path.split('/').last;
          final tempFile = await File(path).copy('$tempDir/$fileName');

          setState(() {
            selectedImagePath = tempFile.path;
          });
        }
      }
    } catch (e) {
      // Handle any errors during file picking
      print("File picking error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while picking the image.')),
      );
    }
  }

}
