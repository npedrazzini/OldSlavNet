ROOT_DIR:=./
VENV:= oldslavnet-venv
VENV_BIN_DIR:="$(VENV)/bin"

REQUIREMENTS_LOCAL:="./requirements.txt"

PIP:="$(VENV_BIN_DIR)/pip"

CMD_FROM_VIEW:=". $(VENV_BIN_DIR)/activate"

all: venv activate

venv:
	$(CMD_FROM_VIEW:): requirements.txt
	python3 -m venv $(VENV)
	@$(PIP) install --upgrade pip
	@$(PIP) install -r $(REQUIREMENTS_LOCAL)
	source $(VENV_BIN_DIR)/activate

activate: venv
	chmod a+rwx $(ROOT_DIR)/train.sh
	chmod a+rwx $(ROOT_DIR)/tag.sh

clean:
	rm -rf $(VENV)
	find . -type f -name '*.pyc' -delete

.PHONY: all venv run clean