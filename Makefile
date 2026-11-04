NAME    := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC     := src/wordcount.c
BUILD   := build
TARGET  := $(BUILD)/$(NAME)

CC      := gcc
CFLAGS  := -Wall -Wextra -DNAME='"$(NAME)"' -DVERSION='"$(VERSION)"'

TESTS_SRC := $(wildcard test/*.txt)
TESTS_RUN := $(patsubst test/%.txt,test/%.check,$(TESTS_SRC))

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SRC) -o $@

clean:
	rm -rf $(BUILD)

check: $(TARGET) $(TESTS_RUN)
	@echo "All tests passed!"

test/%.check: test/%.txt $(TARGET)
	@./$(TARGET) $< | diff -u test/$*.expected - || (echo "Test failed: $<"; exit 1)
	@touch $@
