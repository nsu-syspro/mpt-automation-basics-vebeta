NAME    := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

SRC     := src/wordcount.c
BUILD   := build
TARGET  := $(BUILD)/$(NAME)

CC      := gcc
CFLAGS  := -Wall -Wextra -DNAME='"$(NAME)"' -DVERSION='"$(VERSION)"'

.PHONY: all clean check

all: $(TARGET)

$(TARGET): $(SRC) config.json
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(SRC) -o $@

clean:
	rm -rf $(BUILD)

TESTS := $(wildcard test/*.txt)

check: $(TARGET)
	@for t in $(TESTS); do \
	    exp="$${t%.txt}.expected"; \
	    out="$$(mktemp)"; \
	    ./$(TARGET) "$$t" > "$$out"; \
	    if ! diff -u "$$exp" "$$out"; then \
	        echo "Test FAILED: $$t"; \
	        rm -f "$$out"; \
	        exit 1; \
	    fi; \
	    rm -f "$$out"; \
	done
