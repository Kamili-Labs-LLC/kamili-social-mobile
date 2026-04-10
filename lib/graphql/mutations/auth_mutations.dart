const String signInMutation = r'''
  mutation SignIn($data: SignInInput!) {
    signIn(data: $data) {
      __typename
      ... on SignIn {
        message
        accessToken
        refreshToken
        account {
          id
          name
          email
          plan
          selectedTimezone
          subscriptionStatus
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String signUpMutation = r'''
  mutation SignUp($data: SignUpInput!) {
    signUp(data: $data) {
      __typename
      ... on SignUp {
        message
        accessToken
        refreshToken
        account {
          id
          name
          email
          plan
          selectedTimezone
          subscriptionStatus
        }
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String signOutMutation = r'''
  mutation SignOut($data: SignOutInput!) {
    signOut(data: $data) {
      __typename
      ... on SignOut {
        message
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String refreshTokenMutation = r'''
  mutation RefreshToken {
    refreshToken {
      __typename
      ... on RefreshToken {
        message
        accessToken
        refreshToken
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String forgotPasswordMutation = r'''
  mutation ForgotPassword($data: ForgotPasswordInput!) {
    forgotPassword(data: $data) {
      __typename
      ... on ForgotPassword {
        message
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';

const String resetPasswordMutation = r'''
  mutation ResetPassword($data: ResetPasswordInput!) {
    resetPassword(data: $data) {
      __typename
      ... on ResetPassword {
        message
      }
      ... on Error {
        errorCode
        message
      }
    }
  }
''';
