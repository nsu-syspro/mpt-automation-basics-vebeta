NAME    := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC     := src/wordcount.c
BUILD   := build
TARGET  := $(BUILD)/$(NAME)

CC      := gcc
CFLAGS  := -Wall -Wextra -DNAME='"$(NAME)"' -DVERSION='"$(VERSION)"'

TESTS   := $(wildcard test/*.txt)

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SRC) -o $@

clean:
	rm -rf $(BUILD)

check: $(TARGET)
	@for t in $(TESTS); do \
		./$(TARGET) $$t | diff -u test/$$(basename $$t .txt).expected - || (echo "Test failed: $$t"; exit 1); \
	done
	@:
