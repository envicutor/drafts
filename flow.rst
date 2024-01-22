Activity flow
#############

What it is
**********
Provided are simplified sequence of steps that Envicutor takes to achieve certain goals (ie. to complete certain flows).
Next to some steps, there are labels in parentheses that refer to the labels in the :ref:`requirements <requirements>`.

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
    ``SubmissionRequests.Environment``
    ):

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
        "limits":{
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
          "submission_id": id,
          "invisibility_timestamp": timestamp,
          "request": the client request mentioned above
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

  - Store Submission object in SubmissionStore
  - Send a message to the SubmissionMessages

    - submission_id: id

- Worker

  - Consume message from the SubmissionMessages component
  - Keep updating the "invisibility timestamp" of the Submission object every n secs to signal that you are healthy
  - Create Dependencies object

    .. code-block::

      {
        "dependencies_id": string,
        "invisibility_timestamp": timestamp,
        "dependencies": content of cutor.nix
      }

  - Store Dependencies object in BuildStore
  - Send message to BuildMessages

    - build_id: string

  - Wait for the result

- CacheBuilder

  - Retrieve Dependencies object
  - Install Dependencies in Cache (``SubmissionRequests.cache``, ``Performance.Cache``)

    - Put content of Dependencies object "content of cutor.nix" in a cutor.nix file
    - nix-shell on the directory of the files
    - [if nix-shell fails] go to last step
    - [if Process takes more than pre-determined memory, time, stdout, stderr] go to last step

  - Send the corresponding stdout, stderr, time, signal to BuildMessages

- Worker

  - Consume message from CacheBuilder
  - [if inappropriate received signal] update Submission object accordingly and go to last step
  - Modify submission request with the new status

    - Update "status" to "status":"DEPENDENCIES_INSTALLED" (``SubmissionStatus.DependenciesInstalled``)

  - Create a docker container as a child process and mount:

    - /nix (from the "cache" volume)
    - shell.nix, nixpkgs tarball, worker program (shall be on the filesystem from the base image) (Performance.Nix)
    - cutor.nix, files, cutor-compile.sh, cutor-run.sh, cutor-env.sh, cutor-args.sh, cutor-inputs.sh
      (created from the submission request)
    - (``Isolation.Submission``, ``Security``, ``Escaping``)

  - Run the runner program which:

    - Start nix-shell to isolate the dependencies (``Isolation.Dependencies``)
    - Export cutor-env.sh
    - [if specified in the Submission object] Run compile.sh

      - On output, error, exit: signal to parent process (``SubmissionStatus.Compiled``)
      - [if compile failed] abort
      - [if Process takes more than pre-determined memory, time, stdout, stderr] signal to parent process, abort

    - For each case in submission.test_cases

      - Run run.sh and provide it arguments from cutor-args.sh and input from cutor-inputs.sh

        - On output, error, exit: signal to parent process (``SubmissionStatus.Ran``)
        - [if Process takes more than pre-determined memory, time, stdout, stderr] signal to parent process, abort

  - Listen to child process signals and update submission object accordingly
  - Stop and delete the Docker container
