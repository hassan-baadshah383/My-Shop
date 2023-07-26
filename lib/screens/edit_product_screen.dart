import 'package:flutter/material.dart';
import 'package:my_shop/provider/auth.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/editProductScreen';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var product =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  bool edit = true;
  bool _isLoading = false;
  var existingProduct = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    _imageUrlFocus.addListener(updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (edit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        product = Provider.of<Products>(context, listen: false)
            .findProduct(productId);
        existingProduct = {
          'id': product.id,
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': ''
        };
        _imageController.text = product.imageUrl;
      }
    }
    edit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(updateImage);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocus.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void updateImage() {
    if (!_imageUrlFocus.hasFocus) {
      if ((_imageController.text.isEmpty) ||
          (!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('jpg') &&
              !_imageController.text.endsWith('jpeg') &&
              !_imageController.text.endsWith('png'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _submitForm() async {
    final validate = _form.currentState.validate();
    if (!validate) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (product.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(product, product.id);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        final userId = Provider.of<Auth>(context, listen: false).userId;
        await Provider.of<Products>(context, listen: false).addProduct(
          product,
          userId,
        );
      } catch (error) {
        await showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title: const Text('An Error Occured!'),
                content: const Text('Something went wrong.'),
                actions: [
                  ElevatedButton(
                      onPressed: (() => Navigator.of(context).pop()),
                      child: const Text('Okay'))
                ],
              );
            }));
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [
            IconButton(onPressed: _submitForm, icon: const Icon(Icons.save))
          ],
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: existingProduct['title'],
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.title),
                            labelText: 'Title',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          onSaved: ((newValue) {
                            product = Product(
                                id: product.id,
                                title: newValue.toString(),
                                description: product.description,
                                price: product.price,
                                imageUrl: product.imageUrl);
                          }),
                        ),
                        TextFormField(
                          initialValue: existingProduct['price'],
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.money_off),
                            labelText: 'Price',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid value';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter price greater than 0';
                            }
                            return null;
                          },
                          onSaved: ((newValue) {
                            product = Product(
                                id: product.id,
                                title: product.title,
                                description: product.description,
                                price: double.parse(newValue),
                                imageUrl: product.imageUrl);
                          }),
                        ),
                        TextFormField(
                          initialValue: existingProduct['description'],
                          focusNode: _descriptionFocusNode,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.description),
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.length < 10) {
                              return 'Should be atleast 10 characters long';
                            }
                            return null;
                          },
                          onSaved: ((newValue) {
                            product = Product(
                                id: product.id,
                                title: product.title,
                                description: newValue.toString(),
                                price: product.price,
                                imageUrl: product.imageUrl);
                          }),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                height: 100,
                                width: 100,
                                margin:
                                    const EdgeInsets.only(top: 25, right: 15),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: _imageController.text.isEmpty
                                    ? const Center(
                                        child: Text(
                                        'Enter the URL',
                                        style: TextStyle(fontSize: 12),
                                      ))
                                    : FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.network(
                                            _imageController.text),
                                      )),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.go,
                                decoration:
                                    const InputDecoration(labelText: 'URL'),
                                controller: _imageController,
                                focusNode: _imageUrlFocus,
                                onFieldSubmitted: (_) {
                                  if ((_imageController.text.isEmpty) ||
                                      (!_imageController.text
                                              .startsWith('http') &&
                                          !_imageController.text
                                              .startsWith('https')) ||
                                      (!_imageController.text.endsWith('jpg') &&
                                          !_imageController.text
                                              .endsWith('jpeg') &&
                                          !_imageController.text
                                              .endsWith('png'))) {
                                    return;
                                  }
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a URL';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return 'Enter a valid URL';
                                  }
                                  if (!value.endsWith('jpeg') &&
                                      !value.endsWith('png') &&
                                      !value.endsWith('jpg')) {
                                    return 'Enter a valid URL';
                                  }
                                  return null;
                                },
                                onSaved: ((newValue) {
                                  product = Product(
                                      id: product.id,
                                      title: product.title,
                                      description: product.description,
                                      price: product.price,
                                      imageUrl: newValue.toString());
                                }),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  shadowColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                              child: const Text('Submit')),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
