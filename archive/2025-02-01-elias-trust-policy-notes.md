# Preliminary thoughts on how to choose witnesses to use in a trust policy

## Background

When sigsum is used, a trust policy is needed.

Want to protect against the following:
- some organizations may become compromised such that all witnesses under their control become compromised
- reliability issues: some witnesses may be temporarily down due to accidents/mistakes
- if many witnesses are dependent on some infrastructure controlled by a single party, then that single party can remove all those witnesses

Consider a hierarchical approach with an odd number of witness groups, where the trust policy requires a majority of those groups.

- Simple case: 3 groups, require 2-of-3 groups
- Also possible: 5 groups, require 3-of-5 groups
- Also possible: 7 groups, require 4-of-7 groups
- ... and so on.

For simplicity, sticking with 3 groups in the example below.

Assuming that the person deciding about the trust policy has some
knowledge about the available witnesses, such as who operates/controls
each witness and what infrastructure each witness is dependent
on. Such information could come from reading the "about page" for each
witness, if each witness provides that.

To protect against organizations becoming compromised, each
organization should only control at most one witness group.

Each group consists of one or more witnesses, having several witnesses
in a group can help making the group more robust, especially if there
is diversity in how the witnesses are operated to reduce the risk that
they would go down or be compromised at the same time.

Each group should be organizationally independent from all other groups.

## Example

Simple example with three groups:

(The "infraX" below refers to some infrastructure that several
witnesses are dependent on.)

Group 1: "witnesses run by Company A", 3 witnesses, require 2-of-3
- CompanyA-witness1 relying on infraX
- CompanyA-witness2 relying on infraX
- CompanyA-witness3 relying on infraX

Group 2: "witnesses run by NGO X", 3 witnesses, require 2-of-3
- NGOX-witness1
- NGOX-witness2 relying on infraX
- NGOX-witness3

Group 3: "witnesses run by other independent organizations (NGO Y, Company B, Company C)", 3 witnesses, require 2-of-3
- NGOY-witness
- CompanyB-witness
- CompanyC-witness relying on infraX

So we have 3 witness groups, and inside each group we require 2-of-3 witnesses, and on the level of groups we again require 2-of-3 groups.

Consider how the above trust policy works in a few different scenarios:

- Scenario: one organization becomes compromised.
   - If Company A is compromised we still have 2-of-3 groups, so that is OK.
   - If NGO X is compromised we still have 2-of-3 groups, so that is OK.

- Scenario: infraX becomes compromised.
   - again, both groups 2 and 3 are still OK, so we still have 2-of-3 groups --> OK

- Scenario: one organization becomes compromised, and in addition some other witness goes down
   - if Company A is compromised we can still afford that one witness from group 2 or 3 does down.

- Scenario: one organization becomes compromised, and in addition two other witnesses go down
   - if Company A is compromised and two witnesses in group 2 go down, we fail.
   - one way to handle that would be to make the groups larger, e.g. 5 witnesses per group and require 3-of-5, then we could handle 2 witnesses going down.

Is the above approach using 3 groups better than simply using all 9 witnesses directly without any group, and requiring 5-of-9 cosignatures?
--> yes, maybe.

One case when it is better is if we consider the scenario that infraX gets compromised. Then 5 witnesses are gone, but we would still have groups 2 and 3 so that would be OK.

In contrast, if we had used all 9 witnesses without groups, then we would no longer get the required 5-of-9.

## Is it always good to add more witnesses?
- it depends
- if the new witness is both independent and reliably maintained, then likely it will be good to add that witness
- if the new witness is dependent on the same thing that other witnesses depend on, then adding that witness may be a bad idea
   - example: in the example with 3 groups above, suppose we consider adding 2 more witnesses to Group 3 and then require 3-of-5 for that group. If both witnesses added are dependent on infraX then the whole group 3 will become dependent on infraX, which it was not before.
   - adding such witnesses may still be helpful if they are added in a group that was already dependent on infraX, then our dependence on infraX does not become any worse, and we may strengthen the group in other ways.
- if a new witness is added that is poorly maintained, then that risks making things worse, if an attacker can easily compromise that witness.

## How to avoid becoming dependent on one big organization?
- If one organization runs many witnesses, make sure that organization controls no more than one witness group. Either collect all those witnesses in a single witness group, or at least ensure that the organization has only few witnesses in other groups.
- When there is a risk of becoming dependent on a particular organization, go through each witness group and check their dependence on that organization. If a group has too many witnesses that depend on that organization, then remove some of those from the group so that the group becomes independent of the organization.

## Possible guidelines for creating a trust policy
- Create witness groups based on organization, so that witnesses that are known to be controlled by the same organization are in the same witness group.
- Within each witness group, strive for diversity to reduce the risk that the witness group as a whole becomes compromised.
- To guard against dependency on a some infrastructure X, go through each witness group and check its dependence on X, and remove witnesses if needed.
- Use only witnesses that are deemed likely to stay operational for a long enough time (e.g. at least one year), then revise the policy after half that time (e.g. after 6 months) to adapt to changes in the availability of witnesses. Also adapt to other changes in the "about page" of the witnesses, such as what the witness is dependent on.
