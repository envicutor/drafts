Overview
########

.. _purpose-of-ces:

Example use cases for online :term:`code execution systems <code execution system>` in general
**********************************************************************************************
- Handling code execution in programming competitions and exercises websites
  by running programs users send and returning (and/or validating) the results.
- Handling code execution in online coding playgrounds where users can experiment with certain programming languages
  without downloading their tools locally.
- Basically powering any system that makes use of arbitrary remote code execution.

How code execution systems complement online IDEs
*************************************************

Online IDEs are full-stack systems that can integrate with code execution systems to be able to run code.

The clients and stakeholders of a code execution system
*******************************************************

The clients of a code execution system are other systems, like online IDEs or programming exercises websites, not human
users. Human users are clients to the clients.

Consequently, the stakeholders of a code execution system include any person who participates in building
a system that makes use of remote code execution.

How some code execution systems work (and the problem)
******************************************************
Code execution systems like `Piston <piston-repo_>`_, `Judge0 <judge0-repo_>`_ and `Sandkasten <sandkasten-repo_>`_
are typically coded with support for certain :term:`dependencies`
(compilers, packages, etc.) that the user can run their code with.
Adding support for new dependencies requires modifying the code execution system (i.e, modifying the code repository).

For example, in Judge0,
`the Java JDK 13.0.1 dependency is pre-determined.
<https://github.com/judge0/compilers/blob/92fa2173c0e5ae02922bf1939085db986dfbf5c4/Dockerfile#L92>`_
Using a higher Java version would require modifying the linked Dockerfile and rebuilding Judge0.

.. note::

  Piston provides a more decoupled approach to adding packages that does not require rebuilding the system
  but adding packages requires a high amount of effort.

A high-level view of how such code execution systems work is as follows:

- **Client to system:** please execute program P that requires certain dependencies.
- If these dependencies are supported (the code execution system has these dependencies pre-determined in the code):

  - **System:** executes program P and returns the output.

- Else:

  - **System:** error.

.. _how-it-works:

How |product-name| works (and the problem's solution)
*****************************************************
|Product-name| allows clients to specify the dependencies for their program.
A high-level view of how it works is as follows:

- **Client to system:** please execute program P with that needs certain dependencies.
- **System:** installs (if needed) the dependencies, executes the program and returns the output.

We aim to extend `Piston's <piston-repo_>`_, `Judge0's <judge0-repo_>`_, and `Sandkasten's <sandkasten-repo_>`_
features with the ability to run programs with arbitrary dependencies.

Questions
*********

What programming languages does |product-name| support?
=======================================================

Any language that can possibly run on |product-name|'s operating system.

Since |product-name| allows the specification of arbitrary :term:`dependencies`
(which includes the available packages like compilers and interpreters during program execution)
then |product-name| shall be able to run any language.
