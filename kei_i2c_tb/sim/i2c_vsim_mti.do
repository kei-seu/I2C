onerror {resume}
onbreak {resume}
onElabError {resume}


# Simulation specific setup
set StdArithNoWarnings   1
set NumericStdNoWarnings 1

source $env(VRMDATA_DIR)/fullregr/i2c_wave_mti.do

if {[batch_mode]} {
   echo "Sim in batch mode"
   log -r /*
} else {
   echo "Sim in gui mode"
   log -r /* -depth 2
}

###########################################
# You may save coverage in the script OR
# specify it in the RMDB command actions
###########################################

## # Start the simulation
## run -a        
## 
## # Save coverage, and prepare for next run...
## coverage attribute  -name TESTNAME -value [format "%s" [file rootname $env(UCDBFILE)] ]
## coverage save      [format "%s" $env(UCDBFILE) ]
## 
## quit


