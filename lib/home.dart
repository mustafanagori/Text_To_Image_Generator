import 'package:ai_txt_img/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    ImageController imageController = Get.put(ImageController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text To Image Generator"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: h * 0.02, horizontal: w * 0.02),
        child: Obx(
          () => Column(
            children: [
              SizedBox(
                height: h * 0.005,
              ),
              TextFormField(
                focusNode: imageController.textFocusNode,
                controller: imageController.promptController,
                decoration: InputDecoration(
                  labelText: "Enter text to Generate Image",
                  suffixIcon: const Icon(Icons.generating_tokens),
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await imageController.textToImage();
                    },
                    icon: const Icon(Icons.generating_tokens_rounded),
                    label: const Text("Generate Image ")),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        child: imageController.isProcessing
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  for (final imageData
                                      in imageController.imageData)
                                    Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Image.memory(imageData))),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
