#
# Make file for testing XITEC (XML Widget Compiler)
#

DIR_RESULT = result
DIR_EXPTD  = expected

TESTS_SRC := $(wildcard test-*.xsl)

TESTS = $(foreach src,$(TESTS_SRC:.xsl=.result),$(DIR_RESULT)/$(src))
TESTS_EXP = $(foreach src,$(TESTS_SRC:.xsl=.expected),$(DIR_EXPTD)/$(src))

XITEC = php ../compiler.php 
DIFF  = diff -Naur

.PHONY: all compile verify
.SUFFIXES: .xsl .result $(TESTS_EXP)

all: compile 

compile:
	@if not exist $(DIR_RESULT) mkdir $(DIR_RESULT)
	@echo Compile tests...
	@$(MAKE) $(TESTS_EXP)


verify:
	echo Testing....
	diff -Naur test/expected.xsl  result.tmp 
	echo PASSED
	del result.tmp


tests: $(TESTS)
	@echo tests: $(TESTS)


$(DIR_EXPTD)/%.expected: $(DIR_RESULT)/%.result
	@$(DIFF) $@ $<
	@echo $@: PASSED


$(DIR_RESULT)/%.result: %.xsl
	@$(XITEC) $< $@

clean:
	@$(RM) $(TESTS)
