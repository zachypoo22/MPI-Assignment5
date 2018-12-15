#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH -N 12
#SBATCH --ntasks-per-node 4

set -x

echo $SLURM_SUBMIT_DIR

module load mpi/gcc_openmpi

cd /scratch
mpicc hello.c

for i in {2..12..2}
do
  echo "With ${i} processes"
  time mpirun --allow-run-as-root -np $i ./a.out
done
