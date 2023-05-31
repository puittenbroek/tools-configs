# Tools and config

To make the life of developers easier! If you have tips, suggestions or something else, feel free to open up an issue!

There are so many great tools out there, this is just a selection of those I worked with in the past.

## Local environment

Some tools to help managing stuff on your local computer.

* [Node version manager](https://github.com/nvm-sh/nvm), to easily manage
  multiple node/npm versions.

* [Pyenv](https://github.com/pyenv/pyenv): Python version managment, to easily
  have multiple python versions available.

* [virtualenvwrapper](
  https://virtualenvwrapper.readthedocs.io/en/latest/index.html): Helps
  managing virtualenvs.


* [oh-my-bash](https://github.com/ohmybash/oh-my-bash)  (ref: 177864fc5c2428c1c636f075299cd705727cee06)
    * Patch with `oh-my-bash.patch` for some nicer coloring.
    * see `.basrc` for current plugins/completions




## Dependency management

There are various tools around that can help you keeping track of your project dependencies.

 * [Poetry](https://github.com/python-poetry/poetry)
 * [pip-tools](https://github.com/jazzband/pip-tools)

I'm personally not a big fan of poetry, it does 'too much' and its dependency resolvement can be very slow. 
In the past (unconfirmed in latest versions) it was also impossible to upgrade a single dependency without causing the entire tree to be rebuild.
So if we wanted to upgrade `black`, we also upgrade `sqlalchemy` due to our requirement being 'greater then'.

`pip-tools` (pip-sync, pip-compile) did was expected, kept my local environment clean and up-to-date without too much hassle.

## Security

Two great tools which can help you keeping your code (more) secure.

 * [pip-audit](https://github.com/pypa/pip-audit)
    > pip-audit is a tool for scanning Python environments for packages with known vulnerabilities.
 * [bandit](https://github.com/PyCQA/bandit)
    > Bandit is a tool designed to find common security issues in Python code.

## Python code formatting

* [Black](https://github.com/psf/black)
* [Flake8](https://github.com/PyCQA/flake8)
* [iSort](https://github.com/PyCQA/isort)


### Configuration

One of the downside of the various tools, is that there is no **SINGLE** configuration file that works for all. <br/>
Some support `setup.cfg`, others also support `pyproject.toml`. And others have their own..

Example config for Black and isort via `pyproject.toml`
```toml
[tool.black]
line-length = 160
target-version = ['py38']
preview = true

[tool.isort]
profile = "black"
py_version = 38
line_length = 160
case_sensitive = false
combine_as_imports = true
force_sort_within_sections = true
lines_after_imports = 2
order_by_type = false
known_first_party=["xs2event_common", "test"]
```


Example config for flake8 via `.flake8` (there are other ways to config this obviously):
```cfg
[flake8]
max-line-length = 160
ignore = E121, E123, E126, E133, E226, E241, E242, E402, E70, E501, E722, W504, E127, E128, E131, W503
exclude =
    .cache/,
    .tox/,
    .git/,
    migrations/,
    manager*,
    ./xs2event_api/config,
    ./config
  ```

## Pre-commit hooks

Having tool help you format your code and enforce security or coding styles is nice. But people might forget them.
Or use `--no-verify` to bypass them (hopefully with a valid reason ;) ). Having it setup in your CI is important to ensure that the code going to our main branch is up to par.

[Pre-commit](https://pre-commit.com/) for good pre-commit hooks


Example `.pre-commit-config.yaml`
```yaml
repos:
  - repo: local
    hooks:
      - id: flake8
        name: Run flake8
        language: python
        pass_filenames: false
        entry: flake8
        types: [file,python]
      - id: bandit
        name: Run bandit
        language: python
        pass_filenames: false
        entry: bandit . -ll
        types: [file,python]
      - id: black
        name: Run black
        language: python
        entry: black
        types: [file,python]
      - id: isort
        name: Run isort
        language: python
        entry: isort
        types: [file,python]

```

And in your `.gitlab-ci.yml` you run it against all the files:
```yaml
linting:
  stage: quality
  script:
    - pre-commit run --all-files
```

## Testing

Writing test is very important, especially when fixing bugs. Having a regression test prevents you from making the same mistakes twice.
Visualsing what part of your code is hit by your tests, helps you write better tests.

* [Pytest](https://docs.pytest.org/en/7.3.x/)
  * Fixtures
* [Factory boy](https://factoryboy.readthedocs.io/en/stable/)
* [Coverage](https://github.com/nedbat/coveragepy)



## Other tools

* Jira - project management
* Sentry - error reporting
* Prometheus - metric gathering
* Grafana - visualizing metrics
