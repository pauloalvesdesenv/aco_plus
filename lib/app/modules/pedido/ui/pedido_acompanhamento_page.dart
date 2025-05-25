import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_desc_widget.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_timeline_acompanhamento_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

// '/acompanhamento/pedido/0VO0BCbtfKlAkAVzqtpZd0V8m'
class PedidoAcompanhamentoPage extends StatefulWidget {
  final String id;

  const PedidoAcompanhamentoPage({required this.id, super.key});

  @override
  State<PedidoAcompanhamentoPage> createState() =>
      _PedidoAcompanhamentoPageState();
}

class _PedidoAcompanhamentoPageState extends State<PedidoAcompanhamentoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    pedidoCtrl.onInitPage(FirestoreClient.pedidos.getById(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String promoveText =
        'Acompanhe seu Pedido na M2 Ferro e Aço através do link: https://aco-plus-fa455.web.app/acompanhamento/pedidos/${pedido.id}';
    return StreamOut(
      stream: pedidoCtrl.pedidoStream.listen,
      builder: (_, pedido) => AppScaffold(
        appBar: AppBar(
          title: Text(
            'Acompanhamento de Pedido',
            style: AppCss.largeBold.setColor(AppColors.white),
          ),
          backgroundColor: AppColors.primaryMain,
          actions: [
            IconButton(
              onPressed: () async => Clipboard.setData(
                ClipboardData(
                  text:
                      'https://aco-plus-fa455.web.app/acompanhamento/pedidos/${pedido.id}',
                ),
              ),
              icon: Icon(Icons.copy, color: AppColors.white),
            ),
            const W(12),
            IconButton(
              onPressed: () async => Share.share(promoveText),
              icon: Icon(Icons.share, color: AppColors.white),
            ),
            const W(12),
            IconButton(
              onPressed: () async =>
                  launchUrlString("https://wa.me/?text=$promoveText"),
              icon: Icon(Icons.phone, color: AppColors.white),
            ),
            const W(16),
          ],
        ),
        resizeAvoid: true,
        body: body(pedido),
      ),
    );
  }

  Widget body(PedidoModel pedido) {
    return Column(
      children: [
        PedidoDescWidget(pedido),
        const Divisor(),
        if (pedido.histories.isNotEmpty)
          Expanded(child: PedidoTimelineAcompanhamentoWidget(pedido: pedido)),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
