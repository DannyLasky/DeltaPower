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
as necessary. The TSV format used in this script was pulled from Sirenia Sleep by scoring in 4 seconds epochs, then clicking "Sleep/Bout Analysis" (the column graph 
icon), making sure "Length (epochs)" was set to 4, then clicking "Save TSV." This output is different from "Save Everything TSV." DO NOT USE THAT ONE.

normalizeEEG: Written by 





















