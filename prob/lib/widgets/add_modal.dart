// import 'package:flutter/material.dart';
// import 'history_control_btn.dart';

// class AddModal extends StatelessWidget {
//   const AddModal({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         HistoryControlBtn(
//           label: "추가",
//           method: () => _showCategoryDialog(context),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   void _showCategoryDialog(BuildContext context) {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => const CategoryModal(
//         onCategorySelected: _showAddDialog,
//       ),
//     );
//   }

//   static void _showAddDialog(BuildContext context) {
//     showDialog<String>(
//       context: context,
//       builder: (BuildContext context) => Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Text('상세내용'),
//               const SizedBox(height: 15),
//               const TextField(
//                 decoration: InputDecoration(
//                   labelText: '소비한 회사는?',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const TextField(
//                 decoration: InputDecoration(
//                   labelText: '비용',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               // const TextField(
//               //   decoration: InputDecoration(
//               //     labelText: '날짜',
//               //     border: OutlineInputBorder(),
//               //   ),
//               // ),
//               // const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('취소'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Text('저장'),
//                   ),
//                   const SizedBox(width: 8),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CategoryModal extends StatefulWidget {
//   final Function(BuildContext) onCategorySelected;

//   const CategoryModal({super.key, required this.onCategorySelected});

//   @override
//   _CategoryModalState createState() => _CategoryModalState();
// }

// class _CategoryModalState extends State<CategoryModal> {
//   String _selectedCategory = '식사';
//   late Future<List<CategoryModel>> categoryList;
//   //final List<String> _categories = ['Food', 'Cafe', 'Exercise'];
//   final TextEditingController _categoryController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     categoryList = SqfliteControl.getAllCategory();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const Text('카테고리'),
//             const SizedBox(height: 15),
//             FutureBuilder<List<CategoryModel>>(
//               future: categoryList,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (snapshot.hasData) {
//                   final categories = snapshot.data!;
//                   return Column(
//                     children: categories
//                         .map((category) => GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedCategory = category.name;
//                                 });
//                               },
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 2),
//                                 child: Container(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 10),
//                                   color: Colors.transparent,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         category.name,
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                           color:
//                                               _selectedCategory == category.name
//                                                   ? Colors.blue
//                                                   : Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ))
//                         .toList(),
//                   );
//                 } else {
//                   return const Text('No categories available');
//                 }
//               },
//             ),
//             const SizedBox(height: 15),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     showDialog<String>(
//                       context: context,
//                       builder: (BuildContext context) => Dialog(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               TextField(
//                                 controller: _categoryController,
//                                 textAlign: TextAlign.center,
//                                 decoration: const InputDecoration(
//                                   labelText: 'New Category',
//                                   border: OutlineInputBorder(),
//                                 ),
//                               ),
//                               const SizedBox(height: 15),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text('Cancel'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       if (_categoryController.text.isNotEmpty) {
//                                         SqfliteControl.addCategory(
//                                             _categoryController.text);
//                                         setState(() {
//                                           categoryList =
//                                               SqfliteControl.getAllCategory();
//                                         });
//                                         _categoryController.clear();
//                                         Navigator.pop(context);
//                                       }
//                                     },
//                                     child: const Text('Add'),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text('카테고리 추가'),
//                 ),
//                 const SizedBox(width: 8),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     widget.onCategorySelected(context);
//                   },
//                   child: const Text('다음'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
