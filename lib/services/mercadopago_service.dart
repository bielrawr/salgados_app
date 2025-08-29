
import 'package:cloud_functions/cloud_functions.dart';
import 'package:salgados_app/models/item_carrinho.dart';

class MercadoPagoService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance; // Use a região correta se for diferente

  Future<String?> createPaymentPreference({
    required List<ItemCarrinho> items,
  }) async {
    try {
      // Formata os itens para o formato que a Cloud Function espera
      final List<Map<String, dynamic>> formatedItems = items
          .map((item) => {
                'title': item.produto.nome,
                'quantity': item.quantidade,
                'unit_price': item.produto.preco,
              })
          .toList();

      final HttpsCallable callable = _functions.httpsCallable('createPaymentPreference');
      final response = await callable.call({'items': formatedItems});

      // A Cloud Function retorna o initPoint (URL de checkout)
      if (response.data != null && response.data['initPoint'] != null) {
        return response.data['initPoint'];
      }
    } on FirebaseFunctionsException catch (e) {
      print('Erro ao chamar Cloud Function: ${e.code} - ${e.message}');
    } catch (e) {
      print('Erro inesperado: $e');
    }
    return null;
  }
}
