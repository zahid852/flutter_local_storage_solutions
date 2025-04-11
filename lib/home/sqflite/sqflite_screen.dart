import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:local_storage_solutions/home/sqflite/data_source.dart';

class SqfliteScreen extends StatefulWidget {
  const SqfliteScreen({super.key});

  @override
  State<SqfliteScreen> createState() => _SqfliteScreenState();
}

class _SqfliteScreenState extends State<SqfliteScreen> {
  final TextEditingController cnicEditingController = TextEditingController();
  final TextEditingController fatherNameEditingController =
      TextEditingController();
  final TextEditingController birthdayEditingController =
      TextEditingController();
  final TextEditingController addressEditingController =
      TextEditingController();
  BasicInfoModel? basicInfoModel;
  bool isDataExistAlready = false;
  final formKey = GlobalKey<FormState>();
  late Future getData;
  LocalDataSource lds = LocalDataSource();

  @override
  void initState() {
    getData = readData();
    super.initState();
  }

  Future<void> readData() async {
    basicInfoModel = await lds.read(LocalDataSourceConstants.basicInfoTable);

    if (basicInfoModel != null) {
      cnicEditingController.text = basicInfoModel!.cnic;
      fatherNameEditingController.text = basicInfoModel!.fatherName;
      birthdayEditingController.text = basicInfoModel!.birthDate;
      addressEditingController.text = basicInfoModel!.address;
      isDataExistAlready = true;
    }
  }

  @override
  void dispose() {
    cnicEditingController.dispose();
    fatherNameEditingController.dispose();
    birthdayEditingController.dispose();
    addressEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Sqflite'),
          ),
          body: SafeArea(
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: getData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: EdgeInsets.only(top: 200),
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Form(
                                      key: formKey,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Enter cnic';
                                                }
                                                return null;
                                              },
                                              controller: cnicEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.account_circle,
                                                  size: 25,
                                                ),
                                                label: const Text('CNIC'),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              controller:
                                                  fatherNameEditingController,
                                              decoration: InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.person,
                                                ),
                                                label: Text('FATHER NAME'),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Enter father name';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            TextFormField(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                controller:
                                                    birthdayEditingController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    // setState(() {
                                                    //   isBirthDateEmptyOnValidation =
                                                    //       true;
                                                    // });
                                                    return 'Enter birth date';
                                                  }
                                                  // setState(() {
                                                  //   _isBirthDateEmptyOnValidation =
                                                  //       false;
                                                  // });
                                                  return null;
                                                },
                                                readOnly: true,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  prefixIcon: const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 3),
                                                    child: Icon(
                                                      Icons.date_range,
                                                      size: 25,
                                                    ),
                                                  ),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_drop_down,
                                                    ),
                                                    iconSize: 30,
                                                    onPressed: () async {
                                                      final DateTime? date =
                                                          await showDatePicker(
                                                              context: context,
                                                              initialDate: basicInfoModel !=
                                                                      null
                                                                  ? DateFormat(
                                                                          "dd/MM/yyyy")
                                                                      .parse(basicInfoModel!
                                                                          .birthDate)
                                                                  : DateTime
                                                                      .now(),
                                                              firstDate:
                                                                  DateTime(
                                                                      1900),
                                                              lastDate: DateTime
                                                                  .now());
                                                      if (date != null) {
                                                        birthdayEditingController
                                                            .text = DateFormat(
                                                                'dd/MM/yyyy')
                                                            .format(date);
                                                      }
                                                    },
                                                  ),
                                                  label:
                                                      const Text('BIRTH DATE'),
                                                )),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              controller:
                                                  addressEditingController,
                                              maxLines: 5,
                                              minLines: 1,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Enter address';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                prefixIcon: Icon(
                                                  Icons.location_city,
                                                  size: 25,
                                                ),
                                                label: Text('ADDRESS'),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        width: double.infinity,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (snapshot.data == false) {
                                              formKey.currentState!.validate();
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                          child: ElevatedButton(
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  lds.insert(
                                                      LocalDataSourceConstants
                                                          .basicInfoTable,
                                                      BasicInfoModel(
                                                          'zahid852',
                                                          cnicEditingController
                                                              .text,
                                                          fatherNameEditingController
                                                              .text,
                                                          birthdayEditingController
                                                              .text,
                                                          addressEditingController
                                                              .text));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Data has been ${isDataExistAlready ? 'updated' : 'saved'}')));
                                                  setState(() {
                                                    isDataExistAlready = true;
                                                  });
                                                }
                                              },
                                              child: Text(
                                                isDataExistAlready
                                                    ? 'Update'
                                                    : 'Save',
                                                style: GoogleFonts.nunito(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 14,
                                      ),
                                      SizedBox(
                                        height: 48,
                                        width: double.infinity,
                                        child: GestureDetector(
                                          onTap: () {
                                            if (snapshot.data == false) {
                                              formKey.currentState!.validate();
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                await lds.deleteRecord();
                                                formKey.currentState!.reset();
                                                cnicEditingController.clear();
                                                fatherNameEditingController
                                                    .clear();
                                                birthdayEditingController
                                                    .clear();
                                                addressEditingController
                                                    .clear();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Record deleted')));
                                              },
                                              child: Text(
                                                'Delete Record',
                                                style: GoogleFonts.nunito(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                )),
          ),
        ));
  }
}
