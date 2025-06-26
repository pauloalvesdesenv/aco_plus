import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/relatorio/ui/ordem/relatorios_ordem_page.dart';
import 'package:aco_plus/app/modules/relatorio/ui/pedido/relatorios_pedido_page.dart';
import 'package:flutter/material.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  @override
  void initState() {
    setWebTitle('Relatórios');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.white),
        ),
        title: Text(
          'Relatórios',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        backgroundColor: AppColors.primaryMain,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Relatório de Pedidos'),
            onTap: () => push(context, const RelatoriosPedidoPage()),
            leading: const Icon(Icons.shopping_cart_outlined),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 16,
            ),
          ),
          const Divisor(),
          ListTile(
            title: const Text('Relatório de Ordens'),
            onTap: () => push(context, const RelatoriosOrdemPage()),
            leading: const Icon(Icons.work_outline),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
