# Radar export

An R script to export objects from Radar

radar_export downloads files from Radar and saves them with the identifier added to the file name.

check_export verifies that all objects were downloaded in the initial export. Compares identifiers in the file names to identifiers in Radar metadata and returns the PID of any items

zip_test is to confirm that zip files and contents are able to be opened and are not damaged. It returns a list of file names that are possibly damaged.


