#!/bin/bash 
# MTPDE.sbatch

#SBATCH -J MTPDE # A single job name for the array
#SBATCH -p serial_requeue # Partition
#SBATCH -n 1 # one core
#SBATCH -N 1 # on one node
#SBATCH -t 0-10:00 # Running time of 10 hours
#SBATCH --mem 1500 # Memory request of 1.5 GB
#SBATCH -o slurm_%A_%a.out # Standard output
#SBATCH -e slurm_%A_%a.err # Standard error

# this script is called as
# sbatch --array=1-30 simu_arrays.sbatch

mkdir param${SLURM_ARRAY_TASK_ID}_out
cp param${SLURM_ARRAY_TASK_ID}.mat ./param${SLURM_ARRAY_TASK_ID}_out/param.mat
cd param${SLURM_ARRAY_TASK_ID}_out
#cp param${SLURM_ARRAY_TASK_ID}.mat ./param.mat

scriptdir=`pwd |sed 's#/[^/]*/[^/]*/[^/]*$##'`  
#echo $scriptdir

#module load math/matlab-R2014b 
module load matlab/R2014b-fasrc01
#matlab -nojvm -nosplash -nodesktop < $scriptdir/callsimu.m
#matlab -nojvm -nosplash -nodesktop < "$scriptdir/callPDE.m; exit"
matlab -nojvm -nosplash -nodesktop < $scriptdir/callPDE.m
#matlab -nojvm -nosplash -nodesktop < "$scriptdir/callPDE.m; exit"

rm param.mat
cd ..
