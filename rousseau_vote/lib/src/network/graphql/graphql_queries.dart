String listPolls = '''
  query listPolls {
    polls(orderAttribute: show_starting_date, orderDirection: DESC) {
      id
      slug
      title
      status
      alreadyVoted
      showStartingDate
      voteStartingDate
      voteEndingDate
      announcementLink
      resultsLink
      alerts {
        message
      }
    }
  }
''';

String profileDetail = '''
query profileDetail(\$id: ID!) {
    user(id: \$id) {
        id
        slug
        accountType
        badges {
            code
            active
        }
        category {
            code
        }
        tags {
            code
        }
        gender
        firstName
        fullName
        lastName
        userPositions {
            description
            geographicalScope {
                name
                type
            }
            position {
                code
                type
                name
            }
            startsAt
            endsAt
        }
        profile {
            presentation
            curriculumActivist
            curriculumVitae
            yearOfGraduation
            educationalInstitute
            studyCourse
            englishLevel
            frenchLevel
            germanLevel
            spanishLevel
            qualification
            politicalExperiences
            facebookProfile
            twitterProfile
            linkedinProfile
            age
            placeOfBirth
            placeOfResidence {
                comuneName
            }
            picture {
                originalUrl
            }
            curriculumVitaeDocument {
                originalUrl
            }
            italiaCinqueStelleVolunteerFlag
            italiaCinqueStelleVolunteer
            listRepresentativeFlag
            listRepresentativeYear
            listRepresentativeComune
            opendayParticipantFlag
            opendayParticipant
            spokesmanM5sFlag
            spokesmanM5sYear
            spokesmanM5sInstitution
            villaggioRousseauParticipantFlag
            villaggioRousseauParticipant
            villaggioRousseauVolunteerFlag
            villaggioRousseauVolunteer
            approvedCandidatures {
                availableForFrontRunning
                poll {
                    title
                    features {
                        frontRunners
                        frontRunnersLabel
                    }
                }
            }
        }
    }
}
''';


String pollDetail = '''
  query pollDetail(\$pollId: ID!) {
    poll(id: \$pollId) {
      id
      slug
      title
      status
      description
      alreadyVoted
      showStartingDate
      voteStartingDate
      voteEndingDate
      announcementLink
      resultsLink
      optionType
      maxSelectableOptionsNumber
      options {
        id
        ...on TextOption {
          text
        }
        ...on EntityOption {
          entity {
            ...on User {
              id
              slug
              fullName
              profile {
                age
                placeOfResidence {
                  comuneName
                  provinciaName
                }
                picture {
                  originalUrl
                }
              }
              badges {
                code
                active
                name
              }
            }
          }
        }
      }
    }
  }
''';

String currentUserShort = '''
  query currentUser {
   currentUser {
    id 
    slug
    fullName
    voteRightStartingCountDate
    verified
    createdAt
    statusColor
    profile {
        picture {
            originalUrl
        }
    }
    badges {
        code
        active
    }
  }
}
''';

String currentUserFull = '''
  query currentUser {
   currentUser {
    id 
    slug
    firstName
    fullName
    lastName
    gender
    placeOfBirth
    dateOfBirth
    email
    codiceFiscale
    phoneNumber
    voteRightStartingCountDate
    verified
    createdAt
    noLocalEventsEmail
    noNationalEventsEmail
    noNewsletterEmail
    noRousseauEventsEmail
    noSms
    noVoteEmail
    badges {
        id
        name
        code
        active
    }
    activeUserPositions{
        position{
            id
            name
            description
            code
        }
        geographicalScope{
          id
          code
        }
    }
    comune{
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
    municipio{
      code
      name
    }
    country{
      code 
      name
    }
    overseaseCity
    profile {
        presentation
        curriculumActivist
        curriculumVitae
        yearOfGraduation
        educationalInstitute
        studyCourse
        englishLevel
        frenchLevel
        germanLevel
        spanishLevel
        otherLanguages
        qualification
        politicalExperiences
        facebookProfile
        twitterProfile
        linkedinProfile
        italiaCinqueStelleVolunteer
        italiaCinqueStelleVolunteerFlag
        villaggioRousseauVolunteer
        villaggioRousseauVolunteerFlag
        listRepresentativeFlag
        listRepresentativeYear
        listRepresentativeComune
        spokesmanM5sFlag
        spokesmanM5sYear
        spokesmanM5sInstitution
        opendayParticipantFlag
        opendayParticipant
        villaggioRousseauParticipant
        villaggioRousseauParticipantFlag
        picture {
            originalUrl
        }
    }
    identityVerificationRequests(last: 15){
			nodes {
        id
        updatedAt
        documents {
          fileType
          originalUrl
        }
        status
        rejectionReason
      }
    }
  }
}
''';

String currentUserResidence = '''
query currentUser {
  currentUser {
    slug
    comune{
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
    municipio{
      code
      name
    }
    country{
      code 
      name
    }
    overseaseCity
  }
}
''';

String italianGeographicalDivisions = '''
query italianGeographicalDivisions(
    \$after:String,
    \$before:String,
    \$first:Int,
    \$last:Int,
    \$orderAttribute:ItalianGeographicalDivisionOrderAttributes,
    \$orderDirection:OrderDirection,
    \$search:String,
    \$name:String,
    \$code:String,
    \$type:ItalianGeographicalDivisionTypes,
    \$parentType: ItalianGeographicalDivisionTypes,
    \$parentCode: String
){
 italianGeographicalDivisions(
     after: \$after,
     before: \$before
     first:\$first,
     last:\$last,
     orderAttribute:\$orderAttribute,
     orderDirection: \$orderDirection,
     search:\$search,
     name:\$name,
     code:\$code,
     type:\$type,
     parentType: \$parentType,
     parentCode: \$parentCode
 ){
    nodes{
      id
      name
      code
      type
      descendants {
        name
        code
      }
    }
  }
}
''';

String countries = '''
query countries{
  countries {
    name
    code
  }
}
''';