import 'package:employee_management/features/employee_add.dart';
import 'package:employee_management/features/employee_edit.dart';
import 'package:employee_management/models/employee_model.dart';
import 'package:employee_management/providers/employee_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class Employee extends StatelessWidget {
  final data = [
    EmployeeModel(
      id: "1",
      employeeName: "Muhammad",
      employeeSalary: "4500000",
      employeeAge: "18",
      profileImage: "",
    ),
    EmployeeModel(
      id: "2",
      employeeName: "Fikri",
      employeeSalary: "7000000",
      employeeAge: "19",
      profileImage: "",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final formatCurrency = new NumberFormat.simpleCurrency();

    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Management"),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<EmployeeProvider>(context, listen: false).getEmployee(),
        color: Colors.red,
        child: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: Provider.of<EmployeeProvider>(context, listen: false)
                .getEmployee(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Consumer<EmployeeProvider>(
                builder: (context, data, _) {
                  return ListView.builder(
                      itemCount: data.dataEmployee.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EmployeeEdit(id: data.dataEmployee[i].id)));
                          },
                          child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                final bool res = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Konfirmasi"),
                                        content: Text("Apa kamu yakin ?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text("Hapus"),
                                          ),
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text("Batal"),
                                          ),
                                        ],
                                      );
                                    });
                                return res;
                              },
                              onDismissed: (value) {
                                Provider.of<EmployeeProvider>(context,
                                        listen: false)
                                    .deleteEmployee(data.dataEmployee[i].id);
                              },
                              child: Card(
                                elevation: 8,
                                child: ListTile(
                                  title: Text(
                                    data.dataEmployee[i].employeeName,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      "Umur : ${data.dataEmployee[i].employeeAge}"),
                                  trailing: Text(
                                      "\Rp.${data.dataEmployee[i].employeeSalary}"),
                                ),
                              )),
                        );
                      });
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Text("+"),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => EmployeeAdd()));
        },
      ),
    );
  }
}
