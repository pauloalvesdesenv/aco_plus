enum ProdutoProduzido { day, week, month }

class ProdutoProduzidoModel {
  final DateTime date;
  double qtde;
  ProdutoProduzidoModel({
    required this.date,
    required this.qtde,
  });
}
