import 'package:clean_architecture_tdd_solid/infra/http/http.dart';
import 'package:http/http.dart';

HttpAdapter makeHttpAdapter() {
  final Client client = Client();
  return HttpAdapter(client);
}
