This is a simple attempt to scrape some data from a PuppetDB installation.

The dump.sh script outputs a processors, memory, and kernel fact data file from your PuppetDB install.

The pdb_dump_clean.rb script generates to files: puppetdb.json and instances.json

puppetdb.json is just a cleaned record of your puppetdb data (certnames obfuscated) along with memory, processor, and kernel information.

Instances.json is an attempt to map that above record to various EC2 sizes / types to aid in filling out the AWS Simple Monthly Calculator.

From the server running PuppetDB, you clone this repo, put dump.sh and pdb_dump_clean.rb in it, and run dump.sh then pdb_dump_clean.rb, and you should get the two resulting files. The examples folder contains output from a test run of this script for your reference.
