import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/extensions/string_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<PedidoModel?> showPedidoSelectBottom(List<PedidoModel> pedidos) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => PedidoSelectBottom(pedidos),
    );

class PedidoSelectBottom extends StatefulWidget {
  final List<PedidoModel> pedidos;
  const PedidoSelectBottom(this.pedidos, {super.key});

  @override
  State<PedidoSelectBottom> createState() => _PedidoSelectBottomState();
}

class _PedidoSelectBottomState extends State<PedidoSelectBottom> {
  final TextEditingController _searchController = TextEditingController();
  List<PedidoModel> _filteredPedidos = [];

  @override
  void initState() {
    super.initState();
    _filteredPedidos = widget.pedidos;
    _searchController.addListener(_filterPedidos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPedidos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPedidos = widget.pedidos;
      } else {
        _filteredPedidos = widget.pedidos.where((pedido) {
          return pedido.localizador.toCompare.contains(query.toCompare);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.white,
      onClosing: () {},
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return Container(
            height: 600,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const H(16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.all(16),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.white,
                        ),
                        foregroundColor: WidgetStatePropertyAll(
                          AppColors.black,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.keyboard_backspace),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecione um pedido para vincular',
                          style: AppCss.largeBold.setColor(AppColors.black),
                        ),
                        const H(16),
                        // Search field
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFC3CBD3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText:
                                  'Buscar por localizador ou descrição...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.neutralMedium,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const H(16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFC3CBD3)),
                            ),
                            child: _filteredPedidos.isEmpty
                                ? Center(
                                    child: Text(
                                      'Nenhum pedido encontrado',
                                      style: AppCss.mediumRegular.setColor(
                                        AppColors.neutralMedium,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _filteredPedidos.length,
                                    separatorBuilder: (_, __) =>
                                        const Divisor(),
                                    itemBuilder: (_, i) => PedidoItemWidget(
                                      info: PedidoItemInfo.minified,
                                      onTap: (pedido) =>
                                          Navigator.pop(context, pedido),
                                      pedido: _filteredPedidos[i],
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
