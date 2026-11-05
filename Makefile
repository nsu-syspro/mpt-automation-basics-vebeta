NAME    := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC     := src/wordcount.c
BUILD   := build
TARGET  := $(BUILD)/$(NAME)

CC      := gcc
CFLAGS  := -Wall -Wextra -DNAME='"$(NAME)"' -DVERSION='"$(VERSION)"'

TESTS      := $(wildcard test/*.txt)
TEST_CASES := $(TESTS:%.txt=%.test)

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SRC) -o $@

clean:
	rm -rf $(BUILD)

check: $(TARGET) $(TEST_CASES)
	@:

test/%.test: test/%.txt test/%.expected $(TARGET)
	@./$(TARGET) $< | diff -u test/$*.expected -
