Glossary
########

.. glossary::

  Code execution system
  Code execution engine
    A back-end system that lives in the cloud.
    It takes a request containing information about certain code to execute: language, source code, files, etc.
    and returns the result after (or, in some cases, during) executing the code.

  Dependencies
    The set of packages (programming language compilers, execution tools, etc.) that are available during execution,
    their configuration and the needed environment variables.

  Nix
    A declarative package manager that |product-name| uses to install and cache submission dependencies.
    https://nixos.org/

  nsjail
    A sandboxing software that allows for isolation from the host and other processes.
    https://github.com/google/nsjail

  STDOUT
    Standard output.

  STDERR
    Standard error.
