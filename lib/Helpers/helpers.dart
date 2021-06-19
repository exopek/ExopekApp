import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';



class HelperFunctions {
  //String id;

  /*
  HelperFunctions({@required this.id}) {
    assert(id != null);
  }
  */

  Color mixColor(Color colorOne ,Color colorTwo, double amount) {
    return Color.lerp(colorOne ,colorTwo, amount);
  }

  Future<PickedFile> pickImage() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera);
    return pickedFile;
  }

  Future<void> launchURL(String route) async {
    final url = route;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Die $url konnt nicht geöffnet werden';
    }
  }

  List splitSeparatedWords(String text, List separator) {
    var StringList = new List();
    var temp = new List();
    var temp2 = new List();
    for(int i = 0; i < separator.length; i++) {
      if (i == 0) {
        StringList = text.split(separator[i]);
      }
      else if (i == 1) {
        temp = StringList[1].split(separator[i]);
      }
      else if (i == 2) {
        temp2 = temp[0].split(separator[i]);
      }


    }

    return temp2;
  }

}