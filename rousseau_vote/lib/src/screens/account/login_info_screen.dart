import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:rousseau_vote/src/widgets/label_value.dart';
import 'package:rousseau_vote/src/widgets/rounded_button.dart';
import 'package:rousseau_vote/src/widgets/rousseau_app_bar.dart';
import 'package:rousseau_vote/src/network/graphql/graphql_mutations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rousseau_vote/src/injection/injector_config.dart';
import 'package:rousseau_vote/src/util/ui_util.dart';
import 'package:provider/provider.dart';
import 'package:rousseau_vote/src/providers/current_user_provider.dart';


class LoginInfoScreen extends StatelessWidget {
  LoginInfoScreen();
  final GlobalKey _scaffoldState = GlobalKey<ScaffoldState>();

  static const String ROUTE_NAME = '/account_login_info';
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldState,
      appBar: RousseauAppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                LabelValue(_emailController = TextEditingController(text: Provider.of<CurrentUserProvider>(context).currentUser.email), 'Email', true),
                LabelValue(_phoneNumberController = TextEditingController(text: Provider.of<CurrentUserProvider>(context).currentUser.phoneNumber), 'Numero di telefono', true),
              ],
            ),
          ),
          GraphQLProvider(
            client: getIt<ValueNotifier<GraphQLClient>>(),
            child: Mutation(
              options: MutationOptions(
                documentNode: gql(userAccessDataUpdate),
                update: (Cache cache, QueryResult result) {
                  String message;

                  if (result.hasException) {
                    print('exception');
                  }

                  final Map<String, Object> user = (result.data
                      as Map<String, Object>)['user'] as Map<String, Object>;
                  final LazyCacheMap map = user.values.first;
                  final List<Object> errors = map.values.first;
                  message = errors == null || errors.isEmpty
                      ? 'info-saved'
                      : 'error-generic';

                  showRousseauSnackbar(context, _scaffoldState, message);
                },
              ),
              builder: (RunMutation runMutation, QueryResult result) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: RoundedButton(
                    text: "SALVA",
                    loading: result.loading,
                    onPressed: () {
                      Map<String, dynamic> variables =
                          HashMap<String, dynamic>();
                      variables.putIfAbsent(
                          'user',
                          () => {
                                'phoneNumber': _phoneNumberController.text,
                                'email': _emailController.text
                              });
                      print(variables);
                      return runMutation(
                        variables,
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
