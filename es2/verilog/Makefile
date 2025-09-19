# Makefile per la simulazione di progetti Verilog con iverilog

# --------------- PERSONALIZZAZIONE ---------------

# Nome dell'eseguibile di simulazione che verrà creato
TARGET = testbench

# Elenco di TUTTI i file Verilog da compilare (design + testbench)
# -> Modifica questa riga con i tuoi file!
VLOG_FILES = fsm.v fsm_tb.v

# Nome del file delle forme d'onda (waveform) che verrà generato
WAVE_FILE = waveform.vcd

# -----------------------------------------------

# Compilatore e strumenti
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

# Definisce i "target" che non sono file reali
.PHONY: all compile run view clean

# Target di default (eseguito con il comando 'make')
all: compile

# Compila i sorgenti Verilog
compile: $(VLOG_FILES)
	@echo "Compilando i file Verilog..."
	$(COMPILER) -o $(TARGET) $(VLOG_FILES)
	@echo "Compilazione completata. Eseguibile creato: $(TARGET)"

# Esegue la simulazione (e genera il file .vcd)
run: compile
	@echo "Eseguendo la simulazione..."
	$(SIMULATOR) $(TARGET)
	@echo "Simulazione terminata. File delle onde generato: $(WAVE_FILE)"

# Apre il file delle onde con GTKWave
view:
	@echo "Aprendo $(WAVE_FILE) con GTKWave..."
	$(VIEWER) $(WAVE_FILE)

# Pulisce la directory dai file generati
clean:
	@echo "Pulizia dei file generati..."
	rm -f $(TARGET) $(WAVE_FILE)