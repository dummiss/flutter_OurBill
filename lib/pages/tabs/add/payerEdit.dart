import 'package:flutter/material.dart';

class AddPayerEdit extends StatefulWidget {
  const AddPayerEdit({Key? key}) : super(key: key);

  @override
  State<AddPayerEdit> createState() => _AddPayerEditState();
}

class _AddPayerEditState extends State<AddPayerEdit> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Edit'),
            leading: const Icon(Icons.edit),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: const Text('Move'),
            leading: const Icon(Icons.folder_open),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: const Text('Delete'),
            leading: const Icon(Icons.delete),
            onTap: () => Navigator.of(context).pop(),
          )
        ],
      ),
    ));
  }
}
