import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/country/form.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({Key? key, required this.countryId}) : super(key: key);
  final String countryId;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Country',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('countries')
              .doc(widget.countryId)
              .snapshots(),
          builder: (context, snapshot) {
            String? name, code, phone;
            if (snapshot.hasData) {
              var country = snapshot.data!.data();
              name = country!['name'];
              code = country['code'];
              phone = country['phone'];
              return CountryForm(
                countryId: widget.countryId,
                name: name!,
                code: code!,
                phone: phone!,
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
