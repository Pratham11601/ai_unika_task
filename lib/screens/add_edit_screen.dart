import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../widgets/constant_widgets.dart';
import '../controller/add_edit_controller.dart';
import '../controller/dashboard_controller.dart';
import '../models/course.dart';
import '../widgets/custom_button.dart';

class AddEditScreen extends GetView<AddEditController> {
  final Course? course;
  final int? index;

  AddEditScreen({super.key, this.course, this.index}) {
    if (!Get.isRegistered<AddEditController>()) {
      Get.put(AddEditController());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AddEditController>().init(course, index);
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isEdit = course != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Course' : 'Add Course')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter title' : null,
              ),
              height(1.5.h),

              TextFormField(
                controller: controller.descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                minLines: 2,
                maxLines: 4,
              ),
              height(1.5.h),


              Obx(() {
                DashboardController? dash =
                    Get.isRegistered<DashboardController>()
                        ? Get.find<DashboardController>()
                        : null;

                if (dash == null ||
                    (dash.isLoading.value && dash.categories.isEmpty)) {
                  return Center(child: CircularProgressIndicator());
                }

                final items = dash.categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList();

                return DropdownButtonFormField<String>(
                  initialValue: controller.selectedCategory.value,
                  items: items,
                  onChanged: (v) => controller.selectedCategory.value = v,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Select category' : null,
                );
              }),

              height(1.5.h),

              TextFormField(
                controller: controller.lessonsCtrl,
                decoration:
                const InputDecoration(labelText: 'Number of lessons'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) {
                    return 'Enter a valid number of lessons';
                  }
                  return null;
                },
              ),

              height(3.h),


              Obx(() => CustomButton(
                label: isEdit ? 'Save changes' : 'Add course',
                onPressed: controller.saving.value
                    ? null
                    : () {
                        if (!_formKey.currentState!.validate()) return;
                        controller.save();
                        Get.back();
                      },
                isLoading: controller.saving.value,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ))







            ],
          ),
        ),
      ),
    );
  }
}
