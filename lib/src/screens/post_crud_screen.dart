import 'dart:convert';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milike/src/provider/server_provider.dart';
import 'package:milike/src/utils/alert.dart';

class PostCrudScreen extends StatefulWidget {
  const PostCrudScreen({Key? key}) : super(key: key);

  @override
  _PostCrudScreenState createState() => _PostCrudScreenState();
}

class _PostCrudScreenState extends State<PostCrudScreen> {
  final _server = Server();
  final box = GetStorage();
  List posts = [];

  final _linkController = TextEditingController();
  final _descriptionController = TextEditingController();

  getPost() async {
    var result = await _server.getAllPosts();
    var response = jsonDecode(result.body);
    if (response['success'] == true) {
      setState(() {
        posts = response['data'];
      });
    } else if (response['message'] == 'Tiempo de espera excedido') {
      Alert.error(
          "El tiempo de espera a excedido. Verifique su conexion a internet.");
    } else {
      Alert.error(response['message'].toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red[800],
          title: const Text("Administrar Posts"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [const SizedBox(height: 15), body()],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            createPostDialog(context);
            await getPost();
          },
          backgroundColor: Colors.red[800],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget body() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: AnyLinkPreview(
            link: posts[index]['link'],
            displayDirection: UIDirection.uiDirectionHorizontal,
            cache: const Duration(hours: 1),
            backgroundColor: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            errorBody: 'No se encontro el enlace al post',
            errorWidget: Container(
              color: Colors.grey[300],
              child: const Text(
                  'Ocurrio un error, verifique su conexion a internet'),
            ),
          ),
          //subtitle: Text(posts[index]['descripcion']),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                  onTap: () {
                    print('Editar');
                  },
                  child: Icon(Icons.edit, color: Colors.blue[800])),
              const SizedBox(width: 10),
              InkWell(
                  onTap: () {
                    deletedFormDialog(context, posts[index]['id_post']);
                  },
                  child: Icon(Icons.delete, color: Colors.red[800])),
            ],
          ),
        );
      },
    );
  }

  createPostDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Crear Post',
              style: TextStyle(color: Color(0xff17324f), fontSize: 20),
            ),
            content: SizedBox(
                height: 250,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    TextField(
                      controller: _linkController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Link - url',
                        hintText: 'Link - url',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _descriptionController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Descripción',
                        hintText: 'Descripción',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _linkController.clear();
                            _descriptionController.clear();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[800]),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                          ),
                          onPressed: () async {
                            var data = {
                              'link': _linkController.text,
                              'description': _descriptionController.text
                            };
                            var result = await _server.createPost(data);
                            var response = jsonDecode(result.body);
                            if (response['success'] == true) {
                              await getPost();
                              _linkController.clear();
                              _descriptionController.clear();
                              Navigator.pop(context);
                              Alert.success(response['message'].toString());
                            } else if (response['message'] ==
                                'Tiempo de espera excedido') {
                              Alert.error(
                                  "El tiempo de espera a excedido. Verifique su conexion a internet.");
                            } else {
                              Alert.error(response['message'].toString());
                            }
                          },
                          child: const Text('Guardar'),
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }

  deletedFormDialog(BuildContext context, idPost) {
    return showDialog(
        context: context,
        builder: (param) {
          return AlertDialog(
            title: const Text(
              'Estas Seguro de eliminar?',
              style: TextStyle(color: Color(0xff17324f), fontSize: 20),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[800]),
                  onPressed: () async {
                    //delete
                    Navigator.pop(context);
                  },
                  child: const Text('Eliminar')),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[800]),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'))
            ],
          );
        });
  }
}
