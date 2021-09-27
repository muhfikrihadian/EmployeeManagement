import 'dart:math';

import 'package:employee_management/features/employee.dart';
import 'package:employee_management/providers/employee_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeAdd extends StatefulWidget {

  @override
  _EmployeeAddState createState() => _EmployeeAddState();

}

class _EmployeeAddState extends State<EmployeeAdd> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final snackbarKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  FocusNode salaryNode = FocusNode();
  FocusNode ageNode = FocusNode();

  void submit(BuildContext context) {
    if (!_isLoading) {
      var snackbar = SnackBar(content: Text("Ooppss... Something went wrong"),);
      snackbarKey.currentState.showSnackBar(snackbar);
      setState(() {
        _isLoading = true;
      });
      Provider.of<EmployeeProvider>(context, listen: false).storeEmployee(
          _name.text, _salary.text, _age.text).then((res) {
        if (res) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Employee()), (route) => false);
        } else {

        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackbarKey,
      appBar: AppBar(
        title: Text("Add Employee"),
        actions: <Widget>[
          FlatButton(
            child: _isLoading ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ) : Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () => submit(context),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _name,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pinkAccent,
                      )
                  ),
                  hintText: "Nama lengkap"
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(salaryNode);
              },
            ),
            TextField(
              controller: _salary,
              focusNode: salaryNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.pinkAccent,
                      )
                  ),
                  hintText: "Gaji"
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(ageNode);
              },
            ),
            TextField(
              controller: _age,
              focusNode: ageNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.pinkAccent
                      )
                  ),
                  hintText: "Umur"
              ),
            )
          ],
        ),
      ),
    );
  }
}