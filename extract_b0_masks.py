#!/usr/bin/env python3.8
import os
import sys
import argparse
import joblib
import numpy as np
import nibabel as nb
from nipype.utils.filemanip import fname_presuffix
from dipy.segment.mask import median_otsu

def extract_b0(in_file, b0_ix):
    """Extract the *b0* volumes from a DWI dataset."""

    out_path = fname_presuffix(in_file, suffix=f"_b0_{b0_ix}")

    img = nb.load(in_file)
    bzeros = np.squeeze(np.asanyarray(img.dataobj)[..., b0_ix])

    hdr = img.header.copy()
    hdr.set_data_shape(bzeros.shape)
    hdr.set_xyzt_units("mm")
    nb.Nifti1Image(bzeros, img.affine, hdr).to_filename(out_path)
    return out_path


def get_bval_indices(bvals, bval, tol=50):
    """
    Get indices where the b-value is `bval`
    Parameters
    ----------
    bvals: ndarray
        Array containing the b-values
    bval: float or int
        b-value to extract indices
    tol: int
        The tolerated gap between the b-values to extract
        and the actual b-values.
    Returns
    ------
    Array of indices where the b-value is `bval`
    """
    return np.where(np.logical_and(bvals <= bval + tol,
                                   bvals >= bval - tol))[0]

def make_b0_masks(dwi, b0_ix):
    b0s_file = extract_b0(dwi, b0_ix)

    # median_otsu
    b0s_ref_img = nb.load(b0s_file)
    b0_mask, mask = median_otsu(np.asarray(b0s_ref_img.dataobj), median_radius=4, numpass=2)
    mask_img = nb.Nifti1Image(mask.astype(np.float32), b0s_ref_img.affine)
    b0_img = nb.Nifti1Image(b0_mask.astype(np.float32), b0s_ref_img.affine)
    nb.save(b0_img, fname_presuffix(b0s_file, suffix="_brain", use_ext=True))
    nb.save(mask_img, fname_presuffix(b0s_file, suffix="_brain_mask", use_ext=True))

    # bet
    cmd = f"bet {b0s_file} {fname_presuffix(b0s_file, suffix='_bet', use_ext=True)} -m -f 0.2"
    os.system(cmd)

    # Consensus
    otsu_mask = fname_presuffix(b0s_file, suffix='_brain_mask', use_ext=True)
    bet_mask = fname_presuffix(b0s_file, suffix='_bet_mask', use_ext=True)
    out_mask = fname_presuffix(b0s_file, suffix='_consensus_mask', use_ext=True)
    cmd = f"fslmaths {otsu_mask} -mul {bet_mask} {out_mask}"
    os.system(cmd)
    return otsu_mask, bet_mask, out_mask

def get_parser():
    """Parse command-line inputs"""

    parser = argparse.ArgumentParser(
        description="Extract B0's and make a mask for each")
    parser.add_argument(
        "-dwi",
        metavar="Path to diffusion-weighted imaging data file",
        default=None,
        help="Specify a path to a preprocessed dmri diffusion "
             "Nifti1Image in native diffusion space and in .nii or "
             ".nii.gz format.\n",
    )
    parser.add_argument(
        "-bval",
        metavar="Path to b-values file",
        default=None,
        help="Specify a path to a b-values text file containing "
             "gradient shell values per diffusion direction.\n",
    )
    parser.add_argument(
        "-cores",
        default="4",
        nargs=1,
        choices=["2", "4", "6"],
        help="Optionally use this flag if you wish to change the number of"
             "cores for multiprocessing. Default is 4.\n",
    )
    parser.add_argument(
        "-backend",
        default="multiprocessing",
        nargs=1,
        choices=["loky", "multiprocessing", "threading"],
        help="Optionally use this flag if you wish to change the backend."
             "Default is multiprocessing.\n",
    )
    return parser

if __name__ == "__main__":

    args = get_parser().parse_args()
    dwi_file = args.dwi
    fbvals = args.bval
    num_processes = args.cores[0]
    parallel_backend = args.backend[0]
    print(num_processes)
    print(parallel_backend)
    print(dwi_file)
    print(fbvals)

    bvals = np.genfromtxt(fbvals, dtype=float)
    print(bvals)

    try:
        b0_ixs = get_bval_indices(bvals, bval=0, tol=50)
        print(b0_ixs)
    except:
        print("Run failed")
        sys.exit(1)

    try:
        with joblib.Parallel(n_jobs=int(num_processes),
                             backend=str(parallel_backend),
                             mmap_mode='r+') as parallel:
            out = parallel(
                joblib.delayed(make_b0_masks)(dwi_file, b0_ix) for
                b0_ix in b0_ixs)
        print(out)
    except:
        print("Run failed")
        sys.exit(1)

    sys.exit(0)

