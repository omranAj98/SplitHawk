import 'package:flutter/material.dart';

class AddExpenseModel extends StatelessWidget {
  const AddExpenseModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: double.minPositive,

      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Add Post"),
          const SizedBox(
            height: 12,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Message", // Set the hint text here
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text("Add Image"),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              print("upload Tap");
            },
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  border: Border.all(color: Colors.white)),
              child: const Center(child: Text("Upload from Gallery")),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text("OR"),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {},
            child: Text('Camera'),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 10),
            onPressed: () {},
            child: Text('Create Product'),
          ),
        ],
      ),
    );
  }
}
