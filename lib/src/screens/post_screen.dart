import 'dart:convert';
import 'dart:typed_data';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milike/src/provider/server_provider.dart';
import 'package:milike/src/utils/alert.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<PostScreen> with TickerProviderStateMixin {
  final _server = Server();
  List posts = [];

  List facebook = [];
  List twitter = [];
  List tiktok = [];
  List youtube = [];

  Uint8List? _imageBytes;
  String? _imageName;

  getPost() async {
    var result = await _server.getPosts();
    var response = jsonDecode(result.body);
    if (response['success'] == true) {
      setState(() {
        posts = response['data'];
        for (int i = 0; i < posts.length; i++) {
          print(posts[i]['red_social']);
          if (posts[i]['red_social'] == 'Facebook') {
            facebook.add(posts[i]);
          } else if (posts[i]['red_social'] == 'X') {
            twitter.add(posts[i]);
          } else if (posts[i]['red_social'] == 'Tiktok') {
            tiktok.add(posts[i]);
          } else if (posts[i]['red_social'] == 'Youtube') {
            youtube.add(posts[i]);
          }
        }
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
    return PopScope(canPop: false, child: Scaffold(body: Cabecera()));
  }

  Widget Cabecera() {
    TabController tabController = TabController(length: 4, vsync: this);
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.red[800],
                ),
                controller: tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(horizontal: 25),
                tabs: const [
                  Tab(
                    child: Text("Facebook"),
                  ),
                  Tab(
                    child: Text("Tiktok"),
                  ),
                  Tab(
                    child: Text("X"),
                  ),
                  Tab(
                    child: Text("Youtube"),
                  ),
                ],
              )),
        ),
        Expanded(
            child: TabBarView(controller: tabController, children: [
          body(facebook),
          body(tiktok),
          body(twitter),
          body(youtube)
        ])),
      ],
    );
  }

  Widget body(List postX) {
    return postX.isEmpty
        ? Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/empty.jpg',
                ),
                const SizedBox(height: 10),
                const Text(
                  'No hay mas Posts!.',
                  style: TextStyle(
                    color: Color.fromARGB(234, 173, 173, 180),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                )
              ],
            ))
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: postX.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: AnyLinkPreview(
                    link: postX[index]['link'],
                    displayDirection: UIDirection.uiDirectionHorizontal,
                    cache: const Duration(hours: 1),
                    backgroundColor: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    errorBody: 'No se encontro el enlace al post',
                    errorWidget: Container(
                      color: Colors.grey[300],
                      child: const Text(
                          'Ocurrio un error, verifique su conexion a internet'),
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () async {
                      await _pickImage();
                      if (_imageBytes == null) {
                        Alert.error(
                          "Por favor seleccione una imagen para subir.",
                        );
                      } else {
                        var datos = {
                          'filename': _imageName,
                          'imagenHex': _bytesToHex(_imageBytes!),
                          'id_post': postX[index]['id_post']
                        };
                        var response = await _server.createReaccion(datos);
                        var reaccion = jsonDecode(response.body);
                        if (reaccion['success'] == true) {
                          facebook = [];
                          tiktok = [];
                          twitter = [];
                          youtube = [];
                          Alert.success(reaccion['message'].toString());
                          await getPost();
                        } else if (reaccion['message'] ==
                            'Tiempo de espera excedido') {
                          Alert.error(
                              "El tiempo de espera a excedido. Verifique su conexion a internet.");
                        } else {
                          Alert.error(reaccion['message'].toString());
                        }
                      }
                    },
                    child: SizedBox(
                      height: double.infinity,
                      child: Transform.scale(
                          scale: 2.5,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.upload_file,
                            color: Colors.green[400],
                          )),
                    ),
                  ));
            },
          );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      var imageName = image.name;
      print(imageName);
      var imageBytes = await image.readAsBytes()
          as Uint8List?; // Obtener los bytes de la imagen
      print(imageBytes);
      setState(() {
        _imageBytes = imageBytes;
        _imageName = imageName;
      });
    }
  }

  String _bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
}
