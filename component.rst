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

Receiving requests from the client, massaging them into Submission objects, sending them to the SubmissionStore
and enqueueing the submission id in the SubmissionStore to notify the Workers about the arrival of a new request.

SubmissionStore
================

Storing Submission objects that come from the RequestHandler, allowing their retrieval,
allowing RequestHandlers to enqueue submission ids and allowing the Workers to pop them.

WorkerHealthChecker
===================

Checking the health of the Workers by checking a timestamp (lease) that the Workers constantly update on submissions.
If the lease is too old, the WorkerHealthChecker assumes the Worker has failed to process the submission,
resets the submission response and enqueues the submission id in the SubmissionStore.

.. _worker-component:

Worker
======

Popping submission ids from the SubmissionStore, fetching the corresponding submissions,
creating Dependencies objects, storing them and enqueueing their ids in the BuildStore
to request that the dependencies be installed in the cache, and processing submissions.

Cache
=====

Storing the dependencies as nix packages and being available for mount while processing submissions.

BuildStore
==========

Storing Dependencies objects that come from the Workers, allowing their retrieval,
allowing Workers to enqueue Dependencies objects ids and allowing CacheBuilders to pop them.

.. _cache-builder-component:

CacheBuilder
============

Popping Dependencies objects ids from the BuildStore, fetching the corresponding Dependencies objects, installing the
dependencies in the cache and sending the installation result to the BuildStore.

CacheBuilderHealthChecker
=========================

Same as the WorkerHealthChecker but for CacheBuilders and dependency installation requests.
