# Contributing to KubeSail Docs

An introduction to contributing to the KubeSail Docs.

The KubeSail team welcomes documentation improvements from developers and
users in the open source community. To contribute to the docs, click **Edit on GitHub** at the top of this page.

## Reporting an Issue

Anyone with a GitHub account can file an issue (bug report) against the KubeSail documentation. File an issue if you see a problem on an existing page or if you want to request new content.

Please include as much detail as you can. If the problem is visual (for example a theme or design issue), please add a screenshot.

## Installing for Development

The KubeSail documentation is written in Markdown and processed and deployed using MkDocs. You'll need [Python] installed on your system, as well as the Python package manager, [pip]. Then, [install MkDocs].

After that, fork and clone the repository.

```bash
git clone https://github.com/<your-github-username>/kubesail-docs.git
```

Change into the new directory, install your dependencies, and run the project locally.

```bash
cd kubesail-docs
pip install
mkdocs serve
```

## Project layout

Updates to the navigation can be made in the YML configuration file. Other content can be updated in the Markdown files.

```yml
mkdocs.yml    # The configuration file.
docs/
    README.md  # The documentation homepage.
    ...       # Other markdown pages, images and other files.
```

## Submitting Pull Requests

Once you are happy with your changes or you are ready for some feedback, push
it to your fork and send a pull request.

[Python]: https://www.python.org/
[pip]: https://pip.readthedocs.io/en/stable/installing/
[install MkDocs]: https://www.mkdocs.org/#installation
