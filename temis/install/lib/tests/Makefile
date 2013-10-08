
.SUFFIXES: .php .xml .sql


SOURCES=$(wildcard test*.php)
PHP = c:\php5\php

.PHONY: all $(SOURCES) 


all:  
	$(PHP) runner.php
	
$(SOURCES):
	$(PHP) runner.php $@
