- What is your project?
  - A code execution system; a back-end system that takes execution requests from clients, executes the code and
    returns the output and other metadata about the execution (like time, memory consumed and etc.)
- What is the use of code execution systems?
  - Powering systems that depend on code execution like coding contests websites and interactive programming
    learning websites
  - Such systems delegate the code execution responsibility to a code execution system
- How does it differ from other code execution systems?
  - There is a problem with other code execution systems like Piston and Judge0: code can only be executed
    using the dependencies that are specified in the code execution system.
    - The client has to hope that the code execution system supports their dependencies.
    - The client has to contact the developers of the code execution system in order to add support for additional
      dependencies
    - This leads to slowing down business processes
    - Think of a coding contests website administrator who wants to add new programming languages in contests but can't
      because the code execution system they are using does not support these programming languages
    - Piston's GitHub repo is full of issues asking for certain programming languages and libraries support
  - Envicutor allows on-the-fly installation (and caching) of client-specified dependencies in order not to be
    restricted to certain dependencies
- How complex is the system? What are the challenges?
  - At first, the system might seem trivial:
    - Let the client specify 4 scripts:
      - One for setting up the package dependencies (e.g, compilers)
      - One for additional dependencies set up (e.g, libraries)
      - One for compiling the code
      - One for running the code
    - Run the four scripts on the code execution system and return the result
  - However, it is not that simple:
    - How do you ensure the client does not damage the underlying code execution system?
    - How do you ensure the client does not affect nor see other clients executions executing at the
      same time (isolation)?
    - How do you ensure clients do not exhaust the code execution systems' resources while giving fair resources to
      each client?
    - How to make the dependencies not global? i.e, each client has access to the dependencies it asked for
    - How do you let the client specify the dependencies?
    - How do you download the dependencies?
    - How do you cache the downloaded dependencies?
    - After caching the downloaded dependencies, how do you ensure clients do not inject trojan horses in the cache?
    - Since the cache shall be global (since we cache from all clients),
      and since executions shall be isolated (as mentioned), then how to make execution requests make use of the cache?
