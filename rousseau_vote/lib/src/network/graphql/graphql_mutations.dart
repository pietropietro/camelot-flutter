String pollAnswerSubmit = '''
  mutation pollAnswerSubmit(\$pollId: ID!, \$optionIds: [ID!]!) {
    user {
      pollAnswerSubmit(pollId: \$pollId, optionIds: \$optionIds) {
			  errors
		  }
    }
  }
''';

String userAccessDataUpdate = '''
mutation userAccessDataUpdate(\$user:UpdateAccessDataUserInput!){
  user{
    userAccessDataUpdate(user:\$user){
      errors
      user{
        email
        phoneNumber
      }
    }
  }
}
''';

String tokenAdd = '''
mutation tokenAdd(\$tokenString: String!, \$client: String!) {
    user {
      tokenAdd(tokenString: \$tokenString, client: \$client) {
			  errors
		  }
    }
  }
''';

String userContactPreferencesUpdate = '''
mutation userContactPreferencesUpdate(\$user:UpdateContactPreferencesUserInput!){
    user{
        userContactPreferencesUpdate(user:\$user){
            errors
            user{
                noLocalEventsEmail
                noNationalEventsEmail
                noNewsletterEmail
                noRousseauEventsEmail
                noSms
                noVoteEmail
            }
        }
    }
}
''';

String residenceChangeRequestCreate = '''
mutation residenceChangeRequestCreate(\$attributes:ResidenceChangeRequestCreateInput!, \$documentIds: [ID!]!){
    user{
        residenceChangeRequestCreate(attributes: \$attributes, documentIds: \$documentIds){
            errors
            residenceChangeRequest{
                status
                country{
                    code 
                    name
                }
                comune{
                    code
                    name
                }
                municipio{
                    code
                    name
                }
                provincia{
                    code
                    name
                }
                regione{
                    code
                    name
                }
                overseaseCity
            }
        }
    }
}
''';

String tokenRemove = '''
mutation tokenRemove(\$tokenString: String!) {
    user {
      tokenRemove(tokenString: \$tokenString) {
			  errors
		  }
    }
  }
''';

String userDelete = '''
mutation userDelete(\$unsubscribeReason: String!){
    user{
        userDelete(unsubscribeReason: \$unsubscribeReason){
            errors
        }
    }
}
''';

String userFeedbackSubmit = '''
mutation userFeedbackSubmit(\$category: String!,\$feedback: String!){
    user{
        userFeedbackSubmit(category:\$category,feedback:\$feedback){
          errors
          success
        }
    }
}
''';

String submitIdentityVerificationRequest = '''
mutation submitIdentityVerificationRequest(\$documentIds: [ID!]!) {
    user {
        identityVerificationRequest(documentIds: \$documentIds) {
            errors
        }
    }
}
''';
