import 'dart:ui';

import 'package:clean_architecture_tdd_solid/ui/helpers/i18n/strings/en_us.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/i18n/strings/pt_br.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/i18n/strings/translations.dart';

//Não implementei a tradução em todos os lugares, apenas no button do login_page para ver o processo.

class R {
  static Translations string = PtBr();

  static void load(Locale locale) {
    switch (locale.toString()) {
      case "en_US":
        string = EnUs();
        break;
      default:
        string = PtBr();
        break;
    }
  }
}
