# Makefile per la simulazione di progetti Verilog con iverilog

# --------------- PERSONALIZZAZIONE ---------------

# Nome dell'eseguibile di simulazione che verrà creato
TARGET = testbench

# Elenco dei file Verilog da compilare.
# -> IMPORTANTE: Includi solo il file del testbench (top-level).
#    Gli altri file verranno inclusi automaticamente dalla direttiva `include.
VLOG_FILES = fsm_tb.v

# Nome del file delle forme d'onda (waveform) che verrà generato
WAVE_FILE = fsm_tb.vcd

# -----------------------------------------------

# Compilatore e strumenti
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = gtkwave

# Definisce i "target" che non sono file reali
.PHONY: all compile run view clean

# Target di default (eseguito con il comando 'make')
all: run

# Compila i sorgenti Verilog
compile:
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
	$(VIEWER) $(WAVE_FILE) &

# Pulisce la directory dai file generati
clean:
	@echo "Pulizia dei file generati..."
	rm -f $(TARGET) $(WAVE_FILE)