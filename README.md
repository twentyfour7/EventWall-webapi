# KKTIXEvent Web Api
[ ![Codeship Status for twentyfour7/kktix-event-api](https://app.codeship.com/projects/e576c600-8623-0134-d9a3-4eed52377a2e/status?branch=master)](https://app.codeship.com/projects/183436)

API to check for organization event on KKTIX

## Routes

- `/` - check if API alive
- `/v0.1/org/:org_id` - get orgnization name and uri
- `/v0.1/org/:org_id/event` - get the events held by the organization
