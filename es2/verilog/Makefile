TARGET = testbench
VLOG_FILES = fsm_tb.v
WAVE_FILE = fsm_tb.vcd

COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

.PHONY: all compile run view clean

all: run

compile:
	@echo "Compilando i file Verilog..."
	$(COMPILER) -o $(TARGET) $(VLOG_FILES)
	@echo "Compilazione completata. Eseguibile creato: $(TARGET)"

run: compile
	@echo "Eseguendo la simulazione..."
	$(SIMULATOR) $(TARGET)
	@echo "Simulazione terminata. File delle onde generato: $(WAVE_FILE)"

view:
	@echo "Aprendo $(WAVE_FILE) con GTKWave..."
	$(VIEWER) $(WAVE_FILE) &

clean:
	@echo "Pulizia dei file generati..."
	rm -f $(TARGET) $(WAVE_FILE)