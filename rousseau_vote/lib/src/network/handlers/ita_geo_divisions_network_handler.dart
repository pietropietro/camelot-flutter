
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:rousseau_vote/src/models/country_list.dart';
import 'package:rousseau_vote/src/models/ita_geo_division_list.dart';
import 'package:rousseau_vote/src/models/italianGeographicalDivision.dart';
import 'package:rousseau_vote/src/network/graphql/parser/query_response_parsers.dart';
import 'package:rousseau_vote/src/network/graphql/graphql_queries.dart';

@singleton
class ItaGeoDivisionsNetworkHandler {

  ItaGeoDivisionsNetworkHandler(this._graphQLClient);

  final GraphQLClient _graphQLClient;

  Future<ItaGeoDivisionList> getGeoDivList(String type, String search) async {
    Map<String, String> geoVar = {'type': type.toLowerCase(), 'search': search};

    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(italianGeographicalDivisions),
      variables: geoVar
    );
    final QueryResult result = await _graphQLClient.query(queryOptions);
    return getParser<ItaGeoDivisionList>().parse(result);
  }

  Future<CountryList> getCountries(String search) async {
    final QueryOptions queryOptions = QueryOptions(
      documentNode: gql(countries),
    );
    final QueryResult result = await _graphQLClient.query(queryOptions);
    return getParser<CountryList>().parse(result);
  }

}