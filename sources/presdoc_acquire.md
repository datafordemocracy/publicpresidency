## Formal Presidential Documents

Used the [Compilation of Presidential Documents collection](https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD). The `acquire_presdoc.R` script
* grabs metadata (document id, title, date, type) from web page
* grabs the plain text of the documents and downloads as .txt files into /docs folder
* generates `presdoc.RData` with initial metadata

The `preprocess_pres.py` script or `process_presdoc.R` script
* reads text files in from /docs folder
* captures metadata fields at the bottom (DCPD number, subjects, names, locations, categories, notes)
* outputs text and metadata as `presDocument.csv`.
