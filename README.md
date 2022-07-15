# DeltaPower
Scripts used for DORA/THIP 2022 paper

Hello! I'm excited that you're interested in this code. This is my first time doing this, but I will do my best to describe the code effectively.
I will also be writing this for future lab members with potentially no coding experience, so feel free to skim if you're experienced!
If you have any lingering questions do not hesistate to reach out to me at djlasky@wisc.edu or whatever email I now have listed.

The purpose of these scripts was to quantify the delta power of mouse EEGs. This was done through a series of steps that are carried out individually by each of the
written scripts. The only script that will be necessary to hit "run" on will be the "LaskyMaster" which will run all the other scripts for you in the correct sequence.
Below I will describe each of the scripts included in the order that they are run:

LaskyMaster: The control tower. Allows for a centralized place to observe the process and easily tell which individual functions result in an error. This is where you
will set the file names to be run (EDFs/TSVs) and the input/output directories.

LaskyRead: Reads in the EDF (and TSV if being used). Identifies the right frontal channel and then expands the data array. Script will pull an error if the
EDF was not sampled at 512 Hz, the TSV (if provided) was not sleep scored in 4 second epochs, and if the TSV (if provided) did not have a minimum bout length of 16 
seconds (4 epochs). These are all parameters we wanted hold constant in our experiments. The errors can be changed or removed at the bottom of this script 
as necessary. The TSV format used in this script was pulled from Sirenia Sleep by scoring in 4 seconds epoch, then clicking "Sleep/Bout Analysis" (the column graph 
icon), making sure "Length (epochs)" was set to 4, then clicking "Save TSV." This output is different from "Save Everything TSV." DO NOT USE THAT ONE.

normalizeEEG: Written by Jesse Pfammatter (JP). Performs a full signal normalization using a Gaussian function. Outputs the mean, standard deviation, and fit of this
normalization curve.

sixtyHzFilt_EEG: Written by Jesse Pfammatter (JP). Nested in the normalizeEEG function. Runs prior to the full signal normalization and removes 60-Hz artifact.

highPassChebyshev1Filt_EEG: Written by Jesse Pfammatter (JP). Nested in the normalizeEEG function. Runs prior to the full signal normalization and attenuates signals
that fall below the cut-off frequency.

fit_gauss: Written by Jesse Pfammatter (JP). Nested in the normalizeEEG function. Runs as part of the full-signal normalization to fit the curve to a Gaussian.

LaskyPower: Quantifies delta, theta, sigma, and gamma power for each epoch using a method recommended by Dr. Mathew Jones. Uses a simple power spectrum.

LaskyAlign: Aligns all of the files to Zeitgeber time = 0. If your recordings consistently start when the lights come on this script will be unnecessary. There were
additional complications in our files due to the computers not adjusting for daylight savings time. Realigning that data was the function of this script.

LaskyTSV: Only runs if you have a TSV (useTSV = 1 on line 15. Removes the unnecessary columns, keeping just start epoch, sleep state, and length. Changes length from
epochs to seconds. Aligns the TSV to match the EDF alignment. Adds a new column for end epochs.

LaskyNormHour: Performs normalization of delta by calculating delta/(theta+sigma+gamma) and normalization of gamma by calculating gamma/(delta+theta+sigma). Also
removes outlier/artifactial points by removing epochs that have a Z-score >= 3. Saves off all epochs for delta and gamma in three ways: unchanged, normalized, 
normalized and Z-score filtered. Calculates the hourly averages for all of these and saves them off again in an hourly format.

LaskySingle24Hr: Takes a single file and displays the hourly delta power and hourly gamma power as line graphs. The graph is currently set-up to display the
normalized and Z-score filtered hourly data. The background colors of the graph represent when the lights were on (yellow) and lights were off (gray).

LaskyGroup24Hr: Allows you to set 6 different treatments and graph their hourly delta power means and SEMs. The graph is currently set-up to display the
normalized and Z-score filtered hourly data. The background colors of the graph represent when the lights were on (yellow) and lights were off (gray). Also outputs
A .csv containing the graphed hourly treatment means and SEMs.
