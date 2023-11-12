import 'dart:io';

import 'package:flutter/material.dart';

const baseUrl = String.fromEnvironment('BASE_URL');
const cnpj = String.fromEnvironment('CNPJ');

const pathNoNet = 'assets/images/noNet.json';

const keyLocalStorageUser = 'userApp';
const versionApp = 'Versão 1.0.0';

const backgroundBlack = Color(0xFF202123);
const labelPapagaio = Color(0xFF009342);
const labelRed = Color(0xffCB5252);

const urlRegister = 'AppCashBack/setJson/$cnpj/usuarios';
const urlVerifyCPF = 'AppCashBack/getJson/$cnpj/usuarios';
const urlLogin = 'AppCashBack/login/$cnpj';
const urlPointsBalance = 'AppCashBack/getJson/$cnpj/pontos';
const urlHistorics = 'AppCashBack/getJson/$cnpj/mov';
const urlHistoricsPoints = 'AppCashBack/getJson/$cnpj/historico';
const urlCompanies = 'AppCashBack/getJson/$cnpj/locais/locais';
const urlOffers = 'AppCashBack/getJson/$cnpj/ofertas/ofertas';
const urlNotifications = 'AppCashBack/getJsonNotificacoes/$cnpj/notificacoes';
const urlForgotPassword = 'AppCashBack/EnviarEmail/$cnpj';
const urlGetEmailUser = 'AppCashBack/getJson/$cnpj/usuarios';
const urlImageUser = 'AppCashBack/getJsonImageUser/$cnpj/usuarios/';
const urlUploadImageUser = 'Upload/uploadImageAppUser/$cnpj/usuarios';
const urlRemoveImageUser = 'Upload/removeImageAppUser/$cnpj/usuarios/';
const urlDeleteAccount = 'AppCashBack/excluirConta/$cnpj/';
const urlGetClientID = 'AppCashBack/getJson/$cnpj/clientes/';

const double kPadding = 20;

extension ContextExtensions on BuildContext {
  ColorScheme get myTheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  void closeKeyboard() => FocusScope.of(this).unfocus();

  Size get sizeAppbar {
    final height = AppBar().preferredSize.height;

    return Size(
      screenWidth,
      height +
          (Platform.isWindows
              ? 75
              : Platform.isIOS
                  ? 50
                  : 70),
    );
  }
}
