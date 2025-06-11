// import 'package:aco_plus/app/core/components/h.dart';
// import 'package:aco_plus/app/core/utils/app_colors.dart';
// import 'package:aco_plus/app/core/utils/app_css.dart';
// import 'package:aco_plus/app/core/utils/global_resource.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// enum RelatorioOrdensPdfExportarTipo { completo, resumido }

// extension RelatorioOrdensPdfExportarTipoExtension
//     on RelatorioOrdensPdfExportarTipo {
//   String get label => switch (this) {
//     RelatorioOrdensPdfExportarTipo.completo => 'Completo',
//     RelatorioOrdensPdfExportarTipo.resumido => 'Resumido',
//   };

//   String get descricao => switch (this) {
//     RelatorioOrdensPdfExportarTipo.completo =>
//       'Relatório completo com todas as bitolas',
//     RelatorioOrdensPdfExportarTipo.resumido =>
//       'Relatório resumido sem as bitolas',
//   };

//   IconData get icon => switch (this) {
//     RelatorioOrdensPdfExportarTipo.completo => Icons.description,
//     RelatorioOrdensPdfExportarTipo.resumido => Icons.description_outlined,
//   };
// }

// Future<RelatorioOrdensPdfExportarTipo?>
// showRelatorioOrdensPdfExportarTipoBottom() async => showModalBottomSheet(
//   backgroundColor: AppColors.white,
//   context: contextGlobal,
//   isScrollControlled: true,
//   builder: (_) => const RelatorioOrdensPdfExportarTipoBottom(),
// );

// class RelatorioOrdensPdfExportarTipoBottom extends StatefulWidget {
//   const RelatorioOrdensPdfExportarTipoBottom({super.key});

//   @override
//   State<RelatorioOrdensPdfExportarTipoBottom> createState() =>
//       _RelatorioOrdensPdfExportarTipoBottomState();
// }

// class _RelatorioOrdensPdfExportarTipoBottomState
//     extends State<RelatorioOrdensPdfExportarTipoBottom> {
//   @override
//   Widget build(BuildContext context) {
//     return BottomSheet(
//       onClosing: () {},
//       builder: (context) => KeyboardVisibilityBuilder(
//         builder: (context, isVisible) {
//           return Container(
//             height: 300,
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(24),
//                 topRight: Radius.circular(24),
//               ),
//             ),
//             child: ListView(
//               children: [
//                 const H(16),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8),
//                     child: IconButton(
//                       style: ButtonStyle(
//                         padding: const WidgetStatePropertyAll(
//                           EdgeInsets.all(16),
//                         ),
//                         backgroundColor: WidgetStatePropertyAll(
//                           AppColors.white,
//                         ),
//                         foregroundColor: WidgetStatePropertyAll(
//                           AppColors.black,
//                         ),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.keyboard_backspace),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Selecione o tipo de relatório',
//                         style: AppCss.largeBold,
//                       ),
//                       const H(16),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           for (var tipo
//                               in RelatorioOrdensPdfExportarTipo.values)
//                             ListTile(
//                               leading: Icon(tipo.icon, size: 24),
//                               title: Text(tipo.label, style: AppCss.largeBold),
//                               subtitle: Text(
//                                 tipo.descricao,
//                                 style: AppCss.minimumRegular,
//                               ),
//                               trailing: Icon(
//                                 Icons.arrow_forward_ios,
//                                 size: 12,
//                                 color: Colors.grey,
//                               ),
//                               onTap: () => Navigator.pop(context, tipo),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
