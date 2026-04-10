const String createCheckoutSessionMutation = r'''
  mutation CreateCheckoutSession($input: CreateCheckoutSessionInput!) {
    createCheckoutSession(input: $input) {
      id
      url
    }
  }
''';

const String createBillingPortalSessionMutation = r'''
  mutation CreateBillingPortalSession($input: CreateBillingPortalSessionInput!) {
    createBillingPortalSession(input: $input) {
      url
    }
  }
''';

const String updateSubscriptionPlanMutation = r'''
  mutation UpdateSubscriptionPlan($input: UpdateSubscriptionPlanInput!) {
    updateSubscriptionPlan(input: $input) {
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

const String cancelSubscriptionMutation = r'''
  mutation CancelSubscription($immediate: Boolean) {
    cancelSubscription(immediate: $immediate) {
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
