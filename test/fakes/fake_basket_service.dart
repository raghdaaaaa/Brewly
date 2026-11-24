import 'package:brewly/models/basket.dart';
import 'package:brewly/services/basket_service.dart';

/// Keeps basket changes in memory so widget tests never touch the network.
class FakeBasketService extends BasketService {
  FakeBasketService({List<BasketItem>? items}) {
    if (items != null) {
      _items.addAll(items);
    }
  }

  final List<BasketItem> _items = [];

  @override
  Future<CustomerBasket> getBasket() async {
    return CustomerBasket(id: 'fake-basket', items: List.of(_items));
  }

  @override
  Future<CustomerBasket> addItem({
    required int productId,
    int quantity = 1,
  }) async {
    final existingIndex = _items.indexWhere((item) => item.id == productId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity = quantity;
    } else {
      _items.add(
        BasketItem(
          id: productId,
          productName: 'Product $productId',
          pictureUrl: '',
          price: 95,
          quantity: quantity,
        ),
      );
    }
    return CustomerBasket(id: 'fake-basket', items: List.of(_items));
  }

  @override
  Future<CustomerBasket> addQuantity({
    required int productId,
    int quantity = 1,
  }) async {
    final existingIndex = _items.indexWhere(
      (item) => item.productId == productId,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        BasketItem(
          id: productId,
          productId: productId,
          productName: 'Product $productId',
          pictureUrl: '',
          price: 95,
          quantity: quantity,
        ),
      );
    }
    return CustomerBasket(id: 'fake-basket', items: List.of(_items));
  }

  @override
  Future<void> clearBasket() async {
    _items.clear();
  }
}
