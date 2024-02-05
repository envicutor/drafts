.. _flow:

Activity flow
#############

What it is
**********
Provided are simplified sequence of steps that Envicutor takes to achieve certain goals (ie. to complete certain flows).
Next to some steps are some labels in parentheses that refer to the labels in the :ref:`requirements <requirements>`
to show how the requirements are satisfied.

Execution flow
**************

- Client

  - Send :ref:`submission request <interface-objects>` (``SubmissionRequests.files``,
    ``SubmissionRequests.Dependencies``,
    ``SubmissionRequests.compile``,
    ``SubmissionRequests.run``,
    ``SubmissionRequests.files``,
    ``SubmissionRequests.PerRequestLimits``,
    ``Configurability.limits``,
    ``SubmissionRequests.Run.Multiple``,
    ``SubmissionRequests.STDIN``,
    ``SubmissionRequests.ARGS``):

    .. code-block::

      {
        "files": [
          {
            "name": "cutor.nix",
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

  - Create :ref:`Submission object <interface-objects>` (``SubmissionStatus.Submitted``):

    .. code-block::

      {
        "id": id,
        "lease": null,
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

  - Store that Submission object in SubmissionStore
  - :ref:`Enqueue the submission id <queues-channels>` in the SubmissionStore
  - Return the submission id to the client

- Worker

  - Pop submission id from the SubmissionStore
  - Fetch the corresponding Submission object
  - Keep updating the lease of the Submission object every n milliseconds with now's timestamp
    to signal that you are healthy

    - If the submissions's status is "FINISHED", stop updating the lease

  - Check which dependencies requisites are not cached
  - If there are requisites that are not cached

    - Create a :ref:`Dependencies object <interface-objects>`

      .. code-block::

        {
          "id": id,
          "lease": timestamp,
          "paths": string
        }

    - Store the Dependencies object in the BuildStore
    - :ref:`Enqueue the Dependencies object id <queues-channels>` in the BuildStore
    - Wait for a reply in the BuildStore

      - If reply takes too long, go to clean up step (abort)

- CacheBuilder

  - Pop the Dependencies object id from the BuildStore
  - Retrieve the corresponding Dependencies object
  - Keep updating the lease of the Dependencies object every n milliseconds with now's timestamp
    to signal that you are healthy

    - If the Dependencies object does not exist anymore, stop updating the lease

  - Install the dependencies (with the Cache volume mounted) (``Performance.Cache``):

    - [if the process fails] go to last step
    - [if Process takes more than pre-determined memory, time, stdout, stderr] go to last step

  - Send the a message containing the stdout, stderr, time, signal,
    code of the installation process to the BuildStore :ref:`as a reply to the worker <queues-channels>`
  - Delete the Dependencies object from the BuildStore (not from the cache)

- Worker

  - If dependencies are not cached:

    - Consume the message that the CacheBuilder sent
    - [if inappropriate received signal or code] update Submission object accordingly and go to last step

  - Modify submission request status to ``DEPENDENCIES_INSTALLED`` (``SubmissionStatus.DependenciesInstalled``)

  - Create directory with the submission id as its name with:

    - ``cutor.nix``, files, ``cutor-compile.sh``, ``cutor-run.sh`` (created from the submission request)
    - ``shell.nix`` (mounted from the worker)

  - If compilation is specified in the Submission object

    - Create :term:`nsjail` sandbox with:

      - ``cutor-compile.sh`` as its command
      - ``submission id`` directory created from the last step (mounted from the worker)
      - ``/nix`` (mounted from the "cache" volume)
      - The environment variables exported
      - (``Isolation.Submission``, ``Security``, ``Escaping``)

  - If compile is successful or no compile is specified:

    - Update Submission object with status ``COMPILED`` (``SubmissionStatus.Compiled``)

    - For each case in ``submission.test_cases``

      - Create :term:`nsjail` sandbox with:

        - ``cutor-run.sh`` as its command
        - [if run failed] aborts

  - Update Submission object with status ``FINISHED`` (``SubmissionStatus.FINISHED``)
  - Clean up files

Health checking flow
********************

- WorkerHealthChecker (``Availability.Worker``, ``FaultTolerance.Worker``)

  - Every n seconds

    - For each Submission object in SubmissionStore with lease not null and status not "FINISHED"

      - If lease - now's timestamp > threshold

        - Assume that the Worker that was working on it is dead
        - Reset the response and the lease of the Submission object in the SubmissionStore
        - Enqueue the submission id in the submission store

- CacheBuilderHealthChecker (``Availability.CacheBuilder``, ``FaultTolerance.CacheBuilder``)

  - Every n seconds

    - For each Dependencies object in BuildStore with lease not null and status not "FINISHED"

      - If lease - now's timestamp > threshold

        - Assume that the CacheBuilder that was working on it is dead
        - Reset the lease of the Dependencies object in the BuildStore
        - Enqueue the Dependencies object id in the BuildStore

Getting the submission status flow
**********************************

- Client

  - Request Viewing Submission status via the submission id

- Request handler

  - Return Submission.response object (SubmissionStatus.Result)
