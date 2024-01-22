Requirements
############

Format
******

The text inside parentheses after each requirement represents the "label" of the requirement.
This label is mapped to steps in the activity flow to show how each requirement is satisfied.

The header of each (non-)functional requirement represents the topmost label,
the bullet points represent inner labels and each indent in the bullet points represents a more inner label.
An example of how the labels will appear in the activity flow is: ``Topmost.Inner.Inner``

.. todo::

  Put the appropriate reference to the activity flow when its done.

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

Submission status request (``SubmissionStatus``)
================================================

- The client shall be able to check:

  - If their submission is still in queue. (``Pending``)
  - Whether the dependencies of their submission got installed successfully (dependencies stage).
    (``DependenciesInstalled``)
  - Whether the their submission's code finished compiling (compile stage). (``Compiled``)
  - Whether the their submission's code finished running (run stage). (``Ran``)
  - The result of their submission (each stage's stderr, stdout, signal, time, memory). (``Result``)

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

- Every Submission shall not see nor affect other submissions. (``Submission``)
- Every Submission dependencies shall not conflict with other Submission Dependencies. (``Dependencies``)

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

- The system shall be able to accommodate at least 1 redundant code executor to prevent down-time. (``Executor``)
- The system shall be able to accommodate at least 1 redundant cache builder to prevent down-time. (``CacheBuilder``)

Scalability (``Scalability``)
=============================

- The system administrator shall be able to increase the number of executors in the system as needed. (``Executor``)
- The system administrator shall be able to increase the number of cache builders in the system as needed.
  (``CacheBuilder``)
