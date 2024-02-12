API Documentation and Object Schemas
####################################


Interface objects
*****************

File:
=====

.. code-block:: yaml

  File:
    - key: name
      type: string
    - key: content
      type: string
    - key: encoding
      type: string
      optional: true
      one_of:
        - utf8
        - base64
        - hex

Limit:
======

.. code-block:: yaml

  Limit:
    - key: time
      type: int
      explanation: the maximum amount of time a stage is allowed to take
    - key: memory
      type: int
      explanation: the maximum amount of memory in bytes a stage is allowed to use
    - key: processes
      type: int
      explanation: the maximum number of processes that can be started within a stage
    - key: output
      type: int
      explanation: the maximum number of characters in stdout a stage can produce
    - key: error
      type: int
      explanation: the maximum number of characters in stderr a stage can produce
    - key: file_size
      type: int
      explanation: the maximum size of a file in bytes that can be created in a stage

Limits:
=======

.. code-block:: yaml

  Limits:
    - key: dependencies
      type: Limit
      optional: true
      explanation: the constraints of the dependencies installation stage
    - key: run
      type: Limit
      optional: true
      explanation: the constraints of the code running stage
    - key: compile
      type: Limit
      optional: true
      explanation: the constraints of the code compilation stage

TestCase:
=========

.. code-block:: yaml

  TestCase:
    - key: input
      type: string
      optional: true
      explanation: the stdin to be provided in that test case
    - key: args
      type: string[]
      optional: true
      explanation: the stdargs to be provided in that test case

.. _request-object:

Request:
========

.. code-block:: yaml

  Request:
    - key: files
      type: File[]
      shall_include:
        - |
          A file with name "shell.nix" which is a nix shell that determines the environment in which the code is going
          to be executed.
          Example
            { pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/4fddc9be4eaf195d631333908f2a454b03628ee5.tar.gz") {} }:
              pkgs.mkShell {
                nativeBuildInputs = with pkgs; [
                  rustc
                  lua
                  dotnet-sdk
                ];
              }
        - A file with name "cutor-run.sh" that is a shell script that has the instructions to run the code
      might_include:
        - A file with name cutor-compile.sh that is a shell script that has the instructions to compile the code
        - Any other files that whose names are not one of the names mentioned above
    - key: cache
      type: bool
      optional: true
      explanation: whether or not the worker will ask the cache server to cache dependencies
    - key: limits
      type: Limits
      optional: true
      explanation: the constraints of different stages while processing the submission
    - key: test_cases
      type: TestCase[]
      constraint: at least one test case must exist
      explanation: the test cases the submission shall run on (run stage)

StageOutput:
============

.. code-block:: yaml

  StageOutput:
    - key: stdout
      type: string
    - key: stderr
      type: string
    - key: time
      type: int
      explanation: the time in milliseconds that stage took
    - key: code
      type: int
      explanation: the code the process exited with
    - key: signal
      type: string
      explanation: the signal that caused the process to exit

Response:
=========

.. code-block:: yaml

  Response:
    - key: status
      type: string
      one_of:
        - SUBMITTED
        - DEPENDENCIES_INSTALLED
        - COMPILED
        - FINISHED
      explanation: |
        Submitted: the submission was created
        DEPENDENCIES_INSTALLED: the dependencies installation stage completed successfully
        COMPILED: the compilation stage completed successfully
        FINISHED: all the stages completed successfully, or the submission was aborted prematurely due to an error
    - key: dependencies
      type: StageOutput
    - key: compile
      type: StageOutput
    - key: run
      type: StageOutput[]

.. _submission-object:

SubmissionObject:
=================

.. code-block:: yaml

  Submission:
    - key: id
      type: string
    - key: request
      type: Request
    - key: response
      type: Response

.. _queues:

Queues
******

.. code-block:: yaml

  SubmissionQueue:
    - explanation: holds submission ids
      type: queue
      location: InMemoryStore

Endpoints
*********

- ``POST /submission``: create a new submission.
- ``GET /submission/{id}``: get the status of the submission with id ``id``.
