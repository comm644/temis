TMPLOG = tests\log.tmp


all:
	php licdeploy.php .  | sort > $(TMPLOG)
	diff -Naur $(TMPLOG) tests\expected.log
	$(RM) $(TMPLOG)
	php tests\example.php
	xsltproc tests\example.xsl tests\example.xsl