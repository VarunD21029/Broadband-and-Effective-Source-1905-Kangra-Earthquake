# Broadband-and-Effective-Source-1905-Kangra-Earthquake
The repository contains the source and results files related to work titled "Broadband Ground-Motion Simulations of the 1905 Kangra Earthquake: Source Uncertainty and Macroseismic Constraints". The manuscript is currently under review.
# Broadband and Effective Source: 1905 Kangra Earthquake

Code and data for the physics-based broadband ground-motion simulation of the 1905 Kangra
earthquake (Mw 7.8, NW Himalaya) and the selection of the effective rupture model from the reported
macroseismic intensities.

## Workflow

1. **Rupture realizations**: stochastic slip models of the 1905 rupture, simulated with SPECFEM3D.
   25 realizations (R1–R25) are used; realization *k* corresponds to simulation
   `SIM_ID = [1–11, 14, 15, 16, 18, 19, 21–26, 28, 30, 32]` (e.g. R10 = simulation 10).
2. **Physics-based spectra**: SPECFEM3D records at 21 sites, low-pass 1.5 Hz and band-pass
   0.001–2 Hz, RotD50 at 5 % damping.
3. **Broadband spectra**: an ANN extends the physics-based RotD50 below the cross-over period, using
   Mw 7.8, Vs30, distance and fault type (reverse); the physics-based RotD50 is kept above it.
4. **Synthetic intensity**: PGA converted to MMI with 9 PGA–MMI relationships at the 12 sites with
   reported intensities.
5. **Selection of the effective source**: RMSE between synthetic and reported intensities for each
   realization and relationship (25 × 9), ranked by TOPSIS (vector normalisation, equal weights).
   For Sundernagar the intensity reported for Suket (MSK VIII), the former princely state with its
   capital at Sundernagar, is used. Best realization: **R10** (TOPSIS score 0.861), followed by R13
   (0.833), R1 (0.771) and R19 (0.701).

## Contents

### `code/broadband_ann`

| File | Description |
|---|---|
| `rodt50.m` | Reads the SPECFEM3D records (`*E.sema`, `*N.sema`), filters them, computes RotD50 and the broadband spectra with the ANN |
| `BBANN_him_Final_T1.m` | Trained ANN (MATLAB neural-network function) for the short-period part of the broadband spectrum |
| `responsespectrum.m` | Elastic response spectrum (Newmark method) |

### `data`

| File / folder | Description |
|---|---|
| `macroseismic/Intensity.xlsx` | `Rhyp_for_MMI`: hypocentral distances of the 21 sites for each simulation; `R1`–`R25`: synthetic MMI at the 21 sites from the 9 PGA–MMI relationships (Formula1–9); `intensities_recorded`: reported intensities at the 12 sites; `TOPSIS scores` |
| `macroseismic/Spectra Estimates.xls` | PGV, PGA and Sa(0.3, 1, 2, 3 s) at the 21 sites for realizations S1–S25, with site coordinates |
| `rupture_models/Kangra_1905_15_4_2025_<SIM>.mat` | Fault grid (`lat_grid`, `lon_grid`, `depth_grid`), slip realizations (`par`) and rupture-time shifts (`xshift`, `yshift`) of each simulation |
| `rupture_models/slipcolor.mat` | Colour map used for the slip figures |
| `BB_spectra_R1-R25.xlsx` | Broadband spectra of all 25 realizations at the 21 sites, one sheet per realization: `Period_s` (0 = PGA) and Sa (g) per site. ANN for T < 1 s, physics-based RotD50 for T ≥ 1 s |
| `BB_spectra_all_models.csv` | The same spectra in long format (`model, simulation, station, period_s, Sa_g, source`) |
| `rmse_matrix_25x9.csv` | RMSE (intensity units) of each realization (rows M1–M25) for each PGA–MMI relationship (R1–R9) |
| `topsis_ranking.csv` | TOPSIS closeness (equal and entropy weights), mean RMSE, Borda count and Pareto optimality of each realization |
| `MMI Figures/` | 3D bar charts of the synthetic MMI (relationship × site) for each realization, `mmi3d_M01`–`M25` (PNG, PDF) |

The 9 PGA–MMI relationships, in the column order of `rmse_matrix_25x9.csv`: Arioglu et al. (2001);
Iyengar & Kanth (2004); Atkinson & Kaka (2007); Tselentis & Danciu (2008); Faenza & Michelini (2010);
Bilal & Askan (2014); Panjamani et al. (2016) with PGA only, with PGA, Mw and R, and with PGA, Mw, R
and Vs30.

`rmse_matrix_25x9.csv` and `topsis_ranking.csv` use the Suket intensity (MSK VIII) for Sundernagar;
`intensities_recorded` in `Intensity.xlsx` lists the originally compiled value (6).

## Sites

Bilaspur, Chamba, Dankar, Dharamshala, Hamirpur, Kalpa, Kangra, Keylong, Kullu, Manali, Mandi, Nako,
Peo, Rampur, Shimla (3 sites), Solan, Sundernagar, Tabo, Una. Reported intensities are available at
12 of them: Bilaspur, Chamba, Dharamshala, Hamirpur, Kangra, Kullu, Mandi, Manali, Rampur, Shimla,
Solan and Sundernagar.

## Requirements

MATLAB (R2024b used) with the Signal Processing Toolbox. `rodt50.m` also calls
`RotDxx_Calculations.m` (S. Azar, revised by J. Fayaz), which is not included here.
