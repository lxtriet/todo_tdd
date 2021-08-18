import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(String title, String? note);

class AddTaskContainer extends StatefulWidget {
  final OnSaveCallback onSave;

  AddTaskContainer({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  _AddTaskContainerState createState() => _AddTaskContainerState();
}

class _AddTaskContainerState extends State<AddTaskContainer> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title = '';
  String? _description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      height:
          MediaQuery.of(context).viewInsets.bottom > 0 ? double.maxFinite : MediaQuery.of(context).size.height * 0.5,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              autofocus: true,
              style: textTheme.headline6,
              decoration: InputDecoration(
                hintText: 'What are you planning?',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              validator: (val) {
                return (val ?? '').trim().isEmpty ? 'Please enter some text' : null;
              },
              onChanged: (value) {
                _title = value;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              maxLines: 5,
              style: textTheme.subtitle1,
              decoration: InputDecoration(
                hintText: 'Additional Description...',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                _description = value;
              },
            ),
            const SizedBox(
              height: 32,
            ),
            AddButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSave(_title, _description);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const AddButton({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        color: Colors.blue.withOpacity(0.2),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Colors.blue,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              'Add task',
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
