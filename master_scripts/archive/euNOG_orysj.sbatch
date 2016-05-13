#!/bin/bash
#SBATCH -J euNOG_orysj           # job name
#SBATCH -o euNOG_orysj.o%j       # output and error file name (%j expands to jobID)
#SBATCH -n 1              # total number of mpi tasks requested
#SBATCH -c 16                #number of CPUs/task
#SBATCH -p normal     # queue (partition) -- normal, development, etc.
#SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=cmpalmer15.utexas.edu
#SBATCH --mail-type=begin  # email me when the job starts
#SBATCH --mail-type=end    # email me when the job finishes


### Nothing needs to change below here
module load launcher;
export EXECUTABLE=$TACC_LAUNCHER_DIR/init_launcher
export WORKDIR=.
cd $WORKDIR;
$TACC_LAUNCHER_DIR/paramrun $EXECUTABLE $CONTROL_FILE;
