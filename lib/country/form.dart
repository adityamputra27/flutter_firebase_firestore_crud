import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CountryForm extends StatefulWidget {
  const CountryForm({
    Key? key,
    required this.countryId,
    required this.name,
    required this.phone,
    required this.code,
  }) : super(key: key);
  final String countryId;
  final String name;
  final String code;
  final String phone;

  @override
  State<CountryForm> createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController codeController = TextEditingController();

    setState(() {
      nameController.text = widget.name;
      phoneController.text = widget.phone;
      codeController.text = widget.code;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Country Name :',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF4C59A5),
            borderRadius: BorderRadius.circular(22),
          ),
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '...',
              hintStyle: TextStyle(color: Colors.white60),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Country Code :',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF4C59A5),
            borderRadius: BorderRadius.circular(22),
          ),
          child: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '...',
              hintStyle: TextStyle(color: Colors.white60),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Phone Code :',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF4C59A5),
            borderRadius: BorderRadius.circular(22),
          ),
          child: TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '...',
              hintStyle: TextStyle(color: Colors.white60),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: () {
            var collection = FirebaseFirestore.instance.collection('countries');
            collection.doc(widget.countryId).update({
              'name': nameController.text,
              'phone': phoneController.text,
              'code': codeController.text
            });
            Navigator.pop(context, true);
          },
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
