import 'models/address.dart';
import 'models/basket.dart';
import 'models/category.dart';
import 'models/delivery_method.dart';
import 'models/order.dart';
import 'models/product.dart';

// ---------------------------------------------------------------
// Hardcoded data. It is replaced by the real API in a later step.
// ---------------------------------------------------------------

const List<Category> dummyCategories = [
  Category(id: 0, name: 'All'),
  Category(id: 1, name: 'Hot Coffee'),
  Category(id: 2, name: 'Cold Brew'),
  Category(id: 3, name: 'Bakery'),
  Category(id: 4, name: 'Desserts'),
  Category(id: 5, name: 'Bowls'),
];

const List<Product> dummyProducts = [
  Product(
    id: 1,
    name: 'Spanish Iced Latte',
    description:
        'Slow-dripped Ethiopian espresso poured over cold milk and ice, '
        'finished with a thin layer of sweet cream.',
    price: 95,
    pictureUrl: 'https://picsum.photos/seed/brewly-latte/400/400',
    brandName: 'Brewly Lab',
    categoryName: 'Cold Brew',
  ),
  Product(
    id: 2,
    name: 'Pistachio Pain au Chocolat',
    description:
        'Laminated dough baked every morning, filled with dark chocolate '
        'and a pistachio cream.',
    price: 110,
    pictureUrl: 'https://picsum.photos/seed/brewly-pain/400/400',
    brandName: 'Brewly Roasters',
    categoryName: 'Bakery',
  ),
  Product(
    id: 3,
    name: 'Ethiopian V60',
    description:
        'A clean hand-poured filter coffee with notes of jasmine, peach '
        'and bergamot.',
    price: 85,
    pictureUrl: 'https://picsum.photos/seed/brewly-v60/400/400',
    brandName: 'Brewly Reserve',
    categoryName: 'Hot Coffee',
  ),
  Product(
    id: 4,
    name: 'Flat White',
    description:
        'A double shot of our house blend with silky steamed milk and a '
        'soft layer of micro foam.',
    price: 75,
    pictureUrl: 'https://picsum.photos/seed/brewly-flatwhite/400/400',
    brandName: 'Brewly Roasters',
    categoryName: 'Hot Coffee',
  ),
  Product(
    id: 5,
    name: 'Oat Milk Cappuccino',
    description:
        'Espresso, oat milk and a thick foam crown. Plant-based and '
        'comforting.',
    price: 90,
    pictureUrl: 'https://picsum.photos/seed/brewly-cappuccino/400/400',
    brandName: 'Brewly Lab',
    categoryName: 'Hot Coffee',
  ),
  Product(
    id: 6,
    name: 'Cold Brew Tonic',
    description:
        'Twelve-hour cold brew topped with tonic water and a slice of '
        'orange.',
    price: 105,
    pictureUrl: 'https://picsum.photos/seed/brewly-tonic/400/400',
    brandName: 'Brewly Reserve',
    categoryName: 'Cold Brew',
  ),
  Product(
    id: 7,
    name: 'Date & Tahini Cookie',
    description:
        'Chewy cookie with medjool dates, tahini and a pinch of sea salt.',
    price: 60,
    pictureUrl: 'https://picsum.photos/seed/brewly-cookie/400/400',
    brandName: 'Seven Fortunes',
    categoryName: 'Desserts',
  ),
  Product(
    id: 8,
    name: 'Halloumi Breakfast Bowl',
    description:
        'Grilled halloumi, avocado, cherry tomatoes and zaatar on a bed '
        'of greens.',
    price: 190,
    pictureUrl: 'https://picsum.photos/seed/brewly-bowl/400/400',
    brandName: 'Brewly Kitchen',
    categoryName: 'Bowls',
  ),
  Product(
    id: 9,
    name: 'Cinnamon Roll',
    description:
        'Soft brioche rolled with cinnamon sugar and finished with a '
        'cream cheese glaze.',
    price: 70,
    pictureUrl: 'https://picsum.photos/seed/brewly-roll/400/400',
    brandName: 'Artisan Bakery',
    categoryName: 'Bakery',
  ),
  Product(
    id: 10,
    name: 'Double Espresso',
    description:
        'Two short shots of our darkest roast. Rich, syrupy and sweet.',
    price: 55,
    pictureUrl: 'https://picsum.photos/seed/brewly-espresso/400/400',
    brandName: 'Nile Roasters',
    categoryName: 'Hot Coffee',
  ),
];

// ---------------------------------------------------------------
// Basket, address and delivery methods (still dummy).
// ---------------------------------------------------------------

// The basket is a normal list, so the Cart screen can change it.
// The API step will replace it with GET /api/Basket.
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

// ---------------------------------------------------------------
// Dummy user info for the Profile screen.
// The API step will replace it with GET /api/Account.
// ---------------------------------------------------------------
const String dummyUserEmail = 'omar.elsayed@brewly.com';

// ---------------------------------------------------------------
// Orders for the Orders screen (replaced by GET /api/Orders later).
// Total = item subtotal + Standard delivery (35).
// ---------------------------------------------------------------
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
