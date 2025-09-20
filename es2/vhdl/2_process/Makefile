TESTBENCH = fsm_tb
VHDL_FILES = fsm.vhd fsm_tb.vhd 
WAVE_FILE = wave.ghw

all: run

compile:
	@echo "--- Analizzando i file VHDL... ---"
	ghdl -a $(VHDL_FILES)

run: compile
	@echo "--- Eseguendo la simulazione... ---"
	ghdl -r $(TESTBENCH) --wave=$(WAVE_FILE) --stop-time=5000ns

view:
	@echo "--- Aprendo GTKWave... ---"
	gtkwave $(WAVE_FILE)

clean:
	@echo "--- Pulizia dei file generati... ---"
	rm -f *.o *.cf $(WAVE_FILE) work-obj93.cf