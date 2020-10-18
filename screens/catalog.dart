
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_shopper/models/cart.dart';
import 'package:provider_shopper/models/catalog.dart';

class MyCatalog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
          _MyAppBar(),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MyListItem(index)),
          ),
        ],
      ),
    );
  }
}

class _MyAppBar extends stateless widget{
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('Catalog', style: Theme.of(context).textTheme.headline1),
      floating: true,
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ],
    );
  }
}

class _MyListItem extends stateless widget{
    final int index;

   _MyListItem(this.index, {key key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
        //context.select to selectively listen to a specific part of the provider
        //returns an Item object from the catalog
        var item = context.select<CatalogModel, Item>(
            (catalog) => catalog.getByPosition(index),
    );
    var textTheme = Theme.of(context).textTheme.headline6;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: item.color,
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: Text(item.name, style: textTheme),
            ),
            SizedBox(width: 24),
            _AddButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends stateless widget{
  final Item item

  const _AddButton({key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      //returns a boolean object from the cart indicating if it is conmtained or not
      var isInCart = context.select<CartModel, bool>(
          (cart) => cart.items.contains(item),
          (catalog) => catalog.getByPosition(index),
    );

    return FlatButton(
      onPressed: isInCart
          ? null
          : () {
              //context.read as it should be donme outside the build method
              var cart = context.read<CartModel>();
              cart.add(item);
            },
      splashColor: Theme.of(context).primaryColor,
      child: isInCart ? Icon(Icons.check, semanticLabel: 'ADDED') : Text('ADD'),
    );
  }
}
