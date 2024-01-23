Activity flow
#############

What it is
**********
Provided are simplified sequence of steps that Envicutor takes to achieve certain goals (ie. to complete certain flows).
Next to some steps, there are labels in parentheses that refer to the labels in the :ref:`requirements <requirements>`
to show how the requirements are satisfied.

The execution flow
******************

- Client

  - Send submission request (``SubmissionRequests.files``,
    ``SubmissionRequests.Dependencies``,
    ``SubmissionRequests.compile``,
    ``SubmissionRequests.run``,
    ``SubmissionRequests.files``,
    ``SubmissionRequests.PerRequestLimits``,
    ``Configurability.limits``,
    ``SubmissionRequests.Run.Multiple``,
    ``SubmissionRequests.STDIN``,
    ``SubmissionRequests.ARGS``,
    ``SubmissionRequests.Environment``):

    .. code-block::

      {
        "files": [
          {
            "name": "cutor.nix",
            "content": "content"
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
        "env": {
          "key1": "value1",
          "key2": "value2",
          "key3": "value3"
        }
      }

- RequestHandler

  - Create Submission object (``SubmissionStatus.pending``):

    .. code-block::

      {
        "id": id,
        "lease": null,
        "request": the client request mentioned above,
        "response": {
          "status": "pending",
          "dependencies": {
            "stdout": "",
            "stderr": "",
            "time": "",
            "signal": ""
          },
          "compile": {
            "stdout": "",
            "stderr": "",
            "time": "",
            "signal": ""
          },
          "run": {
            "stdout": "",
            "stderr": "",
            "time": "",
            "signal": ""
          }
        }
      }

  - Store that Submission object in SubmissionStore
  - Send a message to the SubmissionStore containing the submission id

- Worker

  - Consume message from the SubmissionStore
  - Fetch the corresponding Submission object (according to the submission id in the message)
  - Keep updating the lease of the Submission object every n milliseconds with now's timestamp
    to signal that you are healthy
  - If dependencies are specified:

    - Check which dependencies requisites are not cached
    - If there are requisites that are not cached

      - Create a Dependencies object

        .. code-block::

          {
            "id": id,
            "lease": timestamp,
            "paths": string
          }

      - Send a message containing them to BuildStore
      - Wait for a reply in the BuildStore

- CacheBuilder

  - Consume a message from the BuildStore
  - Retrieve the corresponding Dependencies object (according to the dependencies object id in the message)
  - Keep updating the lease of the Dependencies object every n milliseconds with now's timestamp
    to signal that you are healthy
  - Install the dependencies (with the Cache volume mounted) (``SubmissionRequests.cache``, ``Performance.Cache``):

    - [if the process fails] go to last step
    - [if Process takes more than pre-determined memory, time, stdout, stderr] go to last step

  - Send the a message containing the stdout, stderr, time, signal, code of the installation process
    to the BuildStore as a reply to the consumed message
  - Delete the Dependencies object

- Worker

  - If dependencies are specified:

    - Consume message from CacheBuilder
    - [if inappropriate received signal or code] update Submission object accordingly and go to last step
    - Modify submission request with the new status (``SubmissionStatus.DependenciesInstalled``)

  - Create a docker container as a child process that has:

    - ``/nix`` (mounted from the "cache" volume)
    - ``shell.nix``, nixpkgs tarball, worker program (from the filesystem in the base image)
    - ``cutor.nix``, files, ``cutor-compile.sh``, ``cutor-run.sh``, ``cutor-env.sh``, ``cutor-args.sh``,
      ``cutor-inputs.sh`` (created from the submission request)
    - (``Performance.Nix``, ``Isolation.Submission``, ``Security``, ``Escaping``)

  - Run the worker program inside the container which:

    - Starts nix-shell to isolate the dependencies (``Isolation.Dependencies``)
    - Exports ``cutor-env.sh``
    - [if specified in the Submission object] Runs ``compile.sh``

      - On output, error, exit: signals to parent process
      - [if compile failed] aborts
      - [if Process takes more than pre-determined memory, time, stdout, stderr] signals to parent process, aborts

    - For each case in ``submission.test_cases``

      - Run ``run.sh`` and provide it arguments from ``cutor-args.sh`` and input from ``cutor-inputs.sh``

        - On output, error, exit: signal to parent process
        - [if Process takes more than pre-determined memory, time, stdout, stderr] signal to parent process, abort

  - Listen to child process signals and update Submission object accordingly
    (``SubmissionStatus.Compiled``, ``SubmissionStatus.Ran``)
  - Stop and delete the Docker container
