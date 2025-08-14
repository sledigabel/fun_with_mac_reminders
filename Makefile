# Makefile for TODO Finder and Reminders

SWIFTC = swiftc
BIN_NAME = todo_finder
WORK_REMINDERS = work_reminders
MAIN_SRC = main.swift
WORK_SRC = work_reminders.swift

.PHONY: all clean run work_reminders

all: $(BIN_NAME) $(WORK_REMINDERS)

$(BIN_NAME): $(MAIN_SRC)
	$(SWIFTC) -o $(BIN_NAME) $(MAIN_SRC)

$(WORK_REMINDERS): $(WORK_SRC)
	$(SWIFTC) -o $(WORK_REMINDERS) $(WORK_SRC) -framework EventKit

clean:
	rm -f $(BIN_NAME) $(WORK_REMINDERS)

install: $(BIN_NAME) $(WORK_REMINDERS)
	cp $(BIN_NAME) /usr/local/bin/
	cp $(WORK_REMINDERS) /usr/local/bin/

run: $(BIN_NAME)
	./$(BIN_NAME) $(FILE)

run_work: $(WORK_REMINDERS)
	./$(WORK_REMINDERS)

help:
	@echo "Makefile for building the TODO Finder and Reminders tools"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Build all executables (default)"
	@echo "  clean     - Remove built executables"
	@echo "  install   - Install executables to /usr/local/bin/"
	@echo "  run       - Run the todo_finder program (use FILE=path/to/file.txt)"
	@echo "  run_work  - Run the work_reminders program"
	@echo "  help      - Display this help message"