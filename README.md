# omc_work ✅

**OpenModelica workflow, tools and examples for interactive modelling, simulation and testing** 🔧

This repository gathers scripts, notebooks, templates and helper code to make it easy to create, run and debug OpenModelica models using the `omc` CLI and the `OMPython` Python interface.

---

## Highlights 💡

- Interactive examples and utilities are in `scripts/` and illustrated in `scripts/omc_test_main_example.ipynb` (IPython magics + `OMPython.ModelicaSystem`).
- Model files, reusable libraries and small demos live in `models/`.
- `work/` contains build artifacts produced by `omc` when models are simulated.

---

## Quick start 🚀

Requirements:

- OpenModelica (provides `omc`) installed and on your `PATH`.
- Python 3.8+ with the following packages:
  - `OMPython`
  - `pandas`, `matplotlib`
  - `ipython` / `jupyter` (for notebooks)

Example steps:

1. Open the example notebook `scripts/omc_test_main_example.ipynb` and run the cells to:
   - Start an `OMCSessionZMQ()` session.
   - Register and use IPython magics for Modelica code (`%%modelica`, `%%modelica simulate`, `%%modelica_script`).
   - Use `OMPython.ModelicaSystem` to load `.mo` files, set parameters, simulate and collect results.

2. To run a `.mos` script directly with `omc` (from the repository root):

```
omc "scripts/test_run.mos"
```

Or use the included VS Code task **Run .mos with omc**.

---

## Usage examples 🔍

- Interactive magic cells let you write Modelica code inline in a notebook and run simulations (see `%%modelica` examples in the notebook).
- `ModelicaSystem` is used to load `models/MyModel.mo` or `NewtonCooling.mo`, set parameters and plot simulation results with `matplotlib`.
- `%%modelica_script` is a useful way to run a sequence of `omc` commands from a notebook cell.

---

## Project layout 📂

- `scripts/` — notebooks, helper scripts, and `.mos` examples (e.g., `omc_test_main_example.ipynb`).
- `models/` — Modelica `.mo` model files and libraries.
- `work/` — build/simulation outputs created by `omc`.
- `README.md` — this file.

---

## Development & Contributing 🤝

- Add example models to `models/` and corresponding scripts or notebook cells to `scripts/` demonstrating usage.
- If you add new IPython magics or helper functions, document them in the notebook and add tests where appropriate.
- Open a PR with a clear description and example demonstrating the feature.

---

## More resources 📚

- OpenModelica documentation: https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/
- `OMPython` docs: https://openmodelica.org/doc/OpenModelicaUsersGuide/latest/ompython.html

---

If something in the examples is unclear, open an issue or add a short example in `scripts/omc_test_main_example.ipynb` and I'll take a look. ✅

