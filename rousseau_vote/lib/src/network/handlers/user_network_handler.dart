import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:rousseau_vote/src/models/residence_change_request.dart';
import 'package:rousseau_vote/src/models/user/current_user.dart';
import 'package:rousseau_vote/src/network/graphql/graphql_queries.dart';
import 'package:rousseau_vote/src/network/graphql/graphql_mutations.dart';
import 'package:rousseau_vote/src/network/graphql/parser/query_response_parsers.dart';
import 'package:rousseau_vote/src/network/response/user/residence_request_create_response.dart';
import 'package:rousseau_vote/src/network/response/user/user_response.dart';

@singleton
class UserNetworkHandler {

	UserNetworkHandler(this._graphQLClient);

	final GraphQLClient _graphQLClient;

	Future<CurrentUser> fetchCurrentUser() async {
		final QueryOptions queryOptions = QueryOptions(documentNode: gql(currentUserFull));
		final QueryResult result = await _graphQLClient.query(queryOptions);
		return getParser<CurrentUser>().parse(result);
	}

	Future<CurrentUser> updateCurrentUser(CurrentUser currentUser) async {
		// TODO implement mutation
//    _graphQLClient.mutate(options);
	}

  Future<UserResponse> deleteUser(String reason) async {
    final Map<String, String> deleteVar = <String, String>{
			'unsubscribeReason': reason,
		};
    final MutationOptions mutationOptions = MutationOptions(
			documentNode: gql(userDelete),
			variables: deleteVar
		);
    final QueryResult result = await _graphQLClient.mutate(mutationOptions);
    final LazyCacheMap lazyCacheMap = result.data.get('user');
    return UserResponse.fromJson(lazyCacheMap.data);
  }

	Future<ResidenceRequestCreateResponse> createResidenceRequestChange(String countryCode, String regioneCode, String provinciaCode, String comuneCode, String municipioCode, String overseaseCity,String documentId) async {
		Map<String, String> residenceData = <String, String>{
			'countryCode': countryCode,
			'regioneCode': regioneCode,
			'provinciaCode': regioneCode,
			'comuneCode': regioneCode,
		};

		if(overseaseCity.isNotEmpty){
			residenceData.putIfAbsent('overseaseCity', () => overseaseCity);
		}
		if(municipioCode.isNotEmpty){
			residenceData.putIfAbsent('municipioCode', () => municipioCode);
		}

		final Map<String, dynamic> geoVar = <String, dynamic>{
			'attributes': residenceData,
			'documentIds': <String>[documentId]
		};

		final MutationOptions mutationOptions = MutationOptions(
			documentNode: gql(residenceChangeRequestCreate),
			variables: geoVar
		);

		final QueryResult result = await _graphQLClient.mutate(mutationOptions);
    final LazyCacheMap lazyCacheMap = result.data.get('user');
    final UserResponse userResp = UserResponse.fromJson(lazyCacheMap.data);
    
    if(userResp != null && userResp.residenceChangeRequestCreate != null){
      return userResp.residenceChangeRequestCreate;
    }
    return null;

	}
}