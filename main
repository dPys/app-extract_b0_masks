#!/bin/bash
#SBATCH --job-name="extract_b0_masks"
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00

set -x
set -e

function abspath { echo $(cd $(dirname $1); pwd)/$(basename $1); }

dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`

num_processes=4
backend='loky'

echo `abspath $dwi`
echo `abspath $bvals`

singularity exec --cleanenv -e docker://dpys/extract_b0_mask:latest extract_b0_masks.py `abspath "$dwi"` `abspath "$bvals"` "$num_processes" "$backend"
