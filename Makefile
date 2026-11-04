NAME    := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC     := src/wordcount.c
BUILD   := build
TARGET  := $(BUILD)/$(NAME)

CC      := gcc
CFLAGS  := -Wall -Wextra -DNAME='"$(NAME)"' -DVERSION='"$(VERSION)"'

TESTS_SRC := $(wildcard test/*.txt)
TESTS_RUN := $(patsubst test/%.txt,check_%,$(TESTS_SRC))

.PHONY: all clean check $(TESTS_RUN)

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SRC) -o $@

clean:
	rm -rf $(BUILD)

check: $(TARGET) $(TESTS_RUN)

check_%: test/%.txt $(TARGET)
	@./$(TARGET) $< | diff -u test/$*.expected - || (echo "Test failed: $<"; exit 1)
