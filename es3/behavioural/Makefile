# --- CONFIGURAZIONE ---
# Inserisci qui il nome dell'entità del tuo testbench (senza .vhd)
TESTBENCH = FSMD_tb

# Inserisci qui tutti i tuoi file VHDL, l'ordine è importante
# (prima le entità, poi i testbench che le usano)
VHDL_FILES = FSMD.vhd FSMD_tb.vhd 

# Nome del file di output per le forme d'onda
WAVE_FILE = wave.ghw

# --- COMANDI ---

# Comando predefinito (eseguito con un semplice "make")
all: run

# Analizza (compila) i file VHDL
compile:
	@echo "--- Analizzando i file VHDL... ---"
	ghdl -a $(VHDL_FILES)

# Elabora, esegue e genera il file delle forme d'onda
run: compile
	@echo "--- Eseguendo la simulazione... ---"
	ghdl -r $(TESTBENCH) --wave=$(WAVE_FILE)

# Apre il file delle forme d'onda con GTKWave
view:
	@echo "--- Aprendo GTKWave... ---"
	gtkwave $(WAVE_FILE)

# Pulisce la directory dai file generati dalla simulazione
clean:
	@echo "--- Pulizia dei file generati... ---"
	rm -f *.o *.cf $(WAVE_FILE) work-obj93.cf