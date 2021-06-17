# Contributing

## Setup

* Set up the virtual environment

```bash
# Set up the virtual environment
python3 -m venv ./venv && source venv/bin/activate
pip3 install -r requirements.txt
```

* Build the package

```bash
# To build only
make build

# To build and install
make install

# To run tests
make test

# To clean local dev environment
make clean
```

## Other tasks

* Update with the latest Azure Compliance data

```bash
make update-data
```

* Update the policy summary tables

```bash
make update-policy-table
```

* Update the Azure Policy Git submodule and merge it

```bash
# Without merge
make update-submodule

# With merge
make update-submodule-with-merge
```
