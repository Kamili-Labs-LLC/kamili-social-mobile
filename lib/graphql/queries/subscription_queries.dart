const String getBillingInfoQuery = r'''
  query GetBillingInfo {
    billingInfo {
      subscription {
        id
        status
        plan
        currentPeriodStart
        currentPeriodEnd
        trialStart
        trialEnd
        cancelAtPeriodEnd
        canceledAt
        createdAt
      }
      customer {
        id
        email
        name
        created
      }
      paymentMethods {
        id
        type
        card {
          brand
          last4
          expMonth
          expYear
        }
        created
      }
      invoices {
        id
        number
        status
        amountPaid
        amountDue
        currency
        created
        paidAt
        hostedInvoiceUrl
        invoicePdf
      }
    }
  }
''';

const String getSubscriptionPlansQuery = r'''
  query GetSubscriptionPlans {
    subscriptionPlans {
      id
      name
      price
      features {
        posts
        socialAccounts
        aiCredits
        analytics
        teamMembers
      }
    }
  }
''';

const String getCurrentSubscriptionQuery = r'''
  query GetCurrentSubscription {
    currentSubscription {
      id
      status
      plan
      currentPeriodStart
      currentPeriodEnd
      trialStart
      trialEnd
      cancelAtPeriodEnd
      canceledAt
      createdAt
    }
  }
''';
