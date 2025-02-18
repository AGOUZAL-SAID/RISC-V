.PHONY: clean program syn update

QUARTUS_CMD = @quartus_sh -t DoQuartus.tcl -revision

all: syn

syn:
	$(QUARTUS_CMD) riscv

program: riscv.sof
	@echo "#########################################"
	@echo "####### Programmation de la carte #######"
	@echo "#########################################"
	@quartus_pgm -c DE-SoC  -m JTAG -oP\;$<@2 -oS\;SOCVHPS@1

update:
	quartus_cdb --update_mif riscv
	quartus_asm riscv

clean:
	-rm -rf db *.jdi *.qsf *.qpf *.sof *.pof *.rpt *.summary *.done *.pin *.smsg *.qws ram.lst incremental_db
	-rm -f c5_pin_model_dump.txt
