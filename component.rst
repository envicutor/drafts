Component Diagram
#################

Diagram
*******

.. figure:: figures/component-diagram.svg
  :alt: Component diagram

  |product-name|'s component diagram.

Components Responsibilities
***************************

RequestHandler
===============

Receiving requests, parsing them into submission objects, sending them to the SubmissionStore component
and sending a message to the SubmissionMessages queue to notify the Worker components about the arrival of a new request.

SubmissionStore
================

Storing submission objects that comes from the RequestHandler component and returning them when asked.

SubmissionMessages
==================

Notifying the Worker components about the arrival of a new request.

SubmissionHeathChecker
======================

Checking the health of the Worker components by checking a timestamp that the Worker constantly updates on submissions.
If it is too old, the SubmissionHeathChecker assumes the Worker failed to process the submission.

Worker
======

Processing the submissions in the SubmissionStore after receiving a notification about it
and sends messages to the build messages to request that the dependencies be installed in the cache.

Cache
=====

Storing the dependencies as nix packages.

BuildMessages
=============

Notifying the CacheBuilder about the arrival of a build request.

BuildStore
==========

Storing dependency objects that come from the Worker components and returning them when asked.

CacheBuilder
============

Processing the dependency objects from the BuildStore and installing the requested dependencies in the cache.

BuildHealthChecker
==================

Same as the SubmissionHeathChecker but for build requests.