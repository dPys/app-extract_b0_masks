<h1 align="center">extract_b0_masks</h1>

<p align="center">
  Extracts each b0 volume from a DWI series and computes brain masks for it with DIPY median_otsu and FSL BET, plus a consensus mask.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.600"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.600-blue.svg" alt="Run on brainlife.io"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Extracts each b0 volume from a DWI series and computes brain masks for it with DIPY median_otsu and FSL BET, plus a consensus mask.**

For every b=0 volume (bval within 50 of zero) it saves the volume, a median_otsu brain and mask, a BET mask (-f 0.2) and their product as a consensus mask, processing volumes in parallel. Use it to compare or QC b0 brain masks across a DWI run. The script writes its files next to the input DWI rather than into the output folder.

| | |
|---|---|
| **Inputs** | `neuro/dwi` |
| **Outputs** | `neuro/dwi/b0` |
| **Container** | `dpys/extract_b0_mask:latest` |
| **Resources** | 4 CPUs · 4 GB memory · 0.5 h walltime |
| **Run it** | [doi.org/10.25663/brainlife.app.600](https://doi.org/10.25663/brainlife.app.600) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | DWI series with bvals; b0 volumes are identified from the bvals. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `b0_extractions` | `neuro/dwi/b0` | Extracted b0 volumes with median_otsu, BET and consensus brain masks. |

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.600](https://doi.org/10.25663/brainlife.app.600), choose `neuro/dwi` from your project and press **Execute**. The results are saved to your project as `neuro/dwi/b0`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) (the App runs in `dpys/extract_b0_mask:latest`), [`jq`](https://jqlang.github.io/jq/).

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "dwi": "/path/to/dwi/dwi",
       "bvecs": "/path/to/dwi/bvecs",
       "bvals": "/path/to/dwi/bvals",
       "sbref": "/path/to/dwi/sbref",
       "sbref_json": "/path/to/dwi/sbref_json"
   }
   ```

3. Run `./main`.

## Citing

If you use this App, please cite it, the software it builds on and brainlife.io:

- extract_b0_masks. brainlife.io App. [doi:10.25663/brainlife.app.600](https://doi.org/10.25663/brainlife.app.600)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Garyfallidis et al. Dipy, a library for the analysis of diffusion MRI data. *Frontiers in Neuroinformatics* 8 (2014). [doi:10.3389/fninf.2014.00008](https://doi.org/10.3389/fninf.2014.00008)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

Maintained by [@dPys](https://github.com/dPys).
