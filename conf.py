# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'Envicutor System Specification'
copyright = '2023, Ahmed Wael, Adham Hazem, Omar Brikaa, Mostafa Ahmed, Ali Esmat'
author = 'Ahmed Wael, Adham Hazem, Omar Brikaa, Mostafa Ahmed, Ali Esmat'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ['sphinx.ext.todo']
todo_include_todos = True

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

latex_elements = {
  'maxlistdepth': '99',
  'preamble': r"""
\let\cleardoublepage=\clearpage
"""
}

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_book_theme'
html_static_path = ['_static']

rst_epilog = """
.. include:: /include/links.rstinc
.. include:: /include/substitutions.rstinc
"""
numfig = True
