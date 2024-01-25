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
An example of how the labels will appear in the activity flow is: ``Topmost.Inner.Inner``

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

  - The environment variables that the execution needs. (``Environment``)
  - The standard input that the execution needs. (``STDIN``)
  - The standard arguments that the execution needs. (``ARGS``)

- The system shall cache newly requested dependencies. (``Cache``)

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
- For the entire system there's a config file that has the maximum possible values of per request limits.
  (``GlobalLimits``)

Non-functional requirements
***************************

Isolation (``Isolation``)
=========================

- Every submission shall not see nor affect other submissions. (``Submission``)
- Every submission dependencies shall not conflict with other submission dependencies. (``Dependencies``)

Security (``Security``)
========================

- Clients shall not be able to escape the code execution isolation and gain access to the underlying system.
  (``Escaping``)

Performance (``Performance``)
=============================

- The system shall be able to accommodate cached nix packages which decreases latency when client asks
  for a dependency that has been specified by (possibly) another client. (``Cache``)
- The system shall provide the nix-shell dependencies to decrease the nix-shell start-up time (nix-shell won't have to
  download them). (``Nix``)


Availability (``Availability``)
===============================

- The system shall be able to accommodate at least 1 redundant code :ref:`worker-component` to prevent down-time. (``Worker``)
- The system shall be able to accommodate at least 1 redundant :ref:`CacheBuilder <cache-builder-component>` to prevent down-time. (``CacheBuilder``)

Scalability (``Scalability``)
=============================

- The system administrator shall be able to increase the number of :ref:`Workers <worker-component>` in the system as needed. (``Worker``)
- The system administrator shall be able to increase the number of :ref:`CacheBuilders <cache-builder-component>` in the system as needed.
  (``CacheBuilder``)

Fault Tolerance (``FaultTolerance``)
====================================

- The system shall continue functioning normally when a :ref:`worker-component` fails. (``Worker``)
- The system shall continue functioning normally when a :ref:`CacheBuilder <cache-builder-component>` fails. (``CacheBuilder``)
