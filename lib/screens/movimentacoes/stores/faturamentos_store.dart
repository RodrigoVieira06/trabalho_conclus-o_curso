import 'package:flutter_triple/flutter_triple.dart';
import 'package:projeto_controle_financeiro/models/models.dart';
import 'package:projeto_controle_financeiro/services/services.dart';

class FaturamentosStore extends NotifierStore<Exception, List<Faturamento>> {
  final MovimentacoesService movimentacoesService = MovimentacoesService();

  FaturamentosStore() : super([]) {
    getFaturamentos();
  }

  getFaturamentos() async {
    try {
      setLoading(true);
      List<Faturamento> faturamentos =
          await movimentacoesService.getFaturamentos();
      update(faturamentos);
      setLoading(false);
    } catch (error) {
      setError(Exception(error));
    }
  }
}