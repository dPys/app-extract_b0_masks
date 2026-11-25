<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Extracts each b0 volume from a DWI series and computes brain masks for it with DIPY median_otsu and FSL BET, plus a consensus mask.**

For every b=0 volume (bval within 50 of zero) it saves the volume, a median_otsu brain and mask, a BET mask (-f 0.2) and their product as a consensus mask, processing volumes in parallel. Use it to compare or QC b0 brain masks across a DWI run. The script writes its files next to the input DWI rather than into the output folder.

| | |
|---|---|
| 📥 **Inputs** | `neuro/dwi` |
| 📤 **Outputs** | `neuro/dwi/b0` |
| 🐳 **Container** | `dpys/extract_b0_mask:latest` |
| ⚙️ **Resources** | 4 CPUs · 4 GB memory · 0.5 h walltime |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.600](https://doi.org/10.25663/brainlife.app.600) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `dwi` | `neuro/dwi` | yes | DWI series with bvals; b0 volumes are identified from the bvals. |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `b0_extractions` | `neuro/dwi/b0` | Extracted b0 volumes with median_otsu, BET and consensus brain masks. |

<!-- brainlife-app:end -->

# app-extract_b0_masks