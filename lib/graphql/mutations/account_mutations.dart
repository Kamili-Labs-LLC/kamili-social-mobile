const String updateAccountMutation = r'''
  mutation UpdateAccount($data: UpdateAccountInput!) {
    updateAccount(data: $data) {
      __typename
      ... on UpdateAccount {
        message
        account {
          id
          name
          email
          selectedTimezone
          notificationPreferences {
            postSuccessEmail
            postFailureEmail
            accountIssuesEmail
          }
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';
