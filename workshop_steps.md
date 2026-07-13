# Workshop setup: running the integrative DDM pipeline with Docker

These steps assume you have never used Docker or a terminal before. Follow them
in order on your own laptop (Mac or Windows).

## 1. Install Docker Desktop

- Go to https://www.docker.com/products/docker-desktop/ and download Docker
  Desktop for your operating system (Mac or Windows).
- Run the installer and open Docker Desktop once. On Windows, the installer
  may ask to enable "WSL 2" — accept this and restart your computer if asked.
- Wait until Docker Desktop shows it is "running" (a whale icon in the menu
  bar on Mac, or system tray on Windows).

## 2. Get the code

- Open the GitHub page for this repository in your browser.
- Click the green **Code** button, then **Download ZIP**.
- Find the downloaded `.zip` file (usually in your `Downloads` folder) and
  double-click it to extract/unzip it.
- The extracted folder name may have a branch name attached to it, e.g.
  `single_trial_nddm_compare-workshop_demo` — that's expected and fine.

## 3. Open a terminal

A terminal is a text window where you type commands instead of clicking.

### Mac

- Press `Command (⌘) + Space` to open Spotlight, type `Terminal`, and press
  Enter. A black/white text window opens — this is your terminal.
- Type `cd ` (with a trailing space, don't press Enter yet), then drag the
  extracted project folder from Finder directly into the terminal window.
  This automatically fills in the correct folder path. Press Enter.
- You should now be "inside" the project folder. You can check with `ls`,
  which lists the files there — you should see `Dockerfile` in the list.

### Windows

- Click the Start menu, type `PowerShell`, and open **Windows PowerShell**.
- Type `cd ` (with a trailing space, don't press Enter yet), then drag the
  extracted project folder from File Explorer directly into the PowerShell
  window. This fills in the correct folder path. Press Enter.
- You should now be "inside" the project folder. You can check with `dir`,
  which lists the files there — you should see `Dockerfile` in the list.

## 4. Build the image

This step reads the `Dockerfile` and installs everything the project needs
(Python, packages, etc.) into a self-contained image. It only needs to be
done once (or again later if the code changes).

In your terminal (Mac Terminal or Windows PowerShell), from inside the
project folder, run:

```
docker build -t single_trial_nddm_compare .
```

This can take several minutes the first time. You'll see a lot of text
scroll by — that's normal.

## 5. Run the pipeline

This step actually runs the four scripts in order:
`integrative_ddm_train.py` → `integrative_ddm_generate_factorial_new_sigma.py`
→ `integrative_ddm_data_check.py` → `integrative_ddm_analyze_results_factorial.py`.

The `-v` part below tells Docker to save all output (model checkpoints and
figures) into the `integrative_model` folder on your own computer, so you can
view them after the run finishes, even though the container itself is
temporary.

**Mac Terminal:**
```
docker run --rm -v "$(pwd)/integrative_model:/app/integrative_model" single_trial_nddm_compare
```

**Windows PowerShell:**
```
docker run --rm -v "${PWD}/integrative_model:/app/integrative_model" single_trial_nddm_compare
```

This should take only a little time to run because the model is pretrained. 
When it's done, open the `integrative_model/Figures` folder inside your project folder — the plots
will be there as regular `.png` files. Also look inside `integrative_model/figures_new_sigma_new_conditions` for recovery plots under different model-specification conditions. [See our preprint for more details.](https://osf.io/preprints/psyarxiv/7d46a_v2)

### Running just one script instead of all four

If you only want to run a single script (for example, just the analysis
script) instead of the full pipeline, add its path to the end of the same
command:

**Mac Terminal:**
```
docker run --rm -v "$(pwd)/integrative_model:/app/integrative_model" single_trial_nddm_compare scripts/integrative_ddm_analyze.py
```

**Windows PowerShell:**
```
docker run --rm -v "${PWD}/integrative_model:/app/integrative_model" single_trial_nddm_compare scripts/integrative_ddm_analyze.py
```

## 6. Learn further about what you did

### Inspecting the integrative model

Find the `integrative_model/simulation.py` file and look at how simple the model simulation is (relatively). The `simulate_trial()` definition is how you simulate one trial of the integrative model. 

Test questions:
  
* Which function draws parameter values from the "prior" distribution?
* Which function simulates multiple experimental trials?
* Which function is basically just a wrapper of another for BayesFlow?

### Training the model using BayesFlow 2

Find the `integrative_model/workflow.py` file. This file contains the information / commands for the [BayesFlow 2](https://arxiv.org/abs/2602.07098) package. We kept a lot of defaults / recommendations for training the integrative model. 

Test questions:

* What inference network did we use?
* What summary network did we use?
* What is the difference between the inference and summary networks?
* What is the point of the adapter object?
* Did we use a fixed number of trials to train the model or a variable number of trials?

Harder questions: 

* Can we train the model better? 
* Can we train it faster?

### Evaluating model training

After running the pipeline using Docker (see above), look in your new `integrative_model/Figures` folder.

Test questions:

* Did the network training converge? How do you know it did?
* What is the difference between the simulation and validation plots?

### Evaluating the model

Read or skim [our preprint](https://osf.io/preprints/psyarxiv/7d46a_v2). 

Test questions:

* What are recovery plots?
* Where are the recovery plots in your local folder after running the pipeline?
