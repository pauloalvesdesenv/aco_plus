import 'package:aco_plus/app/modules/cliente/ui/clientes_page.dart';
import 'package:aco_plus/app/modules/dashboard/ui/dashboard_page.dart';
import 'package:aco_plus/app/modules/fabricante/ui/fabricantes_page.dart';
import 'package:aco_plus/app/modules/kanban/ui/kanban_page.dart';
import 'package:aco_plus/app/modules/materia_prima/ui/materias_primas_page.dart';
import 'package:aco_plus/app/modules/ordem/ui/ordens_page.dart';
import 'package:aco_plus/app/modules/pedido/ui/pedidos_page.dart';
import 'package:aco_plus/app/modules/produto/ui/produtos_page.dart';
import 'package:aco_plus/app/modules/relatorio/ui/ordem/relatorios_ordem_page.dart';
import 'package:aco_plus/app/modules/relatorio/ui/pedido/relatorios_pedido_page.dart';
import 'package:aco_plus/app/modules/step/ui/steps_page.dart';
import 'package:aco_plus/app/modules/tag/ui/tags_page.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

enum AppModule {
  dashboard,
  kanban,
  pedidos,
  ordens,
  pedidoRelatorio,
  ordemRelatorio,
  cliente,
  steps,
  tags,
  fabricantes,
  produtos,
  materiaPrima,
}

extension AppModuleExt on AppModule {
  Widget get widget {
    switch (this) {
      case AppModule.dashboard:
        return const DashboardPage();
      case AppModule.cliente:
        return const ClientesPage();
      case AppModule.pedidos:
        return const PedidosPage();
      case AppModule.ordens:
        return const OrdensPage();
      case AppModule.pedidoRelatorio:
        return const RelatoriosPedidoPage();
      case AppModule.ordemRelatorio:
        return const RelatoriosOrdemPage();
      case AppModule.steps:
        return const StepsPage();
      case AppModule.tags:
        return const TagsPage();
      case AppModule.kanban:
        return const KanbanPage();
      case AppModule.fabricantes:
        return const FabricantesPage();
      case AppModule.produtos:
        return const ProdutosPage();
      case AppModule.materiaPrima:
        return const MateriasPrimasPage();
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.dashboard:
        return Icons.dashboard_outlined;
      case AppModule.cliente:
        return Icons.group_outlined;
      case AppModule.pedidos:
        return Icons.shopping_cart_outlined;
      case AppModule.ordens:
        return (usuarioCtrl.usuario?.isNotOperador ?? false)
            ? Icons.list
            : Icons.work_outline;
      case AppModule.pedidoRelatorio:
        return Icons.shopping_cart_outlined;
      case AppModule.ordemRelatorio:
        return Icons.work_outline;
      case AppModule.steps:
        return Icons.list_alt_outlined;
      case AppModule.tags:
        return Icons.label_outlined;
      case AppModule.kanban:
        return Symbols.view_kanban;
      case AppModule.fabricantes:
        return Icons.business_outlined;
      case AppModule.produtos:
        return Icons.inventory_2_outlined;
      case AppModule.materiaPrima:
        return Icons.warehouse_outlined;
    }
  }

  String get label {
    switch (this) {
      case AppModule.dashboard:
        return 'Dashboard';
      case AppModule.cliente:
        return 'Clientes';
      case AppModule.pedidos:
        return 'Pedidos';
      case AppModule.ordens:
        return (usuarioCtrl.usuario?.isNotOperador ?? false)
            ? 'Lista'
            : 'Ordens';
      case AppModule.ordemRelatorio:
        return 'Ordens de Produção';
      case AppModule.pedidoRelatorio:
        return 'Pedidos';
      case AppModule.steps:
        return 'Etapas';
      case AppModule.kanban:
        return 'Kanban';
      case AppModule.tags:
        return 'Etiquetas';
      case AppModule.fabricantes:
        return 'Fabricantes';
      case AppModule.produtos:
        return 'Produtos';
      case AppModule.materiaPrima:
        return 'Materia Prima';
    }
  }
}
