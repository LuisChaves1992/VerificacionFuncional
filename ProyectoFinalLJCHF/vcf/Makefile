SHELL := /bin/bash
.ONESHELL:

PROJECT_ROOT := $(abspath $(CURDIR)/..)

vcf_cpu:
	source $(PROJECT_ROOT)/vcf/setup.sh
	mkdir -p work
	vcf -verdi -f cpu_vc_formal.tcl


clean:
	rm -rf work
	rm -rf vcst_rtdb
	rm -rf vcst_rtdb.bak
	rm -f novas.conf
	rm -f novas.rc
	rm -f vcst_command.log
	rm -f vcst_session.log
	rm -f vcst_session.log.bak
	rm -f .vcstPref
	rm -f vcf.log
	rm -f vcf.log.bak
	rm -f hector_command.log
	rm -rf .simon.out
