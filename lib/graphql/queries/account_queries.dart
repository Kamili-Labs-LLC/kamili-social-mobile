const String getAccountQuery = r'''
  query GetAccount {
    getAccount {
      __typename
      ... on GetAccount {
        account {
          id
          name
          email
          plan
          selectedTimezone
          subscriptionStatus
          notificationPreferences {
            postSuccess
            postFailure
            accountIssues
          }
          userSettings {
            defaultUrlShortener
            defaultPostSignature
          }
          createdAt
          updatedAt
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String checkEmailExistsQuery = r'''
  query CheckEmailExists($email: String!) {
    checkEmailExists(email: $email)
  }
''';
