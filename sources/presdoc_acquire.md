## Formal Presidential Documents

Used the [Compilation of Presidential Documents collection](https://www.gpo.gov/fdsys/browse/collection.action?collectionCode=CPD). The `acquire_presdoc.R` script
* Grabs metadata (document id, title, date, type)
* Grabs the plain text of the document and downloads as .txt file

The `preprocess_pres.py` script
* reads text files in
* captures metadata fields at the bottom (DCPD number, subjects, names, locations, categories, notes)
* and outputs text and metadata as `presDocument.csv`.
