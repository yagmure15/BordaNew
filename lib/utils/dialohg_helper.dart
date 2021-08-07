import 'package:bordatech/utils/show_date_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper{
  static goster(context) => showDialog(context: context, builder: (context) => ShowDateDialog()
  );
}

