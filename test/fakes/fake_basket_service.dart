import 'package:brewly/models/basket.dart';
import 'package:brewly/models/product.dart';
import 'package:brewly/services/basket_service.dart';

class FakeBasketService extends BasketService {
  FakeBasketService({List<BasketItem>? items}) {
    if (items != null) {
      _items.addAll(items);
    }
  }

  final List<BasketItem> _items = [];

  @override
  Future<CustomerBasket> getBasket() async {
    _publish();
    return CustomerBasket(id: '', items: List.of(_items));
  }

  @override
  Future<CustomerBasket> addItem({
    required Product product,
    int quantity = 1,
  }) async {
    return addQuantity(product: product, quantity: quantity);
  }

  @override
  Future<CustomerBasket> addQuantity({
    required Product product,
    int quantity = 1,
  }) async {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == product.id,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        BasketItem(
          id: product.id,
          productId: product.id,
          productName: product.name,
          pictureUrl: product.pictureUrl,
          price: product.price,
          quantity: quantity,
        ),
      );
    }
    _publish();
    return CustomerBasket(id: '', items: List.of(_items));
  }

  @override
  Future<CustomerBasket> updateItemQuantity({
    required int productId,
    required int quantity,
  }) async {
    if (quantity == 0) {
      return removeItem(productId: productId);
    }
    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity = quantity;
    }
    _publish();
    return CustomerBasket(id: '', items: List.of(_items));
  }

  @override
  Future<CustomerBasket> removeItem({required int productId}) async {
    _items.removeWhere((item) => item.productId == productId);
    _publish();
    return CustomerBasket(id: '', items: List.of(_items));
  }

  void _publish() {
    BasketService.itemCount.value = _items.fold(
      0,
      (count, item) => count + item.quantity,
    );
    BasketService.total.value = _items.fold(
      0,
      (sum, item) => sum + item.lineTotal,
    );
  }

  @override
  Future<void> clearBasket() async {
    _items.clear();
    _publish();
  }
}
