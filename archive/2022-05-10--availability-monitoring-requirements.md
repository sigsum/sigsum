# Requirements for availability monitoring

  - System requirements
    - Runs on a modern linux distro
    - System can send email
    - System can run sigsum-debug binary
    - Root access is not required
  - Leveled alerts, aka severity
    - Error
    - Warning
  - Alerts via email
  - Check endpoint reachability
    - API §3.1 - §3.7
    - Enumerate the different ways to use an endpoint
      - http, https
      - ipv4, ipv6
      - onion
- Verify response data (the output of Sigsum endpoints)
  - E.g., timestamp or number of witness signatures on get-tree-head-to-cosign
- Perform checks from multiple vantage points

# Concrete milestones

220515

  - Sigsum endpoints
    - Either IPv4 or IPv6 (whatever the system's curl uses)
    - Only HTTPS
    - When do they 2XX?
  - No alert state
    - One alert per failure
    - Configurable test frequency (~1h hour)
  - Notifications by email only to one single address
  - "Be done very quickly but also very imperfectly"

220530
220831
221031
