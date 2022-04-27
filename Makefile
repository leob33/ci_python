
clean-project:
	rm -rf .mypy_cache .pytest_cache reports .coverage build dist

build-wheel:
	python -m build --wheel