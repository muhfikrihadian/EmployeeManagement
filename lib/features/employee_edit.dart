import 'package:employee_management/features/employee.dart';
import 'package:employee_management/providers/employee_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeEdit extends StatefulWidget{
  final String id;
  EmployeeEdit({this.id});

  @override
  _EmployeeEditState createState() => _EmployeeEditState();
}

class _EmployeeEditState extends State<EmployeeEdit>{
  final TextEditingController _name = TextEditingController();
  final TextEditingController _salary = TextEditingController();
  final TextEditingController _age = TextEditingController();
  bool _isLoading = false;
  final snackbarKey = GlobalKey<ScaffoldState>();
  FocusNode salaryNode = FocusNode();
  FocusNode ageNode = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      Provider.of<EmployeeProvider>(context, listen: false).findEmployee(widget.id).then((response){
        _name.text = response.employeeName;
        _age.text = response.employeeAge;
        _salary.text = response.employeeSalary;
      });
    });
    super.initState();
  }

  void submit(BuildContext context){
    if(!_isLoading){
      setState(() {
        _isLoading = true;
      });

      Provider.of<EmployeeProvider>(context, listen: false).updateEmployee(widget.id, _name.text, _salary.text, _age.text).then((res){
        if(res){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Employee()), (route) => false);
        }else{
          var snackbar = SnackBar(content: Text("Error"));
          snackbarKey.currentState.showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackbarKey,
      appBar: AppBar(
        title: Text("Edit Employee"),
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
                    color: Colors.pinkAccent
                  )
                ),
                hintText: "Nama lengkap"
              ),
              onSubmitted: (_){
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
                    color: Colors.pinkAccent
                  )
                ),
                hintText: "Gaji",
              ),
              onSubmitted: (_){
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
                    color: Colors.white
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