Overview
########

.. _purpose-of-ces:

Purpose of online :term:`code execution systems <code execution system>` in general
***********************************************************************************
- Handling code execution in programming competitions and exercises websites
  by running programs users send and returning (and/or validating) the results.
- Handling code execution in online coding playgrounds where users can experiment with certain programming languages
  without downloading their tools locally.
- Basically powering systems that make use of arbitrary code execution.

.. _difference-between-ces-and-ide:

The difference between code execution systems and online IDEs
*************************************************************

Don't confuse :term:`code execution systems <code execution system>` with online IDEs.
Code execution systems are only back-end systems that are concerned with executing code.
Online IDEs are full-stack systems that can integrate with these code execution systems to provide code execution
functionalities.

The clients of a code execution system
**************************************

The clients of a code execution system are other systems, like online IDEs or programming exercises websites, not human
users. Human users are clients to the clients.

How some code execution systems work (and the problem)
******************************************************
Code execution systems like `Piston <piston-repo_>`_ and `Judge0 <judge0-repo_>`_ are typically coded with support for
certain :term:`execution environments <execution environment>`.
As a result, the number of execution environments a program can run in is limited to the number of supported execution
environments in the system.
Adding support for new execution environments requires modifying the code execution system.

A high-level view of how such code execution systems work is as follows:

- **Client to system:** please execute program P with configuration C and execution environment E.
- If E is a supported execution environment:

  - **System:** executes program P and returns the output.

- Else:

  - **System:** error.

.. _how-it-works:

How |product-name| works (and the problem's solution)
*****************************************************
|Product-name| allows clients to specify the :term:`execution environment` their program will execute in.
A high-level view of how it works is as follows:

- **Client to system:** please execute program P with configuration C and execution environment E.
- **System:** sets up environment E, executes the program and returns the output.

The ultimate goal is to provide an intersection between `Piston's <piston-repo_>`_ (or `Judge0's <judge0-repo_>`_)
features and the ability to run programs in an arbitrary execution environment of the user's choice.

Questions
*********

What programming languages does |product-name| support?
=======================================================

Any language that can run on |product-name|'s system.

Since |product-name| allows the specification of arbitrary execution environments
and since the term ":term:`execution environment`" includes the available packages during program execution
which can include compilers and interpreters, then |product-name| shall be able to run any language that has support
for its system.

`Repl.it <replit-website_>`_ provides the ability to configure execution environments, how is |product-name| different?
=======================================================================================================================

Repl.it is an online IDE that does not expose its code execution system
(check :ref:`the difference between an online IDE and a code execution system <difference-between-ces-and-ide>`).
Hence, Repl.it can not be used for the :ref:`purposes our code execution system is used for <purpose-of-ces>`.
