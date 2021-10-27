## Requirements

ALICE has been developed and so-far tested for a range of Linux and macOS environments. Windows users may encounter problems with some package versions, and we are currently looking into this.

Packages:

- Conda (https://docs.conda.io/en/latest/)
- CMake (```pip install cmake``` or ```conda install cmake```)
- Sox (http://sox.sourceforge.net/ , ```brew install sox``` (macOS with Homebrew installed), ```sudo apt-get install sox```(Ubuntu))

(other packages are automatically installed by conda environment)

# Installation 

- Clone the repository with submodules :

```bash
git clone --recurse-submodules https://github.com/orasanen/ALICE/
```

- Make sure you have Conda, Cmake and Sox installed.

- Create the conda environment installing all the dependencies. Note that this is OS dependent:

```bash
cd ALICE
```  

On Linux:  
```
conda env create -f ALICE_Linux.yml 
```

On macOS:  
```  
conda env create -f ALICE_macOS.yml 
```

And you're done! 

