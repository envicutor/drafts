.. _flow:

Activity Flow
#############

What it is
**********
Provided are simplified sequence of steps that Envicutor takes to achieve certain goals (ie. to complete certain flows).
Next to some steps are some labels in parentheses that refer to the labels in the :ref:`requirements <requirements>`
to show how the requirements are satisfied.

Execution flow
**************

- Client

  - Send :ref:`submission request <submission-object>` (``SubmissionRequests.files``,
    ``SubmissionRequests.Dependencies``,
    ``SubmissionRequests.compile``,
    ``SubmissionRequests.run``,
    ``SubmissionRequests.files``,
    ``SubmissionRequests.PerRequestLimits``,
    ``Limits.PerRequestLimits``,
    ``Limits.GlobalLimits``,
    ``SubmissionRequests.Run.Multiple``,
    ``SubmissionRequests.STDIN``,
    ``SubmissionRequests.ARGS``,
    ``SubmissionRequests.Cache``):

    .. code-block::

      {
        "files": [
          {
            "name": "shell.nix",
            "content": "required dependencies to execute the program as nix packages"
          },
          {
            "name": "cutor-compile.sh",
            "content": "compile instructions"
          },
          {
            "name": "cutor-run.sh",
            "content": "run instructions"
          },
          {
            "name": "some-file",
            "content": "content",
            "encoding": "utf8|base64|hex"
          },
          ...
        ],
        "cache": bool,
        "limits": {
          "dependencies":
          {
            "time": int,
            "memory": int,
            "processes": int,
            "output": int,
            "error": int,
            "file_size": int
          },
          "run":
          {
            "time": int,
            "memory": int,
            "processes": int,
            "output": int,
            "error": int,
            "file_size": int
          }
          "compile":
          {
            "time": int,
            "memory": int,
            "processes": int,
            "output": int,
            "error": int,
            "file_size": int
          }
        },
        "test_cases": [
          {
            "inputs": "string of input data",
            "args": ["arg1", "arg2", ...],
          },
          ...
        ]
      }

- RequestHandler

  - Create :ref:`Submission object <submission-object>` (``SubmissionStatus.Submitted``):

    .. code-block::

      {
        "id": id,
        "request": the client request mentioned above,
        "response": {
          "status": "SUBMITTED",
          "dependencies": {
            "stdout": "",
            "stderr": "",
            "time": "",
            "signal": ""
            "code": ""
          },
          "compile": {
            "stdout": "",
            "stderr": "",
            "time": "",
            "signal": ""
            "code": ""
          },
          "run": {
            "stdout": "",
            "stderr": "",
            "time": "",
            "signal": ""
            "code": ""
          }
        }
      }

  - Store that Submission object in Database
  - :ref:`Enqueue the submission id <queues>` in the InMemoryStore
  - Return the submission id to the client

- Worker

  - Pop submission id from the InMemoryStore
  - Fetch the corresponding Submission object from the Database
  - Create a lease in the InMemoryStore for the submission
  - Keep updating the lease of the Submission object in the InMemoryStore every n milliseconds with now's timestamp
    to signal that you are healthy
  - Create directory with the submission id as its name with:

    - ``shell.nix``, files, ``cutor-compile.sh``, ``cutor-run.sh`` (created from the submission request)

  - Create a child docker container to process the submission (``Security.Escaping``, ``Isolation.Submission``)

- Container


  - Inside an :term:`nsjail` sandbox:

    - Check which dependencies requisites are cached in the CacheServer
    - Install the rest of the dependencies that are uncached
    - If dependencies installed successfully and cache in request is true

      - Send ``shell.nix`` to the CacheServer

- CacheServer

  - Inside an :term:`nsjail` sandbox:

    - Install dependencies specified in the ``shell.nix`` (``Performance.Cache``)

- Container

  - Signal to the Worker the status of the dependencies installation

- Worker

  - After receiving the signal, update submission object with the appropriate status
    (``SubmissionStatus.DependenciesInstalled``)

- Container

  - [if dependencies installation fails] abort
  - If compilation is specified in the Submission object

    - Inside an :term:`nsjail` sandbox:

      - Run ``cutor-compile.sh`` inside a nix-shell (``Isolation.Dependencies``)

  - Signal to the Worker the status of the compilation

- Worker

  - After receiving the signal, update Submission object with the appropriate status (``SubmissionStatus.Compiled``)

- Container

  - If compile is successful or no compile is specified:

    - For each case in ``submission.test_cases``

      - Inside an :term:`nsjail` sandbox:

        - Run ``cutor-run.sh`` inside a nix-shell (``Isolation.Dependencies``)
        - [if run failed] abort

- Worker

  - Update Submission object with status ``FINISHED`` (``SubmissionStatus.FINISHED``)
  - Kill the Container
  - Clean up the files and remove the lease

Health checking flow
********************

- WorkerHealthChecker (``FaultTolerance.Worker``)

  - Every n seconds

    - For each lease in the InMemoryStore

      - If lease - now's timestamp > threshold

        - Remove the lease from the InMemoryStore
        - Enqueue the submission id in the InMemoryStore

Getting the submission status flow
**********************************

- Client

  - Request Viewing Submission status via the submission id

- Request handler

  - Return Submission.response object (``SubmissionStatus.Result``)
