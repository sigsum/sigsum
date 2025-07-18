(From Tillitis 2025-07-02)

# Feedback to Glasklar on our experience of setting up a Sigsum Witness

## Introduction

Our goal was to setup a lab Sigsum cosigning witness with a TKey as
signing oracle that would witness Glasklar test log. This first
sentence also sums up our knowledge about Sigsum in one way.

On average we had fair understanding about the concept, i.e. the
advantage of logging stuff, witnessing and the advantage of
distributing the witness-task, monitoring and creating policies. Our
knowledge about details in the concept of transparency logs and
what is needed to setup a witness can be described as "limited" at
best.

Our expectations were:

- to learn about Sigsum in general.
- to learn how to setup a witness.
- to use these learnings to setup processes and a production witness
- we were told there was a good guide, so we thought it would be easy
to setup the lab witness. Max two days work.
- we thought using TKey as signing oracle would be difficult to setup.

## Experience

We started with a mail from Elias, with some good pointers on where to
start. This first mail was a really good compilation of 'getting
started' information. Then in general the mail thread that followed
quite well summarizes what we had trouble with. Short summary:

- What is the URL for the test log?
- How to see that our witness is actually up and running and signing
- What information do you need to setup the bastion?
- What information do we need in order to detup the bastion?

Our initial strategy was to create an image for a Raspberry Pi using
the scripts available in
<https://git.glasklar.is/glasklar/infra/images> and setup the witness
using the Ansible repository at
<https://git.glasklar.is/sigsum/admin/ansible>.

Due to some issues building the Raspberry Pi image we instead opted to
use an official Raspberry Pi OS Lite image. Since we have limited
experience with Ansible and Molecule, and are new to a lot of the
Sigsum terminology we instead used the Ansible repository as a guide
to set up the system manually.

Using the Sigsum documentation and Ansible repository, the Litewitness
documentation, and help from Glasklar we got a witness up and running.

The most challenging part of the task was figuring out what is needed
to have a working setup. Some question that arose:

- What does a minimal setup of a witness look like?
- What does the witness need to know about the log?
- What does the log need to know about the witness?
- What does the bastion need to know about the witness?
- What is the idiomatic way of naming a witness?
- Where do I find the log's key?
- What does a verification key look like?
- How do i get my witness's verification key in vkey format?
- How do we know if it is working?

## Conclusion

- Our knowledge about how the different parts of a Sigsum system
interacts has increased greatly. Especially how a witness interacts
with a log or bastion.
- Setting up a witness is not difficult if you have done it once.
- A step-by-step guide for setting up a "simple" witness would have
been nice. It is not that the information on how to setup a witness is
not available, but it is somewhat scattered and understanding what
information is relevant to setting up a witness can be challenging.
- Setting up TKey was quite easy. 'Only to install' TKey SSH Agent.
