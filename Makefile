SHELL := bash

ROOT := $(shell pwd -P)

NAME := HelloWasm
name := $(shell tr A-Z a-z <<<'$(NAME)')

GRAAL_TAR := graalvm-jdk-25.0.0-ea.15_linux-x64_bin.tar.gz
GRAAL_URL := https://github.com/graalvm/oracle-graalvm-ea-builds/releases/download/jdk-25.0.0-ea.15/$(GRAAL_TAR)
GRAAL_DIR := graalvm-jdk-25+14.1
BINARYEN_TAR := binaryen-version_123-x86_64-linux.tar.gz
BINARYEN_URL := https://github.com/WebAssembly/binaryen/releases/download/version_123/$(BINARYEN_TAR)
BINARYEN_DIR := binaryen-version_123
NVM_REPO := https://github.com/nvm-sh/nvm
NODE_VERSION := v22.0.0
NVM_DIR := $(ROOT)/nvm
NVM_BIN := $(NVM_DIR)/versions/node/$(NODE_VERSION)/bin


export NVM_DIR


CLEAN += $(NAME).class $(NAME).jar manifest.txt $(name).js* $(name).wasm $(name)-build-report.html
REALCLEAN += $(GRAAL_TAR) $(GRAAL_DIR) $(BINARYEN_TAR) $(BINARYEN_DIR) $(NVM_DIR)

export JAVA_HOME := $(GRAAL_DIR)
export PATH := $(GRAAL_DIR)/bin:$(BINARYEN_DIR)/bin:$(NVM_BIN):$(PATH)


run: $(name).js.wasm $(NVM_DIR)
	node $(name).js

run-jar: $(NAME).jar
	java -jar $<

clean:
	$(RM) -r $(CLEAN)

realclean: clean
	$(RM) -r $(REALCLEAN)

$(name).js.wasm: $(NAME).jar $(BINARYEN_DIR)
	native-image \
	  -jar $< \
	  --tool:svm-wasm \
	  --emit=build-report \
	  -o $(name)
	touch $@

%.jar: %.class manifest.txt
	jar -cfm $@ manifest.txt $<

manifest.txt:
	echo 'Main-Class: $(NAME)' > $@

%.class: %.java $(JAVA_HOME)
	javac $<

$(GRAAL_DIR): $(GRAAL_TAR)
	tar xf $<
	touch $@

$(GRAAL_TAR):
	wget -q $(GRAAL_URL)

$(BINARYEN_DIR): $(BINARYEN_TAR)
	tar xf $<
	touch $@

$(BINARYEN_TAR):
	wget -q $(BINARYEN_URL)

$(NVM_DIR):
	git clone $(NVM_REPO)
	git -C $@ checkout v0.40.2
	source nvm/nvm.sh && \
	  nvm install $(NODE_VERSION)
