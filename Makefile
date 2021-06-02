SHELL:=/bin/bash

PROJECT := azure-guardrails
PROJECT_UNDERSCORE := azure_guardrails

# ---------------------------------------------------------------------------------------------------------------------
# Environment setup and management
# ---------------------------------------------------------------------------------------------------------------------
setup-env:
	python3 -m venv ./venv && source venv/bin/activate
	python3 -m pip install -r requirements.txt
setup-dev: setup-env
	python3 -m pip install -r requirements-dev.txt
clean:
	rm -rf dist/
	rm -rf build/
	rm -rf *.egg-info
	find . -name '*.pyc' -delete
	find . -name '*.pyo' -delete
	find . -name '*.egg-link' -delete
	find . -name '*.pyc' -exec rm --force {} +
	find . -name '*.pyo' -exec rm --force {} +
# ---------------------------------------------------------------------------------------------------------------------
# Git Submodules updates
# This is necessary because we leverage a Microsoft Azure repository as a data source.
# ---------------------------------------------------------------------------------------------------------------------
update-submodule:
	git submodule init
	git submodule update
update-submodule-with-merge:
	git submodule init
	git submodule update --remote --merge
# ---------------------------------------------------------------------------------------------------------------------
# ReadTheDocs
# ---------------------------------------------------------------------------------------------------------------------
build-docs: setup-dev
	mkdocs build
serve-docs: setup-dev
	mkdocs serve --dev-addr "127.0.0.1:8001"
# ---------------------------------------------------------------------------------------------------------------------
# Package building and publishing
# ---------------------------------------------------------------------------------------------------------------------
build: clean setup-env update-submodule
	python3 -m pip install --upgrade setuptools wheel
	python3 -m setup -q sdist bdist_wheel
install: build
	python3 -m pip install -q ./dist/${PROJECT}*.tar.gz
	${PROJECT} --help
uninstall:
	python3 -m pip uninstall ${PROJECT} -y
	python3 -m pip uninstall -r requirements.txt -y
	python3 -m pip uninstall -r requirements-dev.txt -y
	python3 -m pip freeze | xargs python3 -m pip uninstall -y
publish: build
	python3 -m pip install --upgrade twine
	python3 -m twine upload dist/*
	python3 -m pip install ${PROJECT}
# ---------------------------------------------------------------------------------------------------------------------
# Python Testing
# ---------------------------------------------------------------------------------------------------------------------
test: setup-dev
	python3 -m coverage run -m pytest -v
security-test: setup-dev
	bandit -r ./${PROJECT_UNDERSCORE}/
# ---------------------------------------------------------------------------------------------------------------------
# Linting and formatting
# ---------------------------------------------------------------------------------------------------------------------
fmt: setup-dev
	black ${PROJECT_UNDERSCORE}/
lint: setup-dev
	pylint ${PROJECT_UNDERSCORE}/
# ---------------------------------------------------------------------------------------------------------------------
# Miscellaneous development
# ---------------------------------------------------------------------------------------------------------------------
count-loc:
	echo "If you don't have tokei installed, you can install it with 'brew install tokei'"
	echo "Website: https://github.com/XAMPPRocky/tokei#installation'"
	tokei ./* --exclude --exclude '**/*.html' --exclude '**/*.json' --exclude azure_guardrails/shared/data/ --exclude azure_guardrails/shared/azure-policy --exclude examples --exclude docs --exclude tmp --exclude venv
github-actions-test:
	act -l
	# Run the CI job
	act -j ci
# ---------------------------------------------------------------------------------------------------------------------
# Tool specific testing
# ---------------------------------------------------------------------------------------------------------------------
terraform-validate: install
	sh utils/terraform-demo.sh
update-policy-table: install
	sh utils/update-policy-table.sh
update-data: setup-dev
	python3 ./update_data.py --dest azure_guardrails/shared/data/ --download
