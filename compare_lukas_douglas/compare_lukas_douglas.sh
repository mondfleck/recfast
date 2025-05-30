#!/bin/bash
#SBATCH --account=def-douglas
#SBATCH --time=00:05:00

# load

module load python/3.10
source ../ENV/bin/activate

#

# run
echo "Running compare_lukas_douglas.py"


srun python compare_lukas_douglas.py

echo "Done compare_lukas_douglas.py"

echo "File for ref:\n\n"
echo " --------------- \n\n"
echo "$(<compare_lukas_douglas.py )"
