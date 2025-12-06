import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:task_round/utils/text_styles.dart';
import '../widgets/constant_widgets.dart';
import '../controller/dashboard_controller.dart';
import '../routes/routes.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.EDIT_ADD_COURSE_SCREEN),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Obx(() => TextField(
                  onChanged: controller.setSearch,
                  decoration: InputDecoration(
                    hintText: 'Search courses',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => controller.setSearch(''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )),
            height(1.5.h),

            Obx(() {
              final cats = controller.categories;
              return SizedBox(
                height: 6.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    width(1.w),
                    ChoiceChip(
                      label: Text('All',style: TextHelper.size16,),
                      selected: controller.selectedCategory.value == null,
                      onSelected: (_) => controller.setCategory(null),
                    ),
                    width(2.w),
                    ...cats.map((c) {
                      final selected = controller.selectedCategory.value == c;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(c,style: TextHelper.size16),
                          selected: selected,
                          onSelected: (_) => controller.setCategory(selected ? null : c),
                        ),
                      );
                    }),
                    width(2.w),
                    TextButton(
                      onPressed: controller.clearFilters,
                      child: const Text('Clear'),
                    )
                  ],
                ),
              );
            }),
            height(1.5.h),

            Expanded(
              child: Obx(() {
                final list = controller.filtered;
                Widget content;
                if (controller.isLoading.value && list.isEmpty) {
                  content = ListView.separated(
                    itemCount: 4,
                    separatorBuilder: (_, _) => height(1.h),
                    itemBuilder: (context, index) => Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 0.5.h),
                    ),
                  );
                } else if (list.isEmpty) {
                  content = Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey.shade400),
                        height(1.5.h),
                        Text('No courses yet', style: Theme.of(context).textTheme.titleMedium),
                        height(0.8.h),
                        Text('You have not added any courses. Try adding some or clear filters.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall),
                        height(1.5.h),
                        ElevatedButton(
                          onPressed: controller.loadCourses,
                          child: const Text('Reload courses'),
                        )
                      ],
                    ),
                  );
                } else {
                  
                  content = ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => height(1.h),
                    itemBuilder: (context, index) {
                      final c = list[index];
                      final origIndex = controller.courses.indexOf(c);
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                            onTap: () => Get.toNamed(
                              Routes.EDIT_ADD_COURSE_SCREEN,
                              arguments: {'course': c, 'index': origIndex}),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "Score: ",
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${c.score}",
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )



                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [


                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Chip(label: Text(c.category)),
                                  height(0.8.h),


                                ],
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    Get.toNamed(
                                      Routes.EDIT_ADD_COURSE_SCREEN,
                                      arguments: {'course': c, 'index': origIndex},
                                    );
                                  } else if (value == 'delete') {
                                    final confirmed = await Get.defaultDialog<bool>(
                                      title: 'Delete',
                                      middleText: 'Are you sure you want to delete this course?',
                                      textConfirm: 'Delete',
                                      textCancel: 'Cancel',
                                      confirmTextColor: Colors.white,
                                      onConfirm: () {
                                        Get.back(result: true);
                                      },
                                      onCancel: () {
                                        Get.back(result: false);
                                      },
                                    );
                                    if (confirmed == true) {
                                      await controller.deleteCourse(origIndex);
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadCourses,
                  child: content,
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

