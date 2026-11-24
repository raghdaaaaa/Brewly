import '../../models/address.dart';
import '../../models/basket.dart';
import '../../models/delivery_method.dart';
import '../../models/order.dart';

/// Fixed ratings shown on the Home cards only (the API has no rating field).
const List<double> homeRatings = [4.9, 4.8, 5.0, 4.7];

final List<BasketItem> dummyBasketItems = [
  BasketItem(
    id: 1,
    productName: 'Spanish Iced Latte',
    pictureUrl: 'https://picsum.photos/seed/brewly-latte/400/400',
    price: 95,
    quantity: 2,
  ),
  BasketItem(
    id: 2,
    productName: 'Pistachio Pain au Chocolat',
    pictureUrl: 'https://picsum.photos/seed/brewly-pain/400/400',
    price: 110,
    quantity: 1,
  ),
];

const Address dummyAddress = Address(
  firstName: 'Omar',
  lastName: 'El-Sayed',
  street: '14 Gezira St, Apt 4B',
  city: 'Cairo',
  country: 'Egypt',
);

const int dummyLoyaltyPoints = 340;

const List<DeliveryMethod> dummyDeliveryMethods = [
  DeliveryMethod(
    id: 1,
    shortName: 'Standard delivery',
    description: 'Door delivery',
    cost: 35,
    deliveryTime: '2-4 days',
  ),
  DeliveryMethod(
    id: 2,
    shortName: 'Express delivery',
    description: 'Door delivery',
    cost: 60,
    deliveryTime: 'Same day',
  ),
  DeliveryMethod(
    id: 3,
    shortName: 'Pickup from shop',
    description: 'Collect it yourself',
    cost: 0,
    deliveryTime: '30 min',
  ),
];

const List<Order> dummyOrders = [
  Order(
    id: 'ORD-1001',
    orderDate: '2026-11-20',
    status: 'In preparation',
    total: 295,
    items: [
      OrderItem(
        name: 'Flat White',
        pictureUrl: 'https://picsum.photos/seed/brewly-flatwhite/400/400',
        price: 75,
        quantity: 2,
      ),
      OrderItem(
        name: 'Pistachio Pain au Chocolat',
        pictureUrl: 'https://picsum.photos/seed/brewly-pain/400/400',
        price: 110,
        quantity: 1,
      ),
    ],
  ),
  Order(
    id: 'ORD-1002',
    orderDate: '2026-11-17',
    status: 'Delivered',
    total: 225,
    items: [
      OrderItem(
        name: 'Halloumi Breakfast Bowl',
        pictureUrl: 'https://picsum.photos/seed/brewly-bowl/400/400',
        price: 190,
        quantity: 1,
      ),
    ],
  ),
  Order(
    id: 'ORD-1003',
    orderDate: '2026-11-15',
    status: 'Cancelled',
    total: 145,
    items: [
      OrderItem(
        name: 'Double Espresso',
        pictureUrl: 'https://picsum.photos/seed/brewly-espresso/400/400',
        price: 55,
        quantity: 2,
      ),
    ],
  ),
];
