import 'package:flutter/material.dart';

class AssetFiles {
  static String appIcon = 'assets/appIcon.png';

}

Image imageLogo(filename) {
  return Image.asset(filename, height: 25);
}
