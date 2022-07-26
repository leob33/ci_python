######################### CONFIG / FANCY STUFF #########################
SHELL=/bin/bash
.SHELLFLAGS = -e -c
.ONESHELL:

ifneq ($(TERM),)
normal:=$(shell tput sgr0)
bold:=$(shell tput bold)
red:=$(shell tput setaf 1)
green:=$(shell tput setaf 2)
yellow:=$(shell tput setaf 3)
blue:=$(shell tput setaf 4)
purple:=$(shell tput setaf 5)
cyan:=$(shell tput setaf 6)
white:=$(shell tput setaf 7)
gray:=$(shell tput setaf 8)
endif

######################### USEFUL COMMANDS #########################

clean-project:
	rm -rf .mypy_cache .pytest_cache reports .coverage build dist demo_app.egg-info

build-wheel:
	python -m build --wheel

######################### LOCAL CI #########################

DOCKER_IMAGE=python:3.10
COVERAGE=80
PROJECT_NAME=ci_python
PACKAGE_NAME=demo_app

.PHONY: install_dependencies check-source safety-check test-python run-ci-pipeline \
 run-ci-pipeline-with-dependency-installation run_ci_docker

install_dependencies:
	pip install -r requirements.txt
	pip install -r requirements_dev.txt

check-source:
	@echo "$(bold)$(blue) ================== flake8 ==================$(normal)"
	flake8 $(PACKAGE_NAME)
	@echo "$(bold)$(green)================== mypy ==================$(normal)"
	mypy $(PACKAGE_NAME)
	@echo "$(bold)$(purple)================== vulture ==================$(normal)"
	vulture $(PACKAGE_NAME)

safety-check:
	@echo "$(bold)$(yellow)================== safety ==================$(normal)"
	bandit $(PACKAGE_NAME)
	semgrep --config auto

test-python:
	@echo "$(bold)$(cyan)================== pytest ==================$(normal)"
	pytest --cov=$(PACKAGE_NAME) --cov-report=html:reports/pytest/cov_html --cov-fail-under=$(COVERAGE)

run-ci-pipeline: check-source safety-check test-python

run-ci-pipeline-with-dependency-installation: install_dependencies run-ci-pipeline

run-ci-docker:
	docker run -t --rm \
	-v /Users/leo.babonnaud/octo_mission/ci_python:/ci_python \
	--workdir /$(PROJECT_NAME) \
	$(DOCKER_IMAGE) \
	make run-ci-pipeline-with-dependency-installation
