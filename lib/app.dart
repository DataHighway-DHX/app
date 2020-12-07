import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:polka_wallet/page/account/scanPage.dart';
import 'package:polka_wallet/page/account/txConfirmPage.dart';
import 'package:polka_wallet/page/account/uos/qrSenderPage.dart';
import 'package:polka_wallet/page/account/uos/qrSignerPage.dart';
import 'package:polka_wallet/page/assets/asset/assetPage.dart';
import 'package:polka_wallet/page/assets/claim/claim_page.dart';
import 'package:polka_wallet/page/assets/claim/claim_details_page.dart';
import 'package:polka_wallet/page/assets/lock/instruction/instruction_page.dart';
import 'package:polka_wallet/page/assets/lock/lock_detail_page.dart';
import 'package:polka_wallet/page/assets/lock/lock_result_page.dart';
import 'package:polka_wallet/page/assets/lock/lock_page.dart';
import 'package:polka_wallet/page/assets/receive/receivePage.dart';
import 'package:polka_wallet/page/assets/signal/instruction/instruction_page.dart';
import 'package:polka_wallet/page/assets/signal/signal_detail_page.dart';
import 'package:polka_wallet/page/assets/signal/signal_page.dart';
import 'package:polka_wallet/page/assets/signal/signal_result_page.dart';
import 'package:polka_wallet/page/assets/claim/attestPage.dart';
import 'package:polka_wallet/page/assets/transfer/currencySelectPage.dart';
import 'package:polka_wallet/page/assets/transfer/detailPage.dart';
import 'package:polka_wallet/page/assets/transfer/transferPage.dart';
import 'package:polka_wallet/page/governance/council/candidateDetailPage.dart';
import 'package:polka_wallet/page/governance/council/candidateListPage.dart';
import 'package:polka_wallet/page/governance/council/councilVotePage.dart';
import 'package:polka_wallet/page/governance/democracy/referendumVotePage.dart';
import 'package:polka_wallet/page/profile/aboutPage.dart';
import 'package:polka_wallet/page/profile/account/accountManagePage.dart';
import 'package:polka_wallet/page/profile/account/changeNamePage.dart';
import 'package:polka_wallet/page/profile/account/changePasswordPage.dart';
import 'package:polka_wallet/page/profile/account/exportAccountPage.dart';
import 'package:polka_wallet/page/profile/account/exportResultPage.dart';
import 'package:polka_wallet/page/profile/recovery/createRecoveryPage.dart';
import 'package:polka_wallet/page/profile/recovery/friendListPage.dart';
import 'package:polka_wallet/page/profile/recovery/initiateRecoveryPage.dart';
import 'package:polka_wallet/page/profile/recovery/recoveryProofPage.dart';
import 'package:polka_wallet/page/profile/recovery/recoverySettingPage.dart';
import 'package:polka_wallet/page/profile/contacts/contactListPage.dart';
import 'package:polka_wallet/page/profile/contacts/contactPage.dart';
import 'package:polka_wallet/page/profile/contacts/contactsPage.dart';
import 'package:polka_wallet/page/profile/recovery/recoveryStatePage.dart';
import 'package:polka_wallet/page/profile/recovery/vouchRecoveryPage.dart';
import 'package:polka_wallet/page/profile/settings/remoteNodeListPage.dart';
import 'package:polka_wallet/page/profile/settings/settingsPage.dart';
import 'package:polka_wallet/page/profile/settings/ss58PrefixListPage.dart';
import 'package:polka_wallet/page/staking/actions/accountSelectPage.dart';
import 'package:polka_wallet/page/staking/actions/bondExtraPage.dart';
import 'package:polka_wallet/page/staking/actions/bondPage.dart';
import 'package:polka_wallet/page/staking/actions/setControllerPage.dart';
import 'package:polka_wallet/page/staking/validators/nominatePage.dart';
import 'package:polka_wallet/page/staking/actions/payoutPage.dart';
import 'package:polka_wallet/page/staking/actions/redeemPage.dart';
import 'package:polka_wallet/page/staking/actions/setPayeePage.dart';
import 'package:polka_wallet/page/staking/actions/stakingDetailPage.dart';
import 'package:polka_wallet/page/staking/actions/unbondPage.dart';
import 'package:polka_wallet/page/staking/validators/validatorDetailPage.dart';
import 'package:polka_wallet/service/ethereum_api/api.dart';
import 'package:polka_wallet/service/notification.dart';
import 'package:polka_wallet/store/app.dart';

import 'page/menu_page.dart';
import 'utils/i18n/index.dart';
import 'common/theme.dart';

import 'package:polka_wallet/page/homePage.dart';
import 'package:polka_wallet/page/account/create/createAccountPage.dart';
import 'package:polka_wallet/page/account/create/backupAccountPage.dart';
import 'package:polka_wallet/page/account/import/importAccountPage.dart';
import 'package:polka_wallet/page/account/createAccountEntryPage.dart';
import 'package:polka_wallet/store/assets/types/currency.dart';

class WalletApp extends StatefulWidget {
  const WalletApp(this.appStore);

  final AppStore appStore;

  @override
  WalletAppState createState() => WalletAppState();

  static WalletAppState of(BuildContext context, {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final WalletAppState result =
        context.findAncestorStateOfType<WalletAppState>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'WalletApp.of() called with a context that does not contain a WalletApp.'),
      ErrorDescription(
          'No WalletApp ancestor could be found starting from the context that was passed to WalletApp.of(). '
          'This usually happens when the context provided is from the same StatefulWidget as that '
          'whose build function actually creates the WalletApp widget being sought.'),
      context.describeElement('The context used was')
    ]);
  }
}

class WalletAppState extends State<WalletApp> {
  AppStore get _appStore => widget.appStore;

  Locale _locale = const Locale('en', '');
  ThemeData _theme = appTheme;

  @override
  void initState() {
    super.initState();
    changeLang(_appStore.settings.localeCode);
    loadAccountsFuture = _loadAccounts();
  }

  void changeLang(String code) {
    Locale res;
    switch (code) {
      case 'zh':
        res = const Locale('zh', '');
        break;
      case 'en':
        res = const Locale('en', '');
        break;
      default:
        res = null;
    }
    if (_locale != res) {
      setState(() {
        _locale = res;
      });
    }
  }

  Future loadAccountsFuture;
  Future<int> _loadAccounts() async {
    // if (_appStore == null) {
    //   _changeLang(context, _appStore.settings.localeCode);
    //   _checkUpdate(context);
    // }
    return _appStore.account.accountListAll.length;
  }

  @override
  void dispose() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final Map<String, String> dic = I18n.of(context).assets;
        return CupertinoAlertDialog(
          title: Container(),
          content: Text('${dic['copy']} ${dic['success']}'),
        );
      },
    );

    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      iconColor: Colors.black,
      child: MaterialApp(
        title: 'DataHighway',
        localizationsDelegates: [
          AppLocalizationsDelegate(_locale),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('zh', ''),
        ],
        initialRoute: _appStore.account.accountListAll.isEmpty
            ? CreateAccountEntryPage.route
            : HomePage.routee,
        theme: _theme,
        routes: {
          HomePage.routee: (_) => HomePage(_appStore),
          // account
          CreateAccountEntryPage.route: (_) =>
              CreateAccountEntryPage(_appStore),
          CreateAccountPage.route: (_) =>
              CreateAccountPage(_appStore.account.setNewAccount),
          BackupAccountPage.route: (_) => BackupAccountPage(_appStore),
          ImportAccountPage.route: (_) => ImportAccountPage(_appStore),
          ScanPage.route: (_) => ScanPage(),
          TxConfirmPage.route: (_) => TxConfirmPage(_appStore),
          // mining
          SignalPage.route: (ctx) => SignalPage(
                _appStore,
                (ModalRoute.of(ctx)?.settings?.arguments as Map)['msb'],
                (ModalRoute.of(ctx)?.settings?.arguments as Map)['currency'],
              ),
          SignalDetailPage.route: (ctx) => SignalDetailPage(
              _appStore, ModalRoute.of(ctx)?.settings?.arguments),
          SignalResultPage.route: (ctx) => SignalResultPage(
              _appStore, ModalRoute.of(ctx)?.settings?.arguments),
          SignalInstructionPage.route: (_) => SignalInstructionPage(),
          LockPage.route: (ctx) => LockPage(
                _appStore,
                (ModalRoute.of(ctx)?.settings?.arguments as Map)['msb'],
                (ModalRoute.of(ctx)?.settings?.arguments as Map)['currency'],
              ),
          LockDetailPage.route: (ctx) => LockDetailPage(
              _appStore, ModalRoute.of(ctx)?.settings?.arguments),
          LockResultPage.route: (ctx) => LockResultPage(
              _appStore, ModalRoute.of(ctx)?.settings?.arguments),
          LockInstructionPage.route: (_) => LockInstructionPage(),
          ClaimPage.route: (ctx) {
            final arguments =
                (ModalRoute.of(ctx)?.settings?.arguments as Map) ?? {};
            return ClaimPage(
              _appStore,
              showHistory: arguments['showHistory'] ?? true,
              initialClaimType: arguments['initialClaimType'] ?? ClaimType.lock,
              initialClaimCurrency:
                  arguments['initialClaimCurrency'] ?? TokenCurrency.mxc,
            );
          },
          ClaimDetailsPage.route: (ctx) => ClaimDetailsPage(
              _appStore, ModalRoute.of(ctx)?.settings?.arguments),
          QrSignerPage.route: (_) => QrSignerPage(_appStore),
          QrSenderPage.route: (_) => QrSenderPage(),
          // assets
          AssetPage.route: (_) => AssetPage(_appStore),
          TransferPage.route: (_) => TransferPage(_appStore),
          ReceivePage.route: (_) => ReceivePage(_appStore),
          TransferDetailPage.route: (_) => TransferDetailPage(_appStore),
          CurrencySelectPage.route: (_) => CurrencySelectPage(),
          AttestPage.route: (_) => AttestPage(_appStore),
          // staking
          StakingDetailPage.route: (_) => StakingDetailPage(_appStore),
          ValidatorDetailPage.route: (_) => ValidatorDetailPage(_appStore),
          BondPage.route: (_) => BondPage(_appStore),
          BondExtraPage.route: (_) => BondExtraPage(_appStore),
          UnBondPage.route: (_) => UnBondPage(_appStore),
          NominatePage.route: (_) => NominatePage(_appStore),
          SetPayeePage.route: (_) => SetPayeePage(_appStore),
          RedeemPage.route: (_) => RedeemPage(_appStore),
          PayoutPage.route: (_) => PayoutPage(_appStore),
          SetControllerPage.route: (_) => SetControllerPage(_appStore),
          AccountSelectPage.route: (_) => AccountSelectPage(_appStore),
          // governance
          CandidateDetailPage.route: (_) => CandidateDetailPage(_appStore),
          CouncilVotePage.route: (_) => CouncilVotePage(_appStore),
          CandidateListPage.route: (_) => CandidateListPage(_appStore),
          ReferendumVotePage.route: (_) => ReferendumVotePage(_appStore),
          // profile
          AccountManagePage.route: (_) => AccountManagePage(_appStore),
          ContactsPage.route: (_) => ContactsPage(_appStore),
          ContactListPage.route: (_) => ContactListPage(_appStore),
          ContactPage.route: (_) => ContactPage(_appStore),
          ChangeNamePage.route: (_) => ChangeNamePage(_appStore.account),
          ChangePasswordPage.route: (_) =>
              ChangePasswordPage(_appStore.account),
          SettingsPage.route: (_) => SettingsPage(_appStore.settings),
          ExportAccountPage.route: (_) => ExportAccountPage(_appStore.account),
          ExportResultPage.route: (_) => ExportResultPage(),
          RemoteNodeListPage.route: (_) =>
              RemoteNodeListPage(_appStore.settings),
          SS58PrefixListPage.route: (_) =>
              SS58PrefixListPage(_appStore.settings),
          AboutPage.route: (_) => AboutPage(),
          RecoverySettingPage.route: (_) => RecoverySettingPage(_appStore),
          RecoveryStatePage.route: (_) => RecoveryStatePage(_appStore),
          RecoveryProofPage.route: (_) => RecoveryProofPage(_appStore),
          CreateRecoveryPage.route: (_) => CreateRecoveryPage(_appStore),
          FriendListPage.route: (_) => FriendListPage(_appStore),
          InitiateRecoveryPage.route: (_) => InitiateRecoveryPage(_appStore),
          VouchRecoveryPage.route: (_) => VouchRecoveryPage(_appStore),
          MenuPage.route: (_) => MenuPage(_appStore),
        },
      ),
    );
  }
}
