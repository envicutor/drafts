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

Receiving requests from the client, massaging them into submission objects, sending them to the SubmissionStore component
and sending a message to the SubmissionMessages queue to notify the Worker components about the arrival of a new request.

SubmissionStore
================

Storing submission objects that comes from the RequestHandler component and returning them when asked.

SubmissionMessages
==================

Receiving messages from the RequestHandler and allowing the Worker components to view them.

SubmissionHeathChecker
======================

Checking the health of the Worker components by checking a timestamp that the Worker constantly updates on submissions.
If it is too old, the SubmissionHeathChecker assumes the Worker failed to process the submission
and sends a new message about the submission to the SubmissionMessages component.

Worker
======

Fetching the submission from the SubmissionStore component after receiving a notification about it,
sending messages to the BuildMessages component to request that the dependencies be installed in the cache
and processing the submission.

Cache
=====

Storing the dependencies as nix packages and being available for mount while processing submissions.

BuildMessages
=============

Receiving messages from the Worker component and allowing the CacheBuilder component to view them.

BuildStore
==========

Storing dependency objects that come from the Worker components and returning them when asked.

CacheBuilder
============

Fetching the dependencies object from the BuildStore component after receiving a notification about it and installing the dependencies in the cache
and sends the corresponding result to the BuildMessages component.

BuildHealthChecker
==================

Same as the SubmissionHeathChecker but for build requests.