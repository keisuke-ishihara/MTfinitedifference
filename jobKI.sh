#!/bin/bash -i
#$ -S /bin/bash
#
# MPI-PKS script for job submission script with 'qsub'.
#
# modified by Keisuke Ishihara, 2016/10/03
# note that the qsub options need to have their lines beginning with #$
#
# starting in the directory that contains the parameter files for the simulations,
# the script is called as 
#
#	qsub -t 1-3 ../../MTfinitedifference/jobKI.sh 
#

# --- Mandatory qsub arguments
# Hardware requirements.

#$ -l h_rss=300M,h_fsize=1000M,h_cpu=24:00:00,hw=x86_64

# --- Optional qsub arguments
# Change working directory - your job will be run from the directory
# that you call qsub in.  So stdout and stderr will end up there.

#$ -cwd 								  # Change working directory to pwd of submit
#$ -j n                                   # split stdout and stderr 

simdir=$(pwd)
scriptdir=~/MTfinitedifference

#--- Job Execution
#For faster disk access copy files to /scratch first.

scratch=/scratch/$USER/$$	# $$ is the process ID variable
mkdir -p $scratch			# -p no error if existing, make parent directories as needed
cd $scratch

#copy input file specified by task ID to current directory (=scratch directory)
cp $simdir/param${SGE_TASK_ID}.mat ./param.mat

#Execution - running the actual program.
#[Remember: Don't read or write to /home from here.]
echo "Running on $(hostname)"
echo "We are in $(pwd)"
echo

#run the program in this line
matlab -nojvm -nosplash -nodesktop < $scriptdir/callPDE_PKS.m
#matlab -nojvm -nosplash -nodesktop < $scriptdir/helloworld.m

echo "- end of Matlab session - "
echo

rm param.mat

# Finish - Copy files back to your home directory, clean up.
cp -r $scratch/. $simdir/param${SGE_TASK_ID}_out/
cd
rm -rf $scratch