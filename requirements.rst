.. _requirements:

Requirements
############

Format
******

The text inside parentheses after each requirement represents the "label" of the requirement.
Some labels are mapped to steps in the :ref:`activity flow <flow>` to show how each requirement is satisfied.
The labels that are not mapped to the activity flow reflect requirements that the architecture achieves naturally.

The heading of each (non-)functional requirement represents the topmost label,
the bullet points represent inner labels and each indent in the bullet points represents a more inner label.
An example of how the labels will appear in the :ref:`activity flow <flow>` is: ``Topmost.Inner.Inner``

Functional requirements
***********************

Submission requests (``SubmissionRequests``)
============================================

- The client shall be able to specify:

  - The arbitrary files that the execution needs in utf8, hex or base64. (``Files``)
  - The dependencies that their code needs as nix packages. (``Dependencies``)
  - How to compile the code as a shell script. (``Compile``)
  - How to run the code as a shell script. (``Run``)

    - Different test cases to run on. (``Multiple``)

  - The standard input that the execution needs. (``STDIN``)
  - The standard arguments that the execution needs. (``ARGS``)
  - Whether or not the dependencies of the submission shall be cached. (``Cache``)

.. _submission_status_request:

Submission status request (``SubmissionStatus``)
================================================

- The client shall be able to check:

  - If their submission was submitted successfully. (``Submitted``)
  - Whether the dependencies of their submission got installed successfully (dependencies stage).
    (``DependenciesInstalled``)
  - Whether the their submission's code finished compiling (compile stage). (``Compiled``)
  - Whether the their submission's code finished running (run stage). (``Finished``)
  - The result of their submission (each stage's stderr, stdout, signal, time, memory). (``Result``)

.. _execution_limits:

Execution limits (``Limits``)
=============================

- For each stage (dependencies, compile, run), the client shall be able to specify linux `prlimits <prlimits_>`_.
  (``PerRequestLimits``)
- For the entire system there's a config file that has the maximum possible values per limit. (``GlobalLimits``)

Non-functional requirements
***************************

Isolation (``Isolation``)
=========================

- Every submission shall not see nor affect other submissions. (``Submission``)
- Every submission dependencies shall not conflict with other submission dependencies. (``Dependencies``)

Security (``Security``)
========================

- Submissions shall not be able to escape the code execution isolation and gain access to the underlying system.
  (``Escaping``)

Performance (``Performance``)
=============================

- The system shall be able to cache nix packages to decrease latency when a client asks
  for a dependency that has been specified by (possibly) another client. (``Cache``)

Availability (``Availability``)
===============================

- To prevent downtime:

  - The system shall be able to operate with redundant :ref:`Workers <worker-component>`. (``Worker``)
  - The system shall be able to operate with redundant :ref:`CacheServers <cache-server-component>`.
    (``CacheServer``)

Scalability (``Scalability``)
=============================

- The system shall be able to operate with an increased/decreased number of the following components:

  - :ref:`Workers <worker-component>` (``Worker``)
  - :ref:`CacheServers <cache-server-component>` (``CacheServer``)

Fault Tolerance (``FaultTolerance``)
====================================

- The system shall continue functioning normally when a :ref:`worker-component` fails. (``Worker``)
- The system shall continue functioning normally when a :ref:`cache-server-component` fails. (``CacheServer``)
